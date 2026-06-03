-- ============================================================================
-- Trigger: tg_audit_permissions
-- Verifies INSERT / DELETE on orgs.user_role_assignments write to audit_log.
-- entity_id is user_id (not a surrogate PK) — this is intentional per the
-- trigger definition, as user_id is the most useful audit query axis.
--
-- Expected output after each action: 1 audit row with the correct fields.
-- Full trail at the end: 2 rows — INSERT then DELETE.
-- ============================================================================

BEGIN;

SET LOCAL app.current_user_id = '99aa0007-0000-0000-0000-000000000000';

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0007-0000-0000-0000-000000000000', 'Admin Tester',  'admin7@test.io'),
  ('99aa0008-0000-0000-0000-000000000000', 'Target User',   'user7@test.io');

INSERT INTO orgs.organizations (org_id, org_name) VALUES
  ('99bb0007-0000-0000-0000-000000000000', 'Test Org');

INSERT INTO orgs.roles (role_id, org_id, role_name) VALUES
  ('99cc0007-0000-0000-0000-000000000000', '99bb0007-0000-0000-0000-000000000000', 'Analyst');

-- ─── Test: INSERT (grant role) ───────────────────────────────────────────────

INSERT INTO orgs.user_role_assignments (user_id, role_id, org_id) VALUES
  ('99aa0008-0000-0000-0000-000000000000',
   '99cc0007-0000-0000-0000-000000000000',
   '99bb0007-0000-0000-0000-000000000000');

SELECT operation,
       old_values IS NULL         AS old_is_null,
       new_values->>'role_id'     AS granted_role,
       new_values->>'org_id'      AS org,
       changed_by
FROM public.audit_log
WHERE entity_type = 'permission'
  AND entity_id   = '99aa0008-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: operation=INSERT, old_is_null=true, granted_role and org populated,
--           changed_by = 99aa0007...

-- ─── Test: DELETE (revoke role) ──────────────────────────────────────────────

DELETE FROM orgs.user_role_assignments
  WHERE user_id = '99aa0008-0000-0000-0000-000000000000'
    AND role_id = '99cc0007-0000-0000-0000-000000000000'
    AND org_id  = '99bb0007-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'role_id' AS revoked_role,
       new_values IS NULL     AS new_is_null,
       changed_by
FROM public.audit_log
WHERE entity_type = 'permission'
  AND entity_id   = '99aa0008-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=DELETE, revoked_role populated, new_is_null=true

-- ─── Full trail for this user ────────────────────────────────────────────────

SELECT operation, changed_by
FROM public.audit_log
WHERE entity_type = 'permission'
  AND entity_id   = '99aa0008-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: 2 rows — INSERT then DELETE

ROLLBACK;
