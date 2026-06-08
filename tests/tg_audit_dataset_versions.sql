-- ============================================================================
-- Trigger: tg_audit_dataset_versions
-- Verifies INSERT / UPDATE / DELETE on datasets.dataset_versions each write to audit_log.
-- Note: no data_points are attached, so the version DELETE is not blocked.
--
-- Expected output after each action: 1 audit row with the correct fields.
-- Full trail at the end: 3 rows in order INSERT → UPDATE → DELETE.
-- ============================================================================

BEGIN;

SET LOCAL app.current_user_id = '99aa0004-0000-0000-0000-000000000000';

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0004-0000-0000-0000-000000000000', 'Trigger Tester', 'trigger4@test.io');

INSERT INTO organisations.organizations (org_id, org_name) VALUES
  ('99bb0004-0000-0000-0000-000000000000', 'Test Org');

INSERT INTO datasets.datasets (dataset_id, org_id, dataset_key, created_by) VALUES
  ('99cc0004-0000-0000-0000-000000000000', '99bb0004-0000-0000-0000-000000000000',
   'version-audit-ds', '99aa0004-0000-0000-0000-000000000000');

-- ─── Test: INSERT ─────────────────────────────────────────────────────────────

INSERT INTO datasets.dataset_versions
  (version_id, dataset_id, version_number, description, schema_definition, created_by) VALUES
  ('99dd0004-0000-0000-0000-000000000000', '99cc0004-0000-0000-0000-000000000000',
   1, 'Initial version', '{"fields": [{"name": "x", "type": "int"}]}',
   '99aa0004-0000-0000-0000-000000000000');

SELECT operation,
       old_values IS NULL          AS old_is_null,
       new_values->>'description'  AS new_desc,
       changed_by
FROM public.audit_log
WHERE entity_type = 'dataset_version'
  AND entity_id   = '99dd0004-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: operation=INSERT, old_is_null=true, new_desc='Initial version'

-- ─── Test: UPDATE ─────────────────────────────────────────────────────────────

UPDATE datasets.dataset_versions
  SET description = 'Revised version'
  WHERE version_id = '99dd0004-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'description' AS old_desc,
       new_values->>'description' AS new_desc
FROM public.audit_log
WHERE entity_type = 'dataset_version'
  AND entity_id   = '99dd0004-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=UPDATE, old_desc='Initial version', new_desc='Revised version'

-- ─── Test: DELETE ─────────────────────────────────────────────────────────────

DELETE FROM datasets.dataset_versions
  WHERE version_id = '99dd0004-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'description' AS deleted_desc,
       new_values IS NULL         AS new_is_null
FROM public.audit_log
WHERE entity_type = 'dataset_version'
  AND entity_id   = '99dd0004-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=DELETE, deleted_desc='Revised version', new_is_null=true

-- ─── Full trail ───────────────────────────────────────────────────────────────

SELECT operation, changed_by
FROM public.audit_log
WHERE entity_type = 'dataset_version'
  AND entity_id   = '99dd0004-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: 3 rows — INSERT, UPDATE, DELETE

ROLLBACK;
