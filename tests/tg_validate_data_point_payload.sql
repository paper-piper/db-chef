-- ============================================================================
-- Trigger: tg_validate_data_point_payload
-- Tests that INSERT into ds.dataset_data_points is validated against
-- the version's schema_definition.
--
-- Expected output:
--   NOTICE: PASS — valid payload accepted
--   NOTICE: PASS — missing field blocked: ...
--   NOTICE: PASS — wrong type blocked: ...
--   NOTICE: PASS — undeclared field blocked: ...
-- ============================================================================

BEGIN;

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('a1aa0001-0000-0000-0000-000000000000', 'Payload Tester', 'payload@test.io');

INSERT INTO orgs.organizations (org_id, org_name) VALUES
  ('a1bb0001-0000-0000-0000-000000000000', 'Test Org');

INSERT INTO ds.datasets (dataset_id, org_id, dataset_key, created_by) VALUES
  ('a1cc0001-0000-0000-0000-000000000000', 'a1bb0001-0000-0000-0000-000000000000',
   'payload-validation-test-ds', 'a1aa0001-0000-0000-0000-000000000000');

INSERT INTO ds.dataset_versions (version_id, dataset_id, version_number, schema_definition, created_by) VALUES
  ('a1dd0001-0000-0000-0000-000000000000', 'a1cc0001-0000-0000-0000-000000000000',
   1, '{"name": "string", "score": "number", "active": "boolean"}',
   'a1aa0001-0000-0000-0000-000000000000');

-- ─── Test 1: valid payload must be accepted ───────────────────────────────────

DO $$
BEGIN
  INSERT INTO ds.dataset_data_points (version_id, data_payload, created_by) VALUES
    ('a1dd0001-0000-0000-0000-000000000000',
     '{"name": "alice", "score": 9.5, "active": true}',
     'a1aa0001-0000-0000-0000-000000000000');

  RAISE NOTICE 'PASS — valid payload accepted';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'FAIL — valid payload rejected: %', SQLERRM;
END;
$$;

-- ─── Test 2: missing required field must be blocked ───────────────────────────

DO $$
BEGIN
  INSERT INTO ds.dataset_data_points (version_id, data_payload, created_by) VALUES
    ('a1dd0001-0000-0000-0000-000000000000',
     '{"name": "bob", "score": 7.0}',
     'a1aa0001-0000-0000-0000-000000000000');

  RAISE NOTICE 'FAIL — missing field was not blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS — missing field blocked: %', SQLERRM;
END;
$$;

-- ─── Test 3: wrong field type must be blocked ─────────────────────────────────

DO $$
BEGIN
  INSERT INTO ds.dataset_data_points (version_id, data_payload, created_by) VALUES
    ('a1dd0001-0000-0000-0000-000000000000',
     '{"name": "carol", "score": "not-a-number", "active": true}',
     'a1aa0001-0000-0000-0000-000000000000');

  RAISE NOTICE 'FAIL — wrong type was not blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS — wrong type blocked: %', SQLERRM;
END;
$$;

-- ─── Test 4: undeclared field must be blocked ─────────────────────────────────

DO $$
BEGIN
  INSERT INTO ds.dataset_data_points (version_id, data_payload, created_by) VALUES
    ('a1dd0001-0000-0000-0000-000000000000',
     '{"name": "dave", "score": 5.0, "active": false, "extra": "nope"}',
     'a1aa0001-0000-0000-0000-000000000000');

  RAISE NOTICE 'FAIL — undeclared field was not blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS — undeclared field blocked: %', SQLERRM;
END;
$$;

ROLLBACK;
