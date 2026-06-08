-- ============================================================================
-- Trigger: tg_run_logs_append_only
-- Tests that UPDATE and DELETE on run.run_logs are blocked.
--
-- Expected output:
--   NOTICE: PASS — UPDATE correctly blocked: ...
--   NOTICE: PASS — DELETE correctly blocked: ...
--   (final SELECT should return 1 row, unchanged)
-- ============================================================================

BEGIN;

-- ─── Setup ────────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('99aa0002-0000-0000-0000-000000000000', 'Trigger Tester', 'trigger2@test.io');

INSERT INTO organisations.organizations (org_id, org_name) VALUES
  ('99bb0002-0000-0000-0000-000000000000', 'Test Org');

INSERT INTO experiments.experiments (experiment_id, org_id, experiment_name, created_by) VALUES
  ('99cc0002-0000-0000-0000-000000000000', '99bb0002-0000-0000-0000-000000000000',
   'Test Experiment', '99aa0002-0000-0000-0000-000000000000');

INSERT INTO run.compute_clusters
  (cluster_id, cluster_name, region, ip_address, cpu_cores, ram_gb, disk_tb, network_bandwidth_mbps) VALUES
  ('99dd0002-0000-0000-0000-000000000000', 'test-cluster', 'us-east-1',
   '10.99.0.1', 8, 32, 1.00, 1000);

INSERT INTO run.runs (run_id, experiment_id, cluster_id, status, created_by) VALUES
  ('99ee0002-0000-0000-0000-000000000000', '99cc0002-0000-0000-0000-000000000000',
   '99dd0002-0000-0000-0000-000000000000', 'succeeded', '99aa0002-0000-0000-0000-000000000000');

INSERT INTO run.run_logs (log_id, run_id, log_level, log_message) VALUES
  ('99ff0002-0000-0000-0000-000000000000', '99ee0002-0000-0000-0000-000000000000',
   'INFO', 'Training complete.');

-- ─── Test 1: UPDATE must be blocked ──────────────────────────────────────────

DO $$
BEGIN
  UPDATE run.run_logs
    SET log_message = 'Tampered message'
    WHERE log_id = '99ff0002-0000-0000-0000-000000000000';

  RAISE NOTICE 'FAIL — UPDATE was not blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS — UPDATE correctly blocked: %', SQLERRM;
END;
$$;

-- ─── Test 2: DELETE must be blocked ──────────────────────────────────────────

DO $$
BEGIN
  DELETE FROM run.run_logs
    WHERE log_id = '99ff0002-0000-0000-0000-000000000000';

  RAISE NOTICE 'FAIL — DELETE was not blocked';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'PASS — DELETE correctly blocked: %', SQLERRM;
END;
$$;

-- ─── Row must still exist and be unchanged ───────────────────────────────────

SELECT log_id, log_level, log_message
FROM run.run_logs
WHERE log_id = '99ff0002-0000-0000-0000-000000000000';
-- Expected: 1 row, log_message = 'Training complete.'

ROLLBACK;
