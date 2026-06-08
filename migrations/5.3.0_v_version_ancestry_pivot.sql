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
-- trigger on datasets.dataset_versions keeps it current automatically.
-- ============================================================================


-- ─── Builder ──────────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION public.fn_build_version_ancestry_pivot()
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  v_cols text;
BEGIN
  PERFORM set_config('client_min_messages', 'warning', true);

  -- One column per version. The recursive walk and ancestor-array computation
  -- happen once in two CTEs (lineage → ancestors). Each column then reads its
  -- value with a conditional aggregate — a single scan over ancestors instead
  -- of one correlated subquery per version.
  SELECT string_agg(
    format(
      'MIN(ancestors) FILTER (WHERE version_id = %L) AS %I',
      version_id, version_id::text),
    E',\n  '
    ORDER BY dataset_id, version_number)
  INTO v_cols
  FROM datasets.dataset_versions;

  EXECUTE 'DROP VIEW IF EXISTS public.v_version_ancestry_pivot';

  IF v_cols IS NULL THEN
    EXECUTE 'CREATE VIEW public.v_version_ancestry_pivot AS '
         || 'SELECT NULL::uuid[] AS _no_versions WHERE false';
  ELSE
    EXECUTE format(
      'CREATE VIEW public.v_version_ancestry_pivot AS '
      || 'WITH RECURSIVE lineage AS ('
      || '  SELECT version_id, ARRAY[version_id] AS chain '
      || '  FROM datasets.dataset_versions WHERE parent_version_id IS NULL '
      || '  UNION ALL '
      || '  SELECT dv.version_id, l.chain || dv.version_id '
      || '  FROM datasets.dataset_versions dv JOIN lineage l ON dv.parent_version_id = l.version_id'
      || '), '
      || 'ancestors AS ('
      || '  SELECT version_id, '
      || '    CASE WHEN array_length(chain, 1) <= 1 THEN NULL '
      || '    ELSE chain[1 : array_length(chain, 1) - 1] END AS ancestors '
      || '  FROM lineage'
      || ') '
      || 'SELECT %s FROM ancestors',
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
  AFTER INSERT OR UPDATE OR DELETE ON datasets.dataset_versions
  FOR EACH STATEMENT EXECUTE FUNCTION public.fn_version_ancestry_pivot_refresh();


-- ─── Initial build ────────────────────────────────────────────────────────────

DO $$ BEGIN PERFORM public.fn_build_version_ancestry_pivot(); END $$;
