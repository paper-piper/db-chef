-- ============================================================================
-- ADVANCED ANALYTICS: DATASET VERSION IDS PIVOT
-- ============================================================================
-- Dynamic view where each column is a dataset_id and each row is a slot for
-- a version_id. Slots are filled top-down by version_number; datasets with
-- fewer versions than the maximum show '-' in the remaining rows.
--
-- Example (3 datasets, max 3 versions):
--
--   ee000001  | ee000002  | ee000003
--   ----------+-----------+---------
--   ff000001  | ff000004  | ff000007
--   ff000002  | ff000005  | -
--   ff000003  | -         | -
--
-- Cannot be a static view — column list grows with every new dataset.
-- A builder function regenerates it via dynamic SQL, and statement-level
-- triggers on datasets.datasets and datasets.dataset_versions keep it current.
-- ============================================================================


-- ─── Builder ──────────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_build_dataset_version_ids()
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  v_cols text;
BEGIN
  PERFORM set_config('client_min_messages', 'warning', true);

  -- One column per dataset. Versions are pre-ranked inside a CTE; the pivot
  -- uses conditional aggregates over a single scan instead of one correlated
  -- subquery per dataset per row.
  SELECT string_agg(
    format(
      'COALESCE(MIN(version_id) FILTER (WHERE dataset_id = %L), ''-'') AS %I',
      id, id::text),
    E',\n  '
    ORDER BY dataset_key)
  INTO v_cols
  FROM datasets.datasets;

  EXECUTE 'DROP VIEW IF EXISTS public.v_dataset_version_ids';

  IF v_cols IS NULL THEN
    EXECUTE 'CREATE VIEW public.v_dataset_version_ids AS '
         || 'SELECT ''-''::text AS _no_datasets WHERE false';
  ELSE
    -- generate_series(1, 0) returns no rows, so if there are no versions the
    -- view is empty (rather than a row of all '-').
    EXECUTE format(
      'CREATE VIEW public.v_dataset_version_ids AS '
      || 'WITH ranked AS ('
      || '  SELECT dataset_id, version_id::text AS version_id,'
      || '    ROW_NUMBER() OVER (PARTITION BY dataset_id ORDER BY version_number) AS rn'
      || '  FROM datasets.dataset_versions'
      || ') '
      || 'SELECT %s '
      || 'FROM generate_series(1, ('
      || '  SELECT COALESCE(MAX(cnt), 0)::int '
      || '  FROM (SELECT COUNT(*)::int AS cnt FROM datasets.dataset_versions GROUP BY dataset_id) t'
      || ')) AS n(i) '
      || 'LEFT JOIN ranked ON ranked.rn = n.i '
      || 'GROUP BY n.i '
      || 'ORDER BY n.i',
      v_cols);
  END IF;
END;
$$;


-- ─── Auto-refresh triggers ────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_dataset_version_ids_refresh()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  PERFORM public.fn_build_dataset_version_ids();
  RETURN NULL;
END;
$$;

CREATE TRIGGER tg_dataset_version_ids_refresh_on_versions
  AFTER INSERT OR UPDATE OR DELETE ON datasets.dataset_versions
  FOR EACH STATEMENT EXECUTE FUNCTION public.fn_dataset_version_ids_refresh();

CREATE TRIGGER tg_dataset_version_ids_refresh_on_datasets
  AFTER INSERT OR UPDATE OR DELETE ON datasets.datasets
  FOR EACH STATEMENT EXECUTE FUNCTION public.fn_dataset_version_ids_refresh();


-- ─── Initial build ────────────────────────────────────────────────────────────

DO $$ BEGIN PERFORM public.fn_build_dataset_version_ids(); END $$;
