-- ============================================================================
-- ADVANCED ANALYTICS: VERSION ANCESTRY PIVOT
-- ============================================================================
-- Dynamic view where each column is a version_id and the single row holds
-- that version's full recursive ancestor array (oldest ancestor first,
-- self excluded). Root versions map to NULL.
--
-- Column order: grouped by dataset, sorted by version_number within each.
--
-- Cannot be a static view — column list grows with every new version.
-- A builder function regenerates it via dynamic SQL, and a statement-level
-- trigger on ds.dataset_versions keeps it current automatically.
-- ============================================================================


-- ─── Builder ──────────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_build_version_ancestry_pivot()
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  v_cols text;
BEGIN
  -- One column per version. The WITH RECURSIVE lineage CTE is baked into the
  -- view body so it runs once per query, not once per column.
  SELECT string_agg(
    format(
      '(SELECT CASE WHEN array_length(chain, 1) <= 1 THEN NULL '
      || 'ELSE chain[1 : array_length(chain, 1) - 1] END '
      || 'FROM lineage WHERE version_id = %L) AS %I',
      version_id, version_id::text),
    E',\n  '
    ORDER BY dataset_id, version_number)
  INTO v_cols
  FROM ds.dataset_versions;

  EXECUTE 'DROP VIEW IF EXISTS public.v_version_ancestry_pivot';

  IF v_cols IS NULL THEN
    EXECUTE 'CREATE VIEW public.v_version_ancestry_pivot AS '
         || 'SELECT NULL::uuid[] AS _no_versions WHERE false';
  ELSE
    EXECUTE format(
      'CREATE VIEW public.v_version_ancestry_pivot AS '
      || 'WITH RECURSIVE lineage AS ('
      || '  SELECT version_id, ARRAY[version_id] AS chain '
      || '  FROM ds.dataset_versions WHERE parent_version_id IS NULL '
      || '  UNION ALL '
      || '  SELECT dv.version_id, l.chain || dv.version_id '
      || '  FROM ds.dataset_versions dv JOIN lineage l ON dv.parent_version_id = l.version_id'
      || ') '
      || 'SELECT %s',
      v_cols);
  END IF;
END;
$$;


-- ─── Auto-refresh trigger ─────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_version_ancestry_pivot_refresh()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  PERFORM public.fn_build_version_ancestry_pivot();
  RETURN NULL;
END;
$$;

CREATE TRIGGER tg_version_ancestry_pivot_refresh
  AFTER INSERT OR UPDATE OR DELETE ON ds.dataset_versions
  FOR EACH STATEMENT EXECUTE FUNCTION public.fn_version_ancestry_pivot_refresh();


-- ─── Initial build ────────────────────────────────────────────────────────────

SELECT public.fn_build_version_ancestry_pivot();
