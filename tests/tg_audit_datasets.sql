-- ============================================================================
-- Trigger: tg_audit_datasets
-- Verifies INSERT / UPDATE / DELETE on datasets.datasets each write to audit_log.
--
-- Expected output after each action: 1 audit row with the correct fields.
-- Full trail at the end: 3 rows in order INSERT → UPDATE → DELETE.
-- ============================================================================

BEGIN;

SET LOCAL app.current_user_id = '99aa0003-0000-0000-0000-000000000000';

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0003-0000-0000-0000-000000000000', 'Trigger Tester', 'trigger3@test.io');

INSERT INTO organisations.organizations (org_id, org_name) VALUES
  ('99bb0003-0000-0000-0000-000000000000', 'Test Org');

-- ─── Test: INSERT ─────────────────────────────────────────────────────────────

INSERT INTO datasets.datasets (dataset_id, org_id, dataset_key, created_by) VALUES
  ('99cc0003-0000-0000-0000-000000000000', '99bb0003-0000-0000-0000-000000000000',
   'audit-test-dataset', '99aa0003-0000-0000-0000-000000000000');

SELECT operation,
       old_values IS NULL    AS old_is_null,
       new_values->>'dataset_key' AS new_key,
       changed_by
FROM public.audit_log
WHERE entity_type = 'dataset'
  AND entity_id   = '99cc0003-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: operation=INSERT, old_is_null=true, new_key='audit-test-dataset'

-- ─── Test: UPDATE ─────────────────────────────────────────────────────────────

UPDATE datasets.datasets
  SET dataset_key = 'audit-test-dataset-renamed'
  WHERE dataset_id = '99cc0003-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'dataset_key' AS old_key,
       new_values->>'dataset_key' AS new_key
FROM public.audit_log
WHERE entity_type = 'dataset'
  AND entity_id   = '99cc0003-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=UPDATE, old_key='audit-test-dataset', new_key='audit-test-dataset-renamed'

-- ─── Test: DELETE ─────────────────────────────────────────────────────────────

DELETE FROM datasets.datasets
  WHERE dataset_id = '99cc0003-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'dataset_key' AS deleted_key,
       new_values IS NULL         AS new_is_null
FROM public.audit_log
WHERE entity_type = 'dataset'
  AND entity_id   = '99cc0003-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=DELETE, deleted_key='audit-test-dataset-renamed', new_is_null=true

-- ─── Full trail ───────────────────────────────────────────────────────────────

SELECT operation, changed_by
FROM public.audit_log
WHERE entity_type = 'dataset'
  AND entity_id   = '99cc0003-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: 3 rows — INSERT, UPDATE, DELETE — all with changed_by set

ROLLBACK;
