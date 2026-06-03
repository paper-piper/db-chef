-- ============================================================================
-- Trigger: tg_audit_experiments
-- Verifies INSERT / UPDATE / DELETE on exp.experiments each write to audit_log.
-- Note: no runs are attached, so the experiment DELETE is not blocked by RESTRICT.
--
-- Expected output after each action: 1 audit row with the correct fields.
-- Full trail at the end: 3 rows in order INSERT → UPDATE → DELETE.
-- ============================================================================

BEGIN;

SET LOCAL app.current_user_id = '99aa0005-0000-0000-0000-000000000000';

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0005-0000-0000-0000-000000000000', 'Trigger Tester', 'trigger5@test.io');

INSERT INTO orgs.organizations (org_id, org_name) VALUES
  ('99bb0005-0000-0000-0000-000000000000', 'Test Org');

-- ─── Test: INSERT ─────────────────────────────────────────────────────────────

INSERT INTO exp.experiments (experiment_id, org_id, experiment_name, created_by) VALUES
  ('99cc0005-0000-0000-0000-000000000000', '99bb0005-0000-0000-0000-000000000000',
   'Audit Test Experiment', '99aa0005-0000-0000-0000-000000000000');

SELECT operation,
       old_values IS NULL              AS old_is_null,
       new_values->>'experiment_name'  AS new_name,
       changed_by
FROM public.audit_log
WHERE entity_type = 'experiment'
  AND entity_id   = '99cc0005-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: operation=INSERT, old_is_null=true, new_name='Audit Test Experiment'

-- ─── Test: UPDATE ─────────────────────────────────────────────────────────────

UPDATE exp.experiments
  SET experiment_name = 'Audit Test Experiment (v2)'
  WHERE experiment_id = '99cc0005-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'experiment_name' AS old_name,
       new_values->>'experiment_name' AS new_name
FROM public.audit_log
WHERE entity_type = 'experiment'
  AND entity_id   = '99cc0005-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=UPDATE, old_name='Audit Test Experiment', new_name='Audit Test Experiment (v2)'

-- ─── Test: DELETE ─────────────────────────────────────────────────────────────

DELETE FROM exp.experiments
  WHERE experiment_id = '99cc0005-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'experiment_name' AS deleted_name,
       new_values IS NULL             AS new_is_null
FROM public.audit_log
WHERE entity_type = 'experiment'
  AND entity_id   = '99cc0005-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=DELETE, deleted_name='Audit Test Experiment (v2)', new_is_null=true

-- ─── Full trail ───────────────────────────────────────────────────────────────

SELECT operation, changed_by
FROM public.audit_log
WHERE entity_type = 'experiment'
  AND entity_id   = '99cc0005-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: 3 rows — INSERT, UPDATE, DELETE

ROLLBACK;
