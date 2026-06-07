-- ============================================================================
-- Trigger: tg_dataset_data_points_append_only
-- Tests that UPDATE and DELETE on ds.dataset_data_points are blocked.
--
-- Expected output:
--   NOTICE: PASS — UPDATE correctly blocked: ...
--   NOTICE: PASS — DELETE correctly blocked: ...
--   (final SELECT should return 1 row, unchanged)
-- ============================================================================

BEGIN;

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0001-0000-0000-0000-000000000000', 'Trigger Tester', 'trigger@test.io');

INSERT INTO orgs.organizations (org_id, org_name) VALUES
  ('99bb0001-0000-0000-0000-000000000000', 'Test Org');

INSERT INTO ds.datasets (dataset_id, org_id, dataset_key, created_by) VALUES
  ('99cc0001-0000-0000-0000-000000000000', '99bb0001-0000-0000-0000-000000000000',
   'append-only-test-ds', '99aa0001-0000-0000-0000-000000000000');

INSERT INTO ds.dataset_versions (version_id, dataset_id, version_number, schema_definition, created_by) VALUES
  ('99dd0001-0000-0000-0000-000000000000', '99cc0001-0000-0000-0000-000000000000',
   1, '{"x": "number"}', '99aa0001-0000-0000-0000-000000000000');

INSERT INTO ds.dataset_data_points (data_point_id, version_id, data_payload, created_by) VALUES
  ('99ee0001-0000-0000-0000-000000000000', '99dd0001-0000-0000-0000-000000000000',
   '{"x": 42}', '99aa0001-0000-0000-0000-000000000000');

-- ─── Test 1: UPDATE must be blocked ──────────────────────────────────────────

DO $$
BEGIN
  UPDATE ds.dataset_data_points
    SET data_payload = '{"x": 999}'
    WHERE data_point_id = '99ee0001-0000-0000-0000-000000000000';

  RAISE NOTICE 'FAIL — UPDATE was not blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS — UPDATE correctly blocked: %', SQLERRM;
END;
$$;

-- ─── Test 2: DELETE must be blocked ──────────────────────────────────────────

DO $$
BEGIN
  DELETE FROM ds.dataset_data_points
    WHERE data_point_id = '99ee0001-0000-0000-0000-000000000000';

  RAISE NOTICE 'FAIL — DELETE was not blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS — DELETE correctly blocked: %', SQLERRM;
END;
$$;

-- ─── Row must still exist and be unchanged ───────────────────────────────────

SELECT data_point_id, data_payload
FROM ds.dataset_data_points
WHERE data_point_id = '99ee0001-0000-0000-0000-000000000000';
-- Expected: 1 row, data_payload = {"x": 42}

ROLLBACK;
