-- ============================================================================
-- Trigger: tg_ref_order_insert
-- Verifies that ref_order is always kept as a dense 1-based sequence
-- per experiment on INSERT.
--
-- Cases covered:
--   1. NULL ref_order         → appended at the end
--   2. Value beyond the range → clamped to next slot
--   3. Value in the middle    → existing rows pushed up, slot claimed
--   4. Value below 1          → clamped to 1, all rows pushed up
--   5. First insert ever      → lands at 1 regardless of input
-- ============================================================================

BEGIN;

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0010-0000-0000-0000-000000000000', 'Ref Order Tester', 'reforder@test.io');

INSERT INTO orgs.organizations (org_id, org_name) VALUES
  ('99bb0010-0000-0000-0000-000000000000', 'Test Org');

INSERT INTO ds.datasets (dataset_id, org_id, dataset_key, created_by) VALUES
  ('99cc0010-0000-0000-0000-000000000000', '99bb0010-0000-0000-0000-000000000000',
   'ref-order-ds', '99aa0010-0000-0000-0000-000000000000');

INSERT INTO ds.dataset_versions (version_id, dataset_id, version_number, schema_definition, created_by) VALUES
  ('99dd0010-0000-0000-0000-000000000000', '99cc0010-0000-0000-0000-000000000000', 1, '{"fields":[]}', '99aa0010-0000-0000-0000-000000000000'),
  ('99dd0011-0000-0000-0000-000000000000', '99cc0010-0000-0000-0000-000000000000', 2, '{"fields":[]}', '99aa0010-0000-0000-0000-000000000000'),
  ('99dd0012-0000-0000-0000-000000000000', '99cc0010-0000-0000-0000-000000000000', 3, '{"fields":[]}', '99aa0010-0000-0000-0000-000000000000'),
  ('99dd0013-0000-0000-0000-000000000000', '99cc0010-0000-0000-0000-000000000000', 4, '{"fields":[]}', '99aa0010-0000-0000-0000-000000000000'),
  ('99dd0014-0000-0000-0000-000000000000', '99cc0010-0000-0000-0000-000000000000', 5, '{"fields":[]}', '99aa0010-0000-0000-0000-000000000000'),
  ('99dd0015-0000-0000-0000-000000000000', '99cc0010-0000-0000-0000-000000000000', 6, '{"fields":[]}', '99aa0010-0000-0000-0000-000000000000'),
  ('99dd0016-0000-0000-0000-000000000000', '99cc0010-0000-0000-0000-000000000000', 7, '{"fields":[]}', '99aa0010-0000-0000-0000-000000000000');

INSERT INTO exp.experiments (experiment_id, org_id, experiment_name, created_by) VALUES
  ('99ee0010-0000-0000-0000-000000000000', '99bb0010-0000-0000-0000-000000000000',
   'Ref Order Test Exp', '99aa0010-0000-0000-0000-000000000000');


-- ─── Case 1: First insert ever → must land at 1 ──────────────────────────────

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order)
  VALUES ('99ee0010-0000-0000-0000-000000000000', '99dd0010-0000-0000-0000-000000000000', 99);

SELECT dataset_version_id, ref_order FROM exp.experiment_data_ver_refs
  WHERE experiment_id = '99ee0010-0000-0000-0000-000000000000'
  ORDER BY ref_order;
-- Expected: 1 row — ref_order = 1  (99 clamped to next = 1)


-- ─── Case 2: NULL ref_order → appended at the end ────────────────────────────

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order)
  VALUES ('99ee0010-0000-0000-0000-000000000000', '99dd0011-0000-0000-0000-000000000000', NULL);

SELECT dataset_version_id, ref_order FROM exp.experiment_data_ver_refs
  WHERE experiment_id = '99ee0010-0000-0000-0000-000000000000'
  ORDER BY ref_order;
-- Expected: 2 rows — ref_orders 1, 2


-- ─── Case 3: Value beyond the range → clamped to next slot ───────────────────

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order)
  VALUES ('99ee0010-0000-0000-0000-000000000000', '99dd0012-0000-0000-0000-000000000000', 50);

SELECT dataset_version_id, ref_order FROM exp.experiment_data_ver_refs
  WHERE experiment_id = '99ee0010-0000-0000-0000-000000000000'
  ORDER BY ref_order;
-- Expected: 3 rows — ref_orders 1, 2, 3  (50 clamped to 3)


-- ─── Build up to ref_orders 1..6 before the middle-insert test ───────────────

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order) VALUES
  ('99ee0010-0000-0000-0000-000000000000', '99dd0013-0000-0000-0000-000000000000', NULL),
  ('99ee0010-0000-0000-0000-000000000000', '99dd0014-0000-0000-0000-000000000000', NULL),
  ('99ee0010-0000-0000-0000-000000000000', '99dd0015-0000-0000-0000-000000000000', NULL);

SELECT dataset_version_id, ref_order FROM exp.experiment_data_ver_refs
  WHERE experiment_id = '99ee0010-0000-0000-0000-000000000000'
  ORDER BY ref_order;
-- Expected: 6 rows — ref_orders 1 through 6


-- ─── Case 4: Middle insert → existing rows pushed up ─────────────────────────
-- State before: 1, 2, 3, 4, 5, 6 — inserting at position 4

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order)
  VALUES ('99ee0010-0000-0000-0000-000000000000', '99dd0016-0000-0000-0000-000000000000', 4);

SELECT dataset_version_id, ref_order FROM exp.experiment_data_ver_refs
  WHERE experiment_id = '99ee0010-0000-0000-0000-000000000000'
  ORDER BY ref_order;
-- Expected: 7 rows — ref_orders 1, 2, 3, 4, 5, 6, 7
-- The new row (99dd0016) holds ref_order 4; former 4-6 are now 5-7


-- ─── Case 5: Value below 1 → clamped to 1, all rows pushed up ────────────────
-- Use a separate experiment to get a clean slate

INSERT INTO exp.experiments (experiment_id, org_id, experiment_name, created_by) VALUES
  ('99ee0011-0000-0000-0000-000000000000', '99bb0010-0000-0000-0000-000000000000',
   'Below-1 Test Exp', '99aa0010-0000-0000-0000-000000000000');

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order) VALUES
  ('99ee0011-0000-0000-0000-000000000000', '99dd0010-0000-0000-0000-000000000000', NULL),
  ('99ee0011-0000-0000-0000-000000000000', '99dd0011-0000-0000-0000-000000000000', NULL),
  ('99ee0011-0000-0000-0000-000000000000', '99dd0012-0000-0000-0000-000000000000', NULL);
-- State: 1, 2, 3

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order)
  VALUES ('99ee0011-0000-0000-0000-000000000000', '99dd0013-0000-0000-0000-000000000000', -5);

SELECT dataset_version_id, ref_order FROM exp.experiment_data_ver_refs
  WHERE experiment_id = '99ee0011-0000-0000-0000-000000000000'
  ORDER BY ref_order;
-- Expected: 4 rows — ref_orders 1, 2, 3, 4
-- -5 clamped to 1; former 1-3 shifted to 2-4; new row (99dd0013) at 1

ROLLBACK;
