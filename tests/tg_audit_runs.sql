-- ============================================================================
-- Trigger: tg_audit_runs
-- Verifies INSERT / UPDATE / DELETE on run.runs each write to audit_log.
-- Note: no run_logs or artifacts are attached, so the run DELETE is not blocked.
--
-- Expected output after each action: 1 audit row with the correct fields.
-- Full trail at the end: 3 rows in order INSERT → UPDATE → DELETE.
-- ============================================================================

BEGIN;

SET LOCAL app.current_user_id = '99aa0006-0000-0000-0000-000000000000';

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0006-0000-0000-0000-000000000000', 'Trigger Tester', 'trigger6@test.io');

INSERT INTO orgs.organizations (org_id, org_name) VALUES
  ('99bb0006-0000-0000-0000-000000000000', 'Test Org');

INSERT INTO exp.experiments (experiment_id, org_id, experiment_name, created_by) VALUES
  ('99cc0006-0000-0000-0000-000000000000', '99bb0006-0000-0000-0000-000000000000',
   'Run Audit Test Exp', '99aa0006-0000-0000-0000-000000000000');

INSERT INTO run.compute_clusters
  (cluster_id, cluster_name, region, ip_address, cpu_cores, ram_gb, disk_tb, network_bandwidth_mbps) VALUES
  ('99dd0006-0000-0000-0000-000000000000', 'test-cluster-6', 'us-east-1',
   '10.99.0.6', 8, 32, 1.00, 1000);

-- ─── Test: INSERT ─────────────────────────────────────────────────────────────

INSERT INTO run.runs (run_id, experiment_id, cluster_id, status, created_by) VALUES
  ('99ee0006-0000-0000-0000-000000000000', '99cc0006-0000-0000-0000-000000000000',
   '99dd0006-0000-0000-0000-000000000000', 'queued', '99aa0006-0000-0000-0000-000000000000');

SELECT operation,
       old_values IS NULL    AS old_is_null,
       new_values->>'status' AS new_status,
       changed_by
FROM public.audit_log
WHERE entity_type = 'run'
  AND entity_id   = '99ee0006-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: operation=INSERT, old_is_null=true, new_status='queued'

-- ─── Test: UPDATE (status transition) ────────────────────────────────────────

UPDATE run.runs
  SET status     = 'running',
      started_at = NOW()
  WHERE run_id = '99ee0006-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'status' AS old_status,
       new_values->>'status' AS new_status
FROM public.audit_log
WHERE entity_type = 'run'
  AND entity_id   = '99ee0006-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=UPDATE, old_status='queued', new_status='running'

-- ─── Test: DELETE ─────────────────────────────────────────────────────────────

DELETE FROM run.runs
  WHERE run_id = '99ee0006-0000-0000-0000-000000000000';

SELECT operation,
       old_values->>'status' AS deleted_status,
       new_values IS NULL    AS new_is_null
FROM public.audit_log
WHERE entity_type = 'run'
  AND entity_id   = '99ee0006-0000-0000-0000-000000000000'
ORDER BY audit_id DESC LIMIT 1;
-- Expected: operation=DELETE, deleted_status='running', new_is_null=true

-- ─── Full trail ───────────────────────────────────────────────────────────────

SELECT operation, changed_by
FROM public.audit_log
WHERE entity_type = 'run'
  AND entity_id   = '99ee0006-0000-0000-0000-000000000000'
ORDER BY audit_id;
-- Expected: 3 rows — INSERT, UPDATE, DELETE

ROLLBACK;
