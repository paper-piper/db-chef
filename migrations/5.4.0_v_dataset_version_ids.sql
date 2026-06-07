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
-- triggers on ds.datasets and ds.dataset_versions keep it current.
-- ============================================================================


-- ─── Builder ──────────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_build_dataset_version_ids()
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  v_cols text;
BEGIN
  -- One column per dataset; each cell picks the nth version via OFFSET.
  SELECT string_agg(
    format(
      'COALESCE('
      || '  (SELECT version_id::text FROM ds.dataset_versions '
      || '   WHERE dataset_id = %L ORDER BY version_number LIMIT 1 OFFSET (n.i - 1)),'
      || '  ''-'') AS %I',
      dataset_id, dataset_id::text),
    E',\n  '
    ORDER BY dataset_key)
  INTO v_cols
  FROM ds.datasets;

  EXECUTE 'DROP VIEW IF EXISTS public.v_dataset_version_ids';

  IF v_cols IS NULL THEN
    EXECUTE 'CREATE VIEW public.v_dataset_version_ids AS '
         || 'SELECT ''-''::text AS _no_datasets WHERE false';
  ELSE
    -- generate_series(1, 0) returns no rows, so if there are no versions the
    -- view is empty (rather than a row of all '-').
    EXECUTE format(
      'CREATE VIEW public.v_dataset_version_ids AS '
      || 'SELECT %s '
      || 'FROM generate_series(1, ('
      || '  SELECT COALESCE(MAX(cnt), 0)::int '
      || '  FROM (SELECT COUNT(*)::int AS cnt FROM ds.dataset_versions GROUP BY dataset_id) t'
      || ')) AS n(i)',
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
  AFTER INSERT OR UPDATE OR DELETE ON ds.dataset_versions
  FOR EACH STATEMENT EXECUTE FUNCTION public.fn_dataset_version_ids_refresh();

CREATE TRIGGER tg_dataset_version_ids_refresh_on_datasets
  AFTER INSERT OR UPDATE OR DELETE ON ds.datasets
  FOR EACH STATEMENT EXECUTE FUNCTION public.fn_dataset_version_ids_refresh();


-- ─── Initial build ────────────────────────────────────────────────────────────

SELECT public.fn_build_dataset_version_ids();
