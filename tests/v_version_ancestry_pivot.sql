-- ============================================================================
-- View: public.v_version_ancestry_pivot  (+ tg_version_ancestry_pivot_refresh)
-- Verifies the dynamic-column ancestry pivot:
--   • one row, one uuid[] column per dataset version
--   • deep version cell = ordered ancestor array (root-first)
--   • root version cell = NULL
--   • inserting a version adds its column (trigger rebuild)
--   • deleting it removes the column (DROP + CREATE path)
--
-- Uses the seeded customer-churn-signals lineage:
--   ff000001 (v1, root) → ff000002 (v2) → ff000003 (v3)
--
-- DDL (the trigger's DROP/CREATE VIEW) is transactional in PostgreSQL, so the
-- whole test runs inside one BEGIN … ROLLBACK and leaves no trace.
-- ============================================================================

BEGIN;

-- ─── Shape: one row, column per seeded version ───────────────────────────────

SELECT count(*) AS row_count
FROM public.v_version_ancestry_pivot;
-- Expected: row_count = 1

SELECT count(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'v_version_ancestry_pivot';
-- Expected: column_count = 12  (one per seeded dataset version)


-- ─── Deep version (churn v3) → ordered ancestor array [v1, v2] ───────────────

SELECT "ff000003-0000-0000-0000-000000000000" AS churn_v3_ancestors
FROM public.v_version_ancestry_pivot;
-- Expected: {ff000001-0000-0000-0000-000000000000,ff000002-0000-0000-0000-000000000000}
--           (root-first: v1 then v2)


-- ─── Root version (churn v1) → NULL ──────────────────────────────────────────

SELECT "ff000001-0000-0000-0000-000000000000" IS NULL AS root_is_null
FROM public.v_version_ancestry_pivot;
-- Expected: root_is_null = true


-- ─── Trigger: INSERT a child version adds its column ─────────────────────────
-- New v4 under customer-churn-signals (ee000001), child of v3 (ff000003).

INSERT INTO datasets.dataset_versions
  (version_id, dataset_id, version_number, schema_definition, parent_version_id, created_by) VALUES
  ('ff0000a4-0000-0000-0000-000000000000', 'ee000001-0000-0000-0000-000000000000',
   4, '{"fields": [{"name": "x", "type": "int"}]}',
   'ff000003-0000-0000-0000-000000000000', 'bb000001-0000-0000-0000-000000000000');

SELECT count(*) AS column_count_after_insert
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'v_version_ancestry_pivot';
-- Expected: column_count_after_insert = 13

SELECT "ff0000a4-0000-0000-0000-000000000000" AS churn_v4_ancestors
FROM public.v_version_ancestry_pivot;
-- Expected: {ff000001-...,ff000002-...,ff000003-...}  (full chain, root-first)


-- ─── Trigger: DELETE the version removes its column (DROP + CREATE) ───────────

DELETE FROM datasets.dataset_versions
  WHERE version_id = 'ff0000a4-0000-0000-0000-000000000000';

SELECT count(*) AS column_count_after_delete
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name   = 'v_version_ancestry_pivot';
-- Expected: column_count_after_delete = 12  (back to the seeded set)

ROLLBACK;
