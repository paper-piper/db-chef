-- ============================================================================
-- DYNAMIC-COLUMN VERSION ANCESTRY PIVOT
-- ============================================================================
-- Builds public.v_version_ancestry_pivot: a single-row view whose columns are
-- ALL dataset version_ids, each cell holding that version's recursive ancestor
-- array (parent, grandparent, … to root, root-first ordered). Roots map to NULL.
--
-- A plain VIEW has a fixed column list, so a real-column pivot over a growing set
-- of versions cannot be a static view. Instead a builder function regenerates the
-- view via dynamic SQL, and a statement-level trigger on ds.dataset_versions
-- re-runs it whenever the set of versions changes.
--
-- Caveats:
--   • PostgreSQL caps a relation at 1600 columns → at most ~1600 versions.
--   • Each version write triggers a DROP + CREATE VIEW (ACCESS EXCLUSIVE on this
--     view only). Do NOT create objects that depend on this view, or the trigger's
--     DROP will fail without CASCADE.
--   • Column names are raw UUID strings (valid, quoted identifiers).
-- ============================================================================


-- ─── Builder ──────────────────────────────────────────────────────────────────
-- Regenerates the pivot view from the current set of dataset versions.
-- Reuses public.v_dataset_lineage, which already exposes lineage_chain
-- (uuid[], ordered root→self). Ancestors = chain minus its last element.

CREATE OR REPLACE FUNCTION public.fn_build_version_ancestry_pivot()
RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  v_cols text;
BEGIN
  -- One scalar-subquery column per version, ordered by dataset then version number.
  SELECT string_agg(
    format(
      '(SELECT CASE WHEN array_length(l.lineage_chain, 1) <= 1 THEN NULL '
      || 'ELSE l.lineage_chain[1 : array_length(l.lineage_chain, 1) - 1] END '
      || 'FROM public.v_dataset_lineage l WHERE l.version_id = %L) AS %I',
      version_id, version_id::text),
    E',\n  ' ORDER BY dataset_id, version_number)
  INTO v_cols
  FROM public.v_dataset_lineage;

  -- DROP + CREATE (not CREATE OR REPLACE): replace can only append columns, so it
  -- would fail whenever a version is removed or the column order changes.
  EXECUTE 'DROP VIEW IF EXISTS public.v_version_ancestry_pivot';

  IF v_cols IS NULL THEN
    -- No versions yet: build a placeholder so the view always exists.
    EXECUTE 'CREATE VIEW public.v_version_ancestry_pivot AS '
         || 'SELECT NULL::uuid[] AS _no_versions WHERE false';
  ELSE
    EXECUTE format(
      'CREATE VIEW public.v_version_ancestry_pivot AS SELECT %s', v_cols);
  END IF;
END;
$$;


-- ─── Auto-refresh trigger ─────────────────────────────────────────────────────
-- Statement-level: rebuild once per statement, not once per affected row.

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
-- Materialize the view now so it reflects already-seeded versions immediately.

SELECT public.fn_build_version_ancestry_pivot();
