-- ============================================================================
-- SEED DATA  (development / testing only)
-- All IDs are fixed UUIDs so cross-table references stay readable.
-- ============================================================================

-- ─── Organizations ────────────────────────────────────────────────────────────

INSERT INTO organizations (org_id, org_name, metadata) VALUES
  ('aaaaaaaa-0001-0000-0000-000000000000', 'Acme Research',  '{"plan": "enterprise", "region": "us-east"}'),
  ('aaaaaaaa-0002-0000-0000-000000000000', 'Bright Labs',    '{"plan": "startup",    "region": "eu-west"}');


-- ─── Users ───────────────────────────────────────────────────────────────────

INSERT INTO users (user_id, name, email) VALUES
  ('bbbbbbbb-0001-0000-0000-000000000000', 'Alice Nakamura', 'alice@acme.io'),
  ('bbbbbbbb-0002-0000-0000-000000000000', 'Bob Chen',       'bob@acme.io'),
  ('bbbbbbbb-0003-0000-0000-000000000000', 'Carol Osei',     'carol@brightlabs.io'),
  ('bbbbbbbb-0004-0000-0000-000000000000', 'Dave Singh',     'dave@brightlabs.io');


-- ─── Memberships ─────────────────────────────────────────────────────────────

INSERT INTO user_org_memberships (user_id, org_id) VALUES
  ('bbbbbbbb-0001-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000'), -- Alice  → Acme
  ('bbbbbbbb-0002-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000'), -- Bob    → Acme
  ('bbbbbbbb-0003-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000'), -- Carol  → Bright
  ('bbbbbbbb-0004-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000'); -- Dave   → Bright


-- ─── Roles ───────────────────────────────────────────────────────────────────

INSERT INTO roles (role_id, org_id, role_name) VALUES
  ('cccccccc-0001-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000', 'Acme Admin'),
  ('cccccccc-0002-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000', 'Acme Researcher'),
  ('cccccccc-0003-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000', 'Bright Admin'),
  ('cccccccc-0004-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000', 'Bright Analyst');


-- ─── Role → Policy assignments ────────────────────────────────────────────────

INSERT INTO role_policy_assignments (role_id, policy_id)
SELECT 'cccccccc-0001-0000-0000-000000000000', policy_id FROM access_policies WHERE policy_name IN ('admin', 'dataset_editor', 'experiment_runner');

INSERT INTO role_policy_assignments (role_id, policy_id)
SELECT 'cccccccc-0002-0000-0000-000000000000', policy_id FROM access_policies WHERE policy_name IN ('dataset_editor', 'experiment_runner');

INSERT INTO role_policy_assignments (role_id, policy_id)
SELECT 'cccccccc-0003-0000-0000-000000000000', policy_id FROM access_policies WHERE policy_name IN ('admin', 'dataset_editor', 'experiment_runner', 'analytics_team');

INSERT INTO role_policy_assignments (role_id, policy_id)
SELECT 'cccccccc-0004-0000-0000-000000000000', policy_id FROM access_policies WHERE policy_name IN ('analytics_team');


-- ─── User → Role assignments ──────────────────────────────────────────────────

INSERT INTO user_role_assignments (user_id, role_id, org_id) VALUES
  ('bbbbbbbb-0001-0000-0000-000000000000', 'cccccccc-0001-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000'), -- Alice  → Acme Admin
  ('bbbbbbbb-0002-0000-0000-000000000000', 'cccccccc-0002-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000'), -- Bob    → Acme Researcher
  ('bbbbbbbb-0003-0000-0000-000000000000', 'cccccccc-0003-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000'), -- Carol  → Bright Admin
  ('bbbbbbbb-0004-0000-0000-000000000000', 'cccccccc-0004-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000'); -- Dave   → Bright Analyst


-- ─── Compute Clusters ─────────────────────────────────────────────────────────

INSERT INTO compute_clusters (cluster_id, cluster_name, region, ip_address, cpu_cores, ram_gb, disk_tb, network_bandwidth_mbps, is_active) VALUES
  ('dddddddd-0001-0000-0000-000000000000', 'us-east-gpu-01',  'us-east-1', '10.0.1.10',  64,  512, 20.00, 10000, TRUE),
  ('dddddddd-0002-0000-0000-000000000000', 'us-east-cpu-02',  'us-east-1', '10.0.1.11',  32,  128,  5.00,  1000, TRUE),
  ('dddddddd-0003-0000-0000-000000000000', 'eu-west-gpu-01',  'eu-west-1', '10.1.1.10',  96, 1024, 50.00, 25000, TRUE),
  ('dddddddd-0004-0000-0000-000000000000', 'us-west-retired', 'us-west-2', '10.2.1.10',  16,   64,  2.00,   500, FALSE);


-- ─── Datasets ─────────────────────────────────────────────────────────────────

INSERT INTO datasets (dataset_id, org_id, dataset_key, created_by) VALUES
  ('eeeeeeee-0001-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000', 'customer-churn-signals',  'bbbbbbbb-0001-0000-0000-000000000000'),
  ('eeeeeeee-0002-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000', 'product-clickstream',     'bbbbbbbb-0002-0000-0000-000000000000'),
  ('eeeeeeee-0003-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000', 'sensor-telemetry-raw',    'bbbbbbbb-0003-0000-0000-000000000000'),
  ('eeeeeeee-0004-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000', 'sensor-telemetry-clean',  'bbbbbbbb-0003-0000-0000-000000000000');


-- ─── Dataset Versions ─────────────────────────────────────────────────────────

INSERT INTO dataset_versions (version_id, dataset_id, version_number, description, schema_definition, parent_version_id, created_by) VALUES
  -- customer-churn-signals: v1 (root)
  ('ffffffff-0001-0000-0000-000000000000',
   'eeeeeeee-0001-0000-0000-000000000000', 1,
   'Initial export from CRM',
   '{"fields": [{"name": "customer_id", "type": "uuid"}, {"name": "churn_label", "type": "bool"}, {"name": "tenure_days", "type": "int"}]}',
   NULL,
   'bbbbbbbb-0001-0000-0000-000000000000'),

  -- customer-churn-signals: v2 (child of v1)
  ('ffffffff-0002-0000-0000-000000000000',
   'eeeeeeee-0001-0000-0000-000000000000', 2,
   'Added NPS score feature',
   '{"fields": [{"name": "customer_id", "type": "uuid"}, {"name": "churn_label", "type": "bool"}, {"name": "tenure_days", "type": "int"}, {"name": "nps_score", "type": "float"}]}',
   'ffffffff-0001-0000-0000-000000000000',
   'bbbbbbbb-0002-0000-0000-000000000000'),

  -- product-clickstream: v1 (root)
  ('ffffffff-0003-0000-0000-000000000000',
   'eeeeeeee-0002-0000-0000-000000000000', 1,
   'Raw event stream from web app',
   '{"fields": [{"name": "session_id", "type": "uuid"}, {"name": "event_type", "type": "string"}, {"name": "page", "type": "string"}, {"name": "ts", "type": "timestamp"}]}',
   NULL,
   'bbbbbbbb-0002-0000-0000-000000000000'),

  -- sensor-telemetry-raw: v1 (root)
  ('ffffffff-0004-0000-0000-000000000000',
   'eeeeeeee-0003-0000-0000-000000000000', 1,
   'Direct IoT feed, no cleaning applied',
   '{"fields": [{"name": "device_id", "type": "string"}, {"name": "temp_c", "type": "float"}, {"name": "pressure_pa", "type": "float"}, {"name": "recorded_at", "type": "timestamp"}]}',
   NULL,
   'bbbbbbbb-0003-0000-0000-000000000000'),

  -- sensor-telemetry-clean: v1 (root) — references raw but is a separate dataset
  ('ffffffff-0005-0000-0000-000000000000',
   'eeeeeeee-0004-0000-0000-000000000000', 1,
   'Outliers removed, nulls imputed',
   '{"fields": [{"name": "device_id", "type": "string"}, {"name": "temp_c", "type": "float"}, {"name": "pressure_pa", "type": "float"}, {"name": "recorded_at", "type": "timestamp"}]}',
   NULL,
   'bbbbbbbb-0003-0000-0000-000000000000');


-- ─── Dataset Data Points ──────────────────────────────────────────────────────

INSERT INTO dataset_data_points (version_id, data_payload, created_by) VALUES
  -- churn v1 samples
  ('ffffffff-0001-0000-0000-000000000000', '{"customer_id": "c-001", "churn_label": true,  "tenure_days": 45}',  'bbbbbbbb-0001-0000-0000-000000000000'),
  ('ffffffff-0001-0000-0000-000000000000', '{"customer_id": "c-002", "churn_label": false, "tenure_days": 320}', 'bbbbbbbb-0001-0000-0000-000000000000'),
  ('ffffffff-0001-0000-0000-000000000000', '{"customer_id": "c-003", "churn_label": true,  "tenure_days": 12}',  'bbbbbbbb-0001-0000-0000-000000000000'),

  -- churn v2 samples (includes nps_score)
  ('ffffffff-0002-0000-0000-000000000000', '{"customer_id": "c-001", "churn_label": true,  "tenure_days": 45,  "nps_score": 2.0}', 'bbbbbbbb-0002-0000-0000-000000000000'),
  ('ffffffff-0002-0000-0000-000000000000', '{"customer_id": "c-002", "churn_label": false, "tenure_days": 320, "nps_score": 9.5}', 'bbbbbbbb-0002-0000-0000-000000000000'),
  ('ffffffff-0002-0000-0000-000000000000', '{"customer_id": "c-004", "churn_label": false, "tenure_days": 180, "nps_score": 7.1}', 'bbbbbbbb-0002-0000-0000-000000000000'),

  -- clickstream v1 samples
  ('ffffffff-0003-0000-0000-000000000000', '{"session_id": "s-aaa", "event_type": "page_view", "page": "/pricing",  "ts": "2025-01-10T09:00:00Z"}', 'bbbbbbbb-0002-0000-0000-000000000000'),
  ('ffffffff-0003-0000-0000-000000000000', '{"session_id": "s-aaa", "event_type": "click",     "page": "/pricing",  "ts": "2025-01-10T09:00:42Z"}', 'bbbbbbbb-0002-0000-0000-000000000000'),
  ('ffffffff-0003-0000-0000-000000000000', '{"session_id": "s-bbb", "event_type": "page_view", "page": "/features", "ts": "2025-01-10T10:15:00Z"}', 'bbbbbbbb-0002-0000-0000-000000000000'),

  -- sensor-raw v1 samples
  ('ffffffff-0004-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 22.4, "pressure_pa": 101325, "recorded_at": "2025-03-01T00:00:00Z"}', 'bbbbbbbb-0003-0000-0000-000000000000'),
  ('ffffffff-0004-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 999,  "pressure_pa": 101400, "recorded_at": "2025-03-01T00:05:00Z"}', 'bbbbbbbb-0003-0000-0000-000000000000'), -- outlier
  ('ffffffff-0004-0000-0000-000000000000', '{"device_id": "dev-02", "temp_c": 21.1, "pressure_pa": 101280, "recorded_at": "2025-03-01T00:00:00Z"}', 'bbbbbbbb-0003-0000-0000-000000000000'),

  -- sensor-clean v1 samples
  ('ffffffff-0005-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 22.4, "pressure_pa": 101325, "recorded_at": "2025-03-01T00:00:00Z"}', 'bbbbbbbb-0003-0000-0000-000000000000'),
  ('ffffffff-0005-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 22.6, "pressure_pa": 101400, "recorded_at": "2025-03-01T00:05:00Z"}', 'bbbbbbbb-0003-0000-0000-000000000000'), -- outlier replaced
  ('ffffffff-0005-0000-0000-000000000000', '{"device_id": "dev-02", "temp_c": 21.1, "pressure_pa": 101280, "recorded_at": "2025-03-01T00:00:00Z"}', 'bbbbbbbb-0003-0000-0000-000000000000');


-- ─── Experiments ──────────────────────────────────────────────────────────────

INSERT INTO experiments (experiment_id, org_id, experiment_name, created_by) VALUES
  ('11111111-0001-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000', 'Churn XGBoost Baseline',       'bbbbbbbb-0001-0000-0000-000000000000'),
  ('11111111-0002-0000-0000-000000000000', 'aaaaaaaa-0001-0000-0000-000000000000', 'Churn XGBoost + NPS Feature',  'bbbbbbbb-0002-0000-0000-000000000000'),
  ('11111111-0003-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000', 'Sensor Anomaly Detection v1',  'bbbbbbbb-0003-0000-0000-000000000000'),
  ('11111111-0004-0000-0000-000000000000', 'aaaaaaaa-0002-0000-0000-000000000000', 'Sensor Anomaly Detection v2',  'bbbbbbbb-0003-0000-0000-000000000000');


-- ─── Experiment → Dataset refs ────────────────────────────────────────────────

INSERT INTO experiment_dataset_refs (experiment_id, dataset_version_id, ref_order) VALUES
  ('11111111-0001-0000-0000-000000000000', 'ffffffff-0001-0000-0000-000000000000', 1), -- Baseline uses churn v1
  ('11111111-0002-0000-0000-000000000000', 'ffffffff-0002-0000-0000-000000000000', 1), -- NPS exp uses churn v2
  ('11111111-0002-0000-0000-000000000000', 'ffffffff-0003-0000-0000-000000000000', 2), -- also clickstream v1
  ('11111111-0003-0000-0000-000000000000', 'ffffffff-0004-0000-0000-000000000000', 1), -- Anomaly v1 uses raw
  ('11111111-0004-0000-0000-000000000000', 'ffffffff-0005-0000-0000-000000000000', 1); -- Anomaly v2 uses clean


-- ─── Experiment Parameters ────────────────────────────────────────────────────

INSERT INTO experiment_parameters (experiment_id, param_key, param_type, param_value) VALUES
  ('11111111-0001-0000-0000-000000000000', 'n_estimators',  'int',     '100'),
  ('11111111-0001-0000-0000-000000000000', 'max_depth',     'int',     '6'),
  ('11111111-0001-0000-0000-000000000000', 'learning_rate', 'float',   '0.1'),
  ('11111111-0001-0000-0000-000000000000', 'objective',     'string',  '"binary:logistic"'),

  ('11111111-0002-0000-0000-000000000000', 'n_estimators',  'int',     '200'),
  ('11111111-0002-0000-0000-000000000000', 'max_depth',     'int',     '8'),
  ('11111111-0002-0000-0000-000000000000', 'learning_rate', 'float',   '0.05'),
  ('11111111-0002-0000-0000-000000000000', 'objective',     'string',  '"binary:logistic"'),
  ('11111111-0002-0000-0000-000000000000', 'use_nps',       'boolean', 'true'),

  ('11111111-0003-0000-0000-000000000000', 'algorithm',     'string',  '"isolation_forest"'),
  ('11111111-0003-0000-0000-000000000000', 'contamination', 'float',   '0.05'),
  ('11111111-0003-0000-0000-000000000000', 'n_estimators',  'int',     '100'),

  ('11111111-0004-0000-0000-000000000000', 'algorithm',     'string',  '"autoencoder"'),
  ('11111111-0004-0000-0000-000000000000', 'epochs',        'int',     '50'),
  ('11111111-0004-0000-0000-000000000000', 'latent_dim',    'int',     '8'),
  ('11111111-0004-0000-0000-000000000000', 'threshold',     'float',   '0.02');


-- ─── Runs ─────────────────────────────────────────────────────────────────────

INSERT INTO runs (run_id, experiment_id, cluster_id, status, created_at, started_at, ended_at, created_by) VALUES
  -- Baseline: one succeeded run
  ('22222222-0001-0000-0000-000000000000',
   '11111111-0001-0000-0000-000000000000', 'dddddddd-0001-0000-0000-000000000000',
   'succeeded',
   '2025-04-01 08:00:00', '2025-04-01 08:01:00', '2025-04-01 08:47:00',
   'bbbbbbbb-0001-0000-0000-000000000000'),

  -- NPS experiment: failed first, then succeeded
  ('22222222-0002-0000-0000-000000000000',
   '11111111-0002-0000-0000-000000000000', 'dddddddd-0001-0000-0000-000000000000',
   'failed',
   '2025-04-02 09:00:00', '2025-04-02 09:01:00', '2025-04-02 09:05:00',
   'bbbbbbbb-0002-0000-0000-000000000000'),

  ('22222222-0003-0000-0000-000000000000',
   '11111111-0002-0000-0000-000000000000', 'dddddddd-0001-0000-0000-000000000000',
   'succeeded',
   '2025-04-02 10:00:00', '2025-04-02 10:01:00', '2025-04-02 11:23:00',
   'bbbbbbbb-0002-0000-0000-000000000000'),

  -- Anomaly v1: succeeded on EU cluster
  ('22222222-0004-0000-0000-000000000000',
   '11111111-0003-0000-0000-000000000000', 'dddddddd-0003-0000-0000-000000000000',
   'succeeded',
   '2025-04-05 14:00:00', '2025-04-05 14:00:30', '2025-04-05 14:22:00',
   'bbbbbbbb-0003-0000-0000-000000000000'),

  -- Anomaly v2: currently running
  ('22222222-0005-0000-0000-000000000000',
   '11111111-0004-0000-0000-000000000000', 'dddddddd-0003-0000-0000-000000000000',
   'running',
   '2025-04-10 09:00:00', '2025-04-10 09:00:45', NULL,
   'bbbbbbbb-0003-0000-0000-000000000000'),

  -- Queued but not yet started
  ('22222222-0006-0000-0000-000000000000',
   '11111111-0004-0000-0000-000000000000', 'dddddddd-0002-0000-0000-000000000000',
   'queued',
   '2025-04-10 09:30:00', NULL, NULL,
   'bbbbbbbb-0004-0000-0000-000000000000');


-- ─── Run Logs ─────────────────────────────────────────────────────────────────

INSERT INTO run_logs (run_id, log_level, log_message, created_at) VALUES
  -- Baseline run logs
  ('22222222-0001-0000-0000-000000000000', 'INFO',  'Loading dataset: customer-churn-signals v1 (3 rows)',          '2025-04-01 08:01:05'),
  ('22222222-0001-0000-0000-000000000000', 'INFO',  'Training XGBoost with n_estimators=100, max_depth=6',          '2025-04-01 08:02:00'),
  ('22222222-0001-0000-0000-000000000000', 'INFO',  'Training complete. AUC-ROC: 0.82',                             '2025-04-01 08:47:00'),

  -- NPS failed run logs
  ('22222222-0002-0000-0000-000000000000', 'INFO',  'Loading datasets: churn v2, clickstream v1',                   '2025-04-02 09:01:10'),
  ('22222222-0002-0000-0000-000000000000', 'ERROR', 'Feature join failed: clickstream session_id has nulls',        '2025-04-02 09:05:00'),

  -- NPS succeeded run logs
  ('22222222-0003-0000-0000-000000000000', 'INFO',  'Loading datasets: churn v2, clickstream v1',                   '2025-04-02 10:01:05'),
  ('22222222-0003-0000-0000-000000000000', 'WARN',  '12 rows dropped due to null session_id in clickstream join',   '2025-04-02 10:03:00'),
  ('22222222-0003-0000-0000-000000000000', 'INFO',  'Training XGBoost with n_estimators=200, max_depth=8',          '2025-04-02 10:05:00'),
  ('22222222-0003-0000-0000-000000000000', 'INFO',  'Training complete. AUC-ROC: 0.89 (+0.07 vs baseline)',         '2025-04-02 11:23:00'),

  -- Anomaly v1 logs
  ('22222222-0004-0000-0000-000000000000', 'INFO',  'Loading dataset: sensor-telemetry-raw v1',                     '2025-04-05 14:00:35'),
  ('22222222-0004-0000-0000-000000000000', 'WARN',  'Detected 1 outlier in temp_c column (value=999)',              '2025-04-05 14:01:00'),
  ('22222222-0004-0000-0000-000000000000', 'INFO',  'Isolation Forest fit complete. Anomaly rate: 4.8%',            '2025-04-05 14:22:00'),

  -- Anomaly v2 logs (in progress)
  ('22222222-0005-0000-0000-000000000000', 'INFO',  'Loading dataset: sensor-telemetry-clean v1',                   '2025-04-10 09:00:50'),
  ('22222222-0005-0000-0000-000000000000', 'DEBUG', 'Autoencoder architecture: input=2, latent=8, output=2',        '2025-04-10 09:01:00'),
  ('22222222-0005-0000-0000-000000000000', 'INFO',  'Epoch 10/50 — val_loss: 0.041',                                '2025-04-10 09:05:00');


-- ─── Run Output Artifacts ─────────────────────────────────────────────────────

INSERT INTO run_output_artifacts (run_id, artifact_type, artifact_payload) VALUES
  ('22222222-0001-0000-0000-000000000000', 'model_metrics', '{
    "auc_roc": 0.82,
    "precision": 0.74,
    "recall": 0.68,
    "f1": 0.71,
    "model_path": "s3://acme-models/churn-xgb-baseline/model.ubj"
  }'),
  ('22222222-0003-0000-0000-000000000000', 'model_metrics', '{
    "auc_roc": 0.89,
    "precision": 0.81,
    "recall": 0.76,
    "f1": 0.78,
    "model_path": "s3://acme-models/churn-xgb-nps/model.ubj",
    "feature_importance": {"nps_score": 0.23, "tenure_days": 0.41, "churn_label": 0.36}
  }'),
  ('22222222-0004-0000-0000-000000000000', 'model_metrics', '{
    "anomaly_rate": 0.048,
    "threshold_used": "auto",
    "flagged_devices": ["dev-01"],
    "model_path": "s3://bright-models/sensor-iforest-v1/model.pkl"
  }');
