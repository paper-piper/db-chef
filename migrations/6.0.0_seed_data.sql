-- ============================================================================
-- SEED DATA  (development / testing only)
-- All IDs are fixed UUIDs so cross-table references stay readable.
--
-- Interesting cases deliberately included:
--   • Users belonging to multiple orgs     (Bob, Carol, Eve)
--   • Users holding multiple roles         (Alice, Dave)
--   • Multi-dataset experiments            (exp 2, exp 3, exp 7)
--   • Deep version lineage (3 levels)      (customer-churn-signals v1→v2→v3)
--   • Mix of run statuses per experiment
-- ============================================================================


-- ─── Organizations ────────────────────────────────────────────────────────────

INSERT INTO orgs.organizations (org_id, org_name) VALUES
  ('aa000001-0000-0000-0000-000000000000', 'Acme Research'),
  ('aa000002-0000-0000-0000-000000000000', 'Bright Labs'),
  ('aa000003-0000-0000-0000-000000000000', 'Quantum Analytics');


-- ─── Users ───────────────────────────────────────────────────────────────────

INSERT INTO public.users (user_id, name, email) VALUES
  ('bb000001-0000-0000-0000-000000000000', 'Alice Nakamura', 'alice@acme.io'),        -- Acme: Admin + Researcher (multi-role)
  ('bb000002-0000-0000-0000-000000000000', 'Bob Chen',       'bob@acme.io'),          -- Acme + Quantum (multi-org)
  ('bb000003-0000-0000-0000-000000000000', 'Carol Osei',     'carol@brightlabs.io'),  -- Bright + Quantum (multi-org)
  ('bb000004-0000-0000-0000-000000000000', 'Dave Singh',     'dave@brightlabs.io'),   -- Bright: Admin + Analyst (multi-role)
  ('bb000005-0000-0000-0000-000000000000', 'Eve Martinez',   'eve@consultant.io'),    -- Acme + Bright (consultant, multi-org)
  ('bb000006-0000-0000-0000-000000000000', 'Frank Liu',      'frank@quantum.io'),     -- Quantum only
  ('bb000007-0000-0000-0000-000000000000', 'Grace Kim',      'grace@brightlabs.io'); -- Bright only


-- ─── Memberships  (multi-org users: Bob, Carol, Eve) ─────────────────────────

INSERT INTO orgs.user_org_memberships (user_id, org_id) VALUES
  ('bb000001-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000'), -- Alice  → Acme
  ('bb000002-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000'), -- Bob    → Acme
  ('bb000002-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000'), -- Bob    → Quantum
  ('bb000003-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'), -- Carol  → Bright
  ('bb000003-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000'), -- Carol  → Quantum
  ('bb000004-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'), -- Dave   → Bright
  ('bb000005-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000'), -- Eve    → Acme
  ('bb000005-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'), -- Eve    → Bright
  ('bb000006-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000'), -- Frank  → Quantum
  ('bb000007-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'); -- Grace  → Bright


-- ─── Roles ───────────────────────────────────────────────────────────────────

INSERT INTO orgs.roles (role_id, org_id, role_name) VALUES
  -- Acme
  ('cc000001-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'Acme Admin'),
  ('cc000002-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'Acme Researcher'),
  ('cc000003-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'Acme Data Steward'),
  -- Bright
  ('cc000004-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'Bright Admin'),
  ('cc000005-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'Bright Analyst'),
  ('cc000006-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'Bright Data Steward'),
  -- Quantum
  ('cc000007-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000', 'Quantum Admin'),
  ('cc000008-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000', 'Quantum ML Engineer'),
  ('cc000009-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000', 'Quantum Auditor');


-- ─── User → Role assignments  (multi-role users: Alice, Dave) ─────────────────

INSERT INTO orgs.user_role_assignments (user_id, role_id, org_id) VALUES
  -- Alice: Admin AND Researcher at Acme (two roles, same org)
  ('bb000001-0000-0000-0000-000000000000', 'cc000001-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000'),
  ('bb000001-0000-0000-0000-000000000000', 'cc000002-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000'),
  -- Bob: Researcher at Acme, ML Engineer at Quantum (two roles, two orgs)
  ('bb000002-0000-0000-0000-000000000000', 'cc000002-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000'),
  ('bb000002-0000-0000-0000-000000000000', 'cc000008-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000'),
  -- Carol: Data Steward at Bright, Admin at Quantum (elevated in new org)
  ('bb000003-0000-0000-0000-000000000000', 'cc000006-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'),
  ('bb000003-0000-0000-0000-000000000000', 'cc000007-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000'),
  -- Dave: Admin AND Analyst at Bright (two roles, same org)
  ('bb000004-0000-0000-0000-000000000000', 'cc000004-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'),
  ('bb000004-0000-0000-0000-000000000000', 'cc000005-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'),
  -- Eve: Data Steward at Acme, Analyst at Bright (consultant, read-ish everywhere)
  ('bb000005-0000-0000-0000-000000000000', 'cc000003-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000'),
  ('bb000005-0000-0000-0000-000000000000', 'cc000005-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000'),
  -- Frank: ML Engineer at Quantum only
  ('bb000006-0000-0000-0000-000000000000', 'cc000008-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000'),
  -- Grace: Admin at Bright only
  ('bb000007-0000-0000-0000-000000000000', 'cc000004-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000');


-- ─── Compute Clusters ─────────────────────────────────────────────────────────

INSERT INTO run.compute_clusters (cluster_id, cluster_name, region, ip_address, cpu_cores, ram_gb, disk_tb, network_bandwidth_mbps, is_active) VALUES
  ('dd000001-0000-0000-0000-000000000000', 'us-east-gpu-01',  'us-east-1', '10.0.1.10',  64,   512, 20.00, 10000, TRUE),
  ('dd000002-0000-0000-0000-000000000000', 'us-east-cpu-02',  'us-east-1', '10.0.1.11',  32,   128,  5.00,  1000, TRUE),
  ('dd000003-0000-0000-0000-000000000000', 'eu-west-gpu-01',  'eu-west-1', '10.1.1.10',  96,  1024, 50.00, 25000, TRUE),
  ('dd000004-0000-0000-0000-000000000000', 'us-west-gpu-01',  'us-west-2', '10.2.1.10', 128,  2048, 80.00, 40000, TRUE),
  ('dd000005-0000-0000-0000-000000000000', 'us-east-retired', 'us-east-1', '10.0.1.99',  16,    64,  2.00,   500, FALSE);


-- ─── Datasets ─────────────────────────────────────────────────────────────────

INSERT INTO ds.datasets (dataset_id, org_id, dataset_key, created_by) VALUES
  -- Acme
  ('ee000001-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'customer-churn-signals',          'bb000001-0000-0000-0000-000000000000'),
  ('ee000002-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'product-clickstream',             'bb000002-0000-0000-0000-000000000000'),
  ('ee000003-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'marketing-attribution',           'bb000005-0000-0000-0000-000000000000'),
  -- Bright
  ('ee000004-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'sensor-telemetry-raw',            'bb000003-0000-0000-0000-000000000000'),
  ('ee000005-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'sensor-telemetry-clean',          'bb000003-0000-0000-0000-000000000000'),
  ('ee000006-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'weather-forecast-features',       'bb000004-0000-0000-0000-000000000000'),
  -- Quantum
  ('ee000007-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000', 'financial-transactions-raw',      'bb000006-0000-0000-0000-000000000000'),
  ('ee000008-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000', 'financial-transactions-enriched', 'bb000003-0000-0000-0000-000000000000'); -- Carol (multi-org contributor)


-- ─── Dataset Versions ─────────────────────────────────────────────────────────
-- customer-churn-signals: 3-level deep lineage (v1 → v2 → v3)

INSERT INTO ds.dataset_versions (version_id, dataset_id, version_number, description, schema_definition, parent_version_id, created_by) VALUES

  -- customer-churn-signals v1 (root)
  ('ff000001-0000-0000-0000-000000000000', 'ee000001-0000-0000-0000-000000000000', 1,
   'Initial CRM export',
   '{"customer_id": "string", "churn_label": "boolean", "tenure_days": "number"}',
   NULL, 'bb000001-0000-0000-0000-000000000000'),

  -- customer-churn-signals v2 (child of v1)
  ('ff000002-0000-0000-0000-000000000000', 'ee000001-0000-0000-0000-000000000000', 2,
   'Added NPS score feature',
   '{"customer_id": "string", "churn_label": "boolean", "tenure_days": "number", "nps_score": "number"}',
   'ff000001-0000-0000-0000-000000000000', 'bb000002-0000-0000-0000-000000000000'),

  -- customer-churn-signals v3 (child of v2 — 3 levels deep)
  ('ff000003-0000-0000-0000-000000000000', 'ee000001-0000-0000-0000-000000000000', 3,
   'Added support tier and contract value; dropped raw tenure',
   '{"customer_id": "string", "churn_label": "boolean", "nps_score": "number", "support_tier": "string", "contract_value_usd": "number"}',
   'ff000002-0000-0000-0000-000000000000', 'bb000001-0000-0000-0000-000000000000'),

  -- product-clickstream v1
  ('ff000004-0000-0000-0000-000000000000', 'ee000002-0000-0000-0000-000000000000', 1,
   'Raw web event stream',
   '{"session_id": "string", "event_type": "string", "page": "string", "ts": "string"}',
   NULL, 'bb000002-0000-0000-0000-000000000000'),

  -- product-clickstream v2
  ('ff000005-0000-0000-0000-000000000000', 'ee000002-0000-0000-0000-000000000000', 2,
   'Nulls filtered, bot sessions removed',
   '{"session_id": "string", "event_type": "string", "page": "string", "ts": "string", "user_agent_clean": "string"}',
   'ff000004-0000-0000-0000-000000000000', 'bb000002-0000-0000-0000-000000000000'),

  -- marketing-attribution v1
  ('ff000006-0000-0000-0000-000000000000', 'ee000003-0000-0000-0000-000000000000', 1,
   'Multi-touch attribution export from ad platform',
   '{"customer_id": "string", "channel": "string", "touchpoint_ts": "string", "attributed_revenue": "number"}',
   NULL, 'bb000005-0000-0000-0000-000000000000'),

  -- sensor-telemetry-raw v1
  ('ff000007-0000-0000-0000-000000000000', 'ee000004-0000-0000-0000-000000000000', 1,
   'Direct IoT feed, no cleaning',
   '{"device_id": "string", "temp_c": "number", "pressure_pa": "number", "recorded_at": "string"}',
   NULL, 'bb000003-0000-0000-0000-000000000000'),

  -- sensor-telemetry-clean v1
  ('ff000008-0000-0000-0000-000000000000', 'ee000005-0000-0000-0000-000000000000', 1,
   'Outliers removed, nulls imputed',
   '{"device_id": "string", "temp_c": "number", "pressure_pa": "number", "recorded_at": "string"}',
   NULL, 'bb000003-0000-0000-0000-000000000000'),

  -- sensor-telemetry-clean v2
  ('ff000009-0000-0000-0000-000000000000', 'ee000005-0000-0000-0000-000000000000', 2,
   'Added humidity sensor; resampled to 1-min intervals',
   '{"device_id": "string", "temp_c": "number", "pressure_pa": "number", "humidity_pct": "number", "recorded_at": "string"}',
   'ff000008-0000-0000-0000-000000000000', 'bb000004-0000-0000-0000-000000000000'),

  -- weather-forecast-features v1
  ('ff000010-0000-0000-0000-000000000000', 'ee000006-0000-0000-0000-000000000000', 1,
   'ECMWF forecast features, 48-h horizon',
   '{"location_id": "string", "forecast_ts": "string", "temp_c": "number", "wind_kmh": "number", "precip_mm": "number"}',
   NULL, 'bb000004-0000-0000-0000-000000000000'),

  -- financial-transactions-raw v1
  ('ff000011-0000-0000-0000-000000000000', 'ee000007-0000-0000-0000-000000000000', 1,
   'Raw ledger export from core banking',
   '{"txn_id": "string", "account_id": "string", "amount_usd": "number", "merchant_code": "string", "txn_ts": "string"}',
   NULL, 'bb000006-0000-0000-0000-000000000000'),

  -- financial-transactions-enriched v1
  ('ff000012-0000-0000-0000-000000000000', 'ee000008-0000-0000-0000-000000000000', 1,
   'Joined with merchant lookup; fraud labels from ops team',
   '{"txn_id": "string", "account_id": "string", "amount_usd": "number", "merchant_name": "string", "merchant_category": "string", "is_fraud": "boolean", "txn_ts": "string"}',
   NULL, 'bb000003-0000-0000-0000-000000000000'); -- Carol again (multi-org contributor)


-- ─── Dataset Data Points ──────────────────────────────────────────────────────

INSERT INTO ds.dataset_data_points (version_id, data_payload, created_by) VALUES
  -- churn v1
  ('ff000001-0000-0000-0000-000000000000', '{"customer_id": "c-001", "churn_label": true,  "tenure_days": 45}',  'bb000001-0000-0000-0000-000000000000'),
  ('ff000001-0000-0000-0000-000000000000', '{"customer_id": "c-002", "churn_label": false, "tenure_days": 320}', 'bb000001-0000-0000-0000-000000000000'),
  ('ff000001-0000-0000-0000-000000000000', '{"customer_id": "c-003", "churn_label": true,  "tenure_days": 12}',  'bb000001-0000-0000-0000-000000000000'),
  ('ff000001-0000-0000-0000-000000000000', '{"customer_id": "c-004", "churn_label": false, "tenure_days": 540}', 'bb000001-0000-0000-0000-000000000000'),

  -- churn v2 (NPS added)
  ('ff000002-0000-0000-0000-000000000000', '{"customer_id": "c-001", "churn_label": true,  "tenure_days": 45,  "nps_score": 2.0}', 'bb000002-0000-0000-0000-000000000000'),
  ('ff000002-0000-0000-0000-000000000000', '{"customer_id": "c-002", "churn_label": false, "tenure_days": 320, "nps_score": 9.5}', 'bb000002-0000-0000-0000-000000000000'),
  ('ff000002-0000-0000-0000-000000000000', '{"customer_id": "c-003", "churn_label": true,  "tenure_days": 12,  "nps_score": 1.0}', 'bb000002-0000-0000-0000-000000000000'),
  ('ff000002-0000-0000-0000-000000000000', '{"customer_id": "c-004", "churn_label": false, "tenure_days": 540, "nps_score": 8.3}', 'bb000002-0000-0000-0000-000000000000'),
  ('ff000002-0000-0000-0000-000000000000', '{"customer_id": "c-005", "churn_label": false, "tenure_days": 180, "nps_score": 7.1}', 'bb000002-0000-0000-0000-000000000000'),

  -- churn v3 (support tier + contract value)
  ('ff000003-0000-0000-0000-000000000000', '{"customer_id": "c-001", "churn_label": true,  "nps_score": 2.0, "support_tier": "basic",      "contract_value_usd": 1200}',  'bb000001-0000-0000-0000-000000000000'),
  ('ff000003-0000-0000-0000-000000000000', '{"customer_id": "c-002", "churn_label": false, "nps_score": 9.5, "support_tier": "enterprise",  "contract_value_usd": 48000}', 'bb000001-0000-0000-0000-000000000000'),
  ('ff000003-0000-0000-0000-000000000000', '{"customer_id": "c-003", "churn_label": true,  "nps_score": 1.0, "support_tier": "basic",      "contract_value_usd": 800}',   'bb000001-0000-0000-0000-000000000000'),
  ('ff000003-0000-0000-0000-000000000000', '{"customer_id": "c-004", "churn_label": false, "nps_score": 8.3, "support_tier": "pro",        "contract_value_usd": 9600}',  'bb000001-0000-0000-0000-000000000000'),
  ('ff000003-0000-0000-0000-000000000000', '{"customer_id": "c-005", "churn_label": false, "nps_score": 7.1, "support_tier": "pro",        "contract_value_usd": 7200}',  'bb000001-0000-0000-0000-000000000000'),
  ('ff000003-0000-0000-0000-000000000000', '{"customer_id": "c-006", "churn_label": true,  "nps_score": 3.2, "support_tier": "basic",      "contract_value_usd": 600}',   'bb000001-0000-0000-0000-000000000000'),

  -- clickstream v1
  ('ff000004-0000-0000-0000-000000000000', '{"session_id": "s-aaa", "event_type": "page_view", "page": "/pricing",  "ts": "2025-01-10T09:00:00Z"}', 'bb000002-0000-0000-0000-000000000000'),
  ('ff000004-0000-0000-0000-000000000000', '{"session_id": "s-aaa", "event_type": "click",     "page": "/pricing",  "ts": "2025-01-10T09:00:42Z"}', 'bb000002-0000-0000-0000-000000000000'),
  ('ff000004-0000-0000-0000-000000000000', '{"session_id": "s-bbb", "event_type": "page_view", "page": "/features", "ts": "2025-01-10T10:15:00Z"}', 'bb000002-0000-0000-0000-000000000000'),
  ('ff000004-0000-0000-0000-000000000000', '{"session_id": "s-ccc", "event_type": "page_view", "page": "/home",     "ts": "2025-01-11T08:00:00Z"}', 'bb000002-0000-0000-0000-000000000000'),

  -- sensor-raw v1 (includes outlier on dev-01)
  ('ff000007-0000-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 22.4, "pressure_pa": 101325, "recorded_at": "2025-03-01T00:00:00Z"}', 'bb000003-0000-0000-0000-000000000000'),
  ('ff000007-0000-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 999,  "pressure_pa": 101400, "recorded_at": "2025-03-01T00:05:00Z"}', 'bb000003-0000-0000-0000-000000000000'),
  ('ff000007-0000-0000-0000-000000000000', '{"device_id": "dev-02", "temp_c": 21.1, "pressure_pa": 101280, "recorded_at": "2025-03-01T00:00:00Z"}', 'bb000003-0000-0000-0000-000000000000'),
  ('ff000007-0000-0000-0000-000000000000', '{"device_id": "dev-03", "temp_c": 19.8, "pressure_pa": 101300, "recorded_at": "2025-03-01T00:00:00Z"}', 'bb000003-0000-0000-0000-000000000000'),

  -- sensor-clean v2 (humidity added, outlier corrected)
  ('ff000009-0000-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 22.4, "pressure_pa": 101325, "humidity_pct": 58.2, "recorded_at": "2025-03-01T00:00:00Z"}', 'bb000004-0000-0000-0000-000000000000'),
  ('ff000009-0000-0000-0000-000000000000', '{"device_id": "dev-01", "temp_c": 22.6, "pressure_pa": 101400, "humidity_pct": 57.9, "recorded_at": "2025-03-01T00:01:00Z"}', 'bb000004-0000-0000-0000-000000000000'),
  ('ff000009-0000-0000-0000-000000000000', '{"device_id": "dev-02", "temp_c": 21.1, "pressure_pa": 101280, "humidity_pct": 62.0, "recorded_at": "2025-03-01T00:00:00Z"}', 'bb000004-0000-0000-0000-000000000000'),

  -- financial-transactions-enriched v1
  ('ff000012-0000-0000-0000-000000000000', '{"txn_id": "t-001", "account_id": "acc-A", "amount_usd": 42.50,   "merchant_name": "Coffee House",   "merchant_category": "food",    "is_fraud": false, "txn_ts": "2025-05-01T08:12:00Z"}', 'bb000006-0000-0000-0000-000000000000'),
  ('ff000012-0000-0000-0000-000000000000', '{"txn_id": "t-002", "account_id": "acc-A", "amount_usd": 1850.00, "merchant_name": "Online Gadgets",  "merchant_category": "retail",  "is_fraud": true,  "txn_ts": "2025-05-01T08:13:00Z"}', 'bb000006-0000-0000-0000-000000000000'),
  ('ff000012-0000-0000-0000-000000000000', '{"txn_id": "t-003", "account_id": "acc-B", "amount_usd": 220.00,  "merchant_name": "City Pharmacy",   "merchant_category": "health",  "is_fraud": false, "txn_ts": "2025-05-02T14:00:00Z"}', 'bb000006-0000-0000-0000-000000000000'),
  ('ff000012-0000-0000-0000-000000000000', '{"txn_id": "t-004", "account_id": "acc-C", "amount_usd": 9999.99, "merchant_name": "Wire Transfer Co", "merchant_category": "finance", "is_fraud": true,  "txn_ts": "2025-05-02T14:01:00Z"}', 'bb000006-0000-0000-0000-000000000000'),
  ('ff000012-0000-0000-0000-000000000000', '{"txn_id": "t-005", "account_id": "acc-B", "amount_usd": 55.00,   "merchant_name": "Grocery Mart",    "merchant_category": "food",    "is_fraud": false, "txn_ts": "2025-05-03T09:30:00Z"}', 'bb000006-0000-0000-0000-000000000000');


-- ─── Experiments ──────────────────────────────────────────────────────────────

INSERT INTO exp.experiments (experiment_id, org_id, experiment_name, created_by) VALUES
  -- Acme
  ('11000001-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'Churn XGBoost Baseline',             'bb000001-0000-0000-0000-000000000000'),
  ('11000002-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'Churn XGBoost + NPS Feature',        'bb000002-0000-0000-0000-000000000000'),
  ('11000003-0000-0000-0000-000000000000', 'aa000001-0000-0000-0000-000000000000', 'Churn + Attribution Multi-Dataset',  'bb000001-0000-0000-0000-000000000000'),
  -- Bright
  ('11000004-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'Sensor Anomaly Isolation Forest',    'bb000003-0000-0000-0000-000000000000'),
  ('11000005-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'Sensor Anomaly Autoencoder',         'bb000003-0000-0000-0000-000000000000'),
  ('11000006-0000-0000-0000-000000000000', 'aa000002-0000-0000-0000-000000000000', 'Weather Forecast Regression',        'bb000004-0000-0000-0000-000000000000'),
  -- Quantum
  ('11000007-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000', 'Fraud Detection v1 (Gradient Boost)','bb000006-0000-0000-0000-000000000000'),
  ('11000008-0000-0000-0000-000000000000', 'aa000003-0000-0000-0000-000000000000', 'Fraud Detection v2 (Neural Net)',    'bb000003-0000-0000-0000-000000000000'); -- Carol, multi-org


-- ─── Experiment → Dataset refs ────────────────────────────────────────────────

INSERT INTO exp.experiment_data_ver_refs (experiment_id, dataset_version_id, ref_order) VALUES
  -- Baseline: churn v1 only
  ('11000001-0000-0000-0000-000000000000', 'ff000001-0000-0000-0000-000000000000', 1),
  -- NPS: churn v2 + clickstream v2
  ('11000002-0000-0000-0000-000000000000', 'ff000002-0000-0000-0000-000000000000', 1),
  ('11000002-0000-0000-0000-000000000000', 'ff000005-0000-0000-0000-000000000000', 2),
  -- Multi-dataset: churn v3 + clickstream v2 + attribution v1
  ('11000003-0000-0000-0000-000000000000', 'ff000003-0000-0000-0000-000000000000', 1),
  ('11000003-0000-0000-0000-000000000000', 'ff000005-0000-0000-0000-000000000000', 2),
  ('11000003-0000-0000-0000-000000000000', 'ff000006-0000-0000-0000-000000000000', 3),
  -- Isolation Forest: raw sensor v1
  ('11000004-0000-0000-0000-000000000000', 'ff000007-0000-0000-0000-000000000000', 1),
  -- Autoencoder: clean sensor v2 + weather v1
  ('11000005-0000-0000-0000-000000000000', 'ff000009-0000-0000-0000-000000000000', 1),
  ('11000005-0000-0000-0000-000000000000', 'ff000010-0000-0000-0000-000000000000', 2),
  -- Weather Regression: weather v1
  ('11000006-0000-0000-0000-000000000000', 'ff000010-0000-0000-0000-000000000000', 1),
  -- Fraud v1 + v2 both use the same enriched dataset
  ('11000007-0000-0000-0000-000000000000', 'ff000012-0000-0000-0000-000000000000', 1),
  ('11000008-0000-0000-0000-000000000000', 'ff000012-0000-0000-0000-000000000000', 1);


-- ─── Experiment Parameters ────────────────────────────────────────────────────

INSERT INTO exp.experiment_parameters (experiment_id, param_key, param_type, param_value) VALUES
  ('11000001-0000-0000-0000-000000000000', 'n_estimators',          'int',    '100'),
  ('11000001-0000-0000-0000-000000000000', 'max_depth',             'int',    '6'),
  ('11000001-0000-0000-0000-000000000000', 'learning_rate',         'float',  '0.1'),
  ('11000001-0000-0000-0000-000000000000', 'objective',             'string', '"binary:logistic"'),

  ('11000002-0000-0000-0000-000000000000', 'n_estimators',          'int',    '200'),
  ('11000002-0000-0000-0000-000000000000', 'max_depth',             'int',    '8'),
  ('11000002-0000-0000-0000-000000000000', 'learning_rate',         'float',  '0.05'),
  ('11000002-0000-0000-0000-000000000000', 'objective',             'string', '"binary:logistic"'),
  ('11000002-0000-0000-0000-000000000000', 'use_nps',               'boolean','true'),

  ('11000003-0000-0000-0000-000000000000', 'n_estimators',          'int',    '300'),
  ('11000003-0000-0000-0000-000000000000', 'max_depth',             'int',    '10'),
  ('11000003-0000-0000-0000-000000000000', 'learning_rate',         'float',  '0.03'),
  ('11000003-0000-0000-0000-000000000000', 'objective',             'string', '"binary:logistic"'),
  ('11000003-0000-0000-0000-000000000000', 'attribution_window_days','int',   '30'),

  ('11000004-0000-0000-0000-000000000000', 'algorithm',             'string', '"isolation_forest"'),
  ('11000004-0000-0000-0000-000000000000', 'contamination',         'float',  '0.05'),
  ('11000004-0000-0000-0000-000000000000', 'n_estimators',          'int',    '100'),

  ('11000005-0000-0000-0000-000000000000', 'algorithm',             'string', '"autoencoder"'),
  ('11000005-0000-0000-0000-000000000000', 'epochs',                'int',    '50'),
  ('11000005-0000-0000-0000-000000000000', 'latent_dim',            'int',    '8'),
  ('11000005-0000-0000-0000-000000000000', 'threshold',             'float',  '0.02'),

  ('11000006-0000-0000-0000-000000000000', 'algorithm',             'string', '"gradient_boosting_regressor"'),
  ('11000006-0000-0000-0000-000000000000', 'n_estimators',          'int',    '150'),
  ('11000006-0000-0000-0000-000000000000', 'forecast_horizon_h',    'int',    '48'),

  ('11000007-0000-0000-0000-000000000000', 'algorithm',             'string', '"xgboost"'),
  ('11000007-0000-0000-0000-000000000000', 'n_estimators',          'int',    '500'),
  ('11000007-0000-0000-0000-000000000000', 'scale_pos_weight',      'float',  '20.0'),
  ('11000007-0000-0000-0000-000000000000', 'threshold',             'float',  '0.4'),

  ('11000008-0000-0000-0000-000000000000', 'algorithm',             'string', '"transformer"'),
  ('11000008-0000-0000-0000-000000000000', 'hidden_layers',         'json',   '[128, 64, 32]'),
  ('11000008-0000-0000-0000-000000000000', 'dropout',               'float',  '0.3'),
  ('11000008-0000-0000-0000-000000000000', 'epochs',                'int',    '100'),
  ('11000008-0000-0000-0000-000000000000', 'threshold',             'float',  '0.35');


-- ─── Runs ─────────────────────────────────────────────────────────────────────

INSERT INTO run.runs (run_id, experiment_id, cluster_id, dataset_version_id, status, created_at, started_at, ended_at, created_by) VALUES
  -- Churn Baseline: succeeded
  ('22000001-0000-0000-0000-000000000000', '11000001-0000-0000-0000-000000000000', 'dd000001-0000-0000-0000-000000000000',
   'ff000001-0000-0000-0000-000000000000', 'succeeded', '2025-04-01 08:00:00', '2025-04-01 08:01:00', '2025-04-01 08:47:00', 'bb000001-0000-0000-0000-000000000000'),

  -- Churn + NPS: failed first, then succeeded
  ('22000002-0000-0000-0000-000000000000', '11000002-0000-0000-0000-000000000000', 'dd000001-0000-0000-0000-000000000000',
   'ff000002-0000-0000-0000-000000000000', 'failed',    '2025-04-02 09:00:00', '2025-04-02 09:01:00', '2025-04-02 09:05:00', 'bb000002-0000-0000-0000-000000000000'),
  ('22000003-0000-0000-0000-000000000000', '11000002-0000-0000-0000-000000000000', 'dd000001-0000-0000-0000-000000000000',
   'ff000002-0000-0000-0000-000000000000', 'succeeded', '2025-04-02 10:00:00', '2025-04-02 10:01:00', '2025-04-02 11:23:00', 'bb000002-0000-0000-0000-000000000000'),

  -- Churn + Attribution: cancelled (bad join), then succeeded on bigger cluster
  ('22000004-0000-0000-0000-000000000000', '11000003-0000-0000-0000-000000000000', 'dd000002-0000-0000-0000-000000000000',
   'ff000003-0000-0000-0000-000000000000', 'cancelled', '2025-04-03 07:00:00', '2025-04-03 07:01:00', '2025-04-03 07:30:00', 'bb000001-0000-0000-0000-000000000000'),
  ('22000005-0000-0000-0000-000000000000', '11000003-0000-0000-0000-000000000000', 'dd000001-0000-0000-0000-000000000000',
   'ff000003-0000-0000-0000-000000000000', 'succeeded', '2025-04-03 09:00:00', '2025-04-03 09:01:00', '2025-04-03 11:58:00', 'bb000001-0000-0000-0000-000000000000'),

  -- Isolation Forest: succeeded
  ('22000006-0000-0000-0000-000000000000', '11000004-0000-0000-0000-000000000000', 'dd000003-0000-0000-0000-000000000000',
   'ff000007-0000-0000-0000-000000000000', 'succeeded', '2025-04-05 14:00:00', '2025-04-05 14:00:30', '2025-04-05 14:22:00', 'bb000003-0000-0000-0000-000000000000'),

  -- Autoencoder: OOM on smaller cluster, succeeded on bigger one
  ('22000007-0000-0000-0000-000000000000', '11000005-0000-0000-0000-000000000000', 'dd000003-0000-0000-0000-000000000000',
   'ff000009-0000-0000-0000-000000000000', 'failed',    '2025-04-07 10:00:00', '2025-04-07 10:01:00', '2025-04-07 10:08:00', 'bb000003-0000-0000-0000-000000000000'),
  ('22000008-0000-0000-0000-000000000000', '11000005-0000-0000-0000-000000000000', 'dd000004-0000-0000-0000-000000000000',
   'ff000009-0000-0000-0000-000000000000', 'succeeded', '2025-04-07 11:00:00', '2025-04-07 11:01:00', '2025-04-07 13:15:00', 'bb000003-0000-0000-0000-000000000000'),

  -- Weather Regression: two runs (hyperparameter sweep)
  ('22000009-0000-0000-0000-000000000000', '11000006-0000-0000-0000-000000000000', 'dd000002-0000-0000-0000-000000000000',
   'ff000010-0000-0000-0000-000000000000', 'succeeded', '2025-04-08 08:00:00', '2025-04-08 08:01:00', '2025-04-08 08:45:00', 'bb000004-0000-0000-0000-000000000000'),
  ('22000010-0000-0000-0000-000000000000', '11000006-0000-0000-0000-000000000000', 'dd000002-0000-0000-0000-000000000000',
   'ff000010-0000-0000-0000-000000000000', 'succeeded', '2025-04-08 09:00:00', '2025-04-08 09:01:00', '2025-04-08 09:52:00', 'bb000004-0000-0000-0000-000000000000'),

  -- Fraud v1: succeeded
  ('22000011-0000-0000-0000-000000000000', '11000007-0000-0000-0000-000000000000', 'dd000004-0000-0000-0000-000000000000',
   'ff000012-0000-0000-0000-000000000000', 'succeeded', '2025-04-10 10:00:00', '2025-04-10 10:01:00', '2025-04-10 11:40:00', 'bb000006-0000-0000-0000-000000000000'),

  -- Fraud v2: running + one queued behind it
  ('22000012-0000-0000-0000-000000000000', '11000008-0000-0000-0000-000000000000', 'dd000004-0000-0000-0000-000000000000',
   'ff000012-0000-0000-0000-000000000000', 'running',   '2025-04-11 09:00:00', '2025-04-11 09:00:45', NULL,                  'bb000003-0000-0000-0000-000000000000'),
  ('22000013-0000-0000-0000-000000000000', '11000008-0000-0000-0000-000000000000', 'dd000001-0000-0000-0000-000000000000',
   'ff000012-0000-0000-0000-000000000000', 'queued',    '2025-04-11 09:30:00', NULL,                   NULL,                  'bb000006-0000-0000-0000-000000000000');


-- ─── Run Logs ─────────────────────────────────────────────────────────────────

INSERT INTO run.run_logs (run_id, log_level, log_message, created_at) VALUES
  ('22000001-0000-0000-0000-000000000000', 'INFO',  'Loading customer-churn-signals v1 (4 rows)',                      '2025-04-01 08:01:05'),
  ('22000001-0000-0000-0000-000000000000', 'INFO',  'Training XGBoost: n_estimators=100, max_depth=6',                '2025-04-01 08:02:00'),
  ('22000001-0000-0000-0000-000000000000', 'INFO',  'Training complete. AUC-ROC: 0.82',                               '2025-04-01 08:47:00'),

  ('22000002-0000-0000-0000-000000000000', 'INFO',  'Loading churn v2 and clickstream v2',                            '2025-04-02 09:01:10'),
  ('22000002-0000-0000-0000-000000000000', 'ERROR', 'Feature join failed: clickstream session_id contains nulls',      '2025-04-02 09:05:00'),

  ('22000003-0000-0000-0000-000000000000', 'INFO',  'Loading churn v2 and clickstream v2',                            '2025-04-02 10:01:05'),
  ('22000003-0000-0000-0000-000000000000', 'WARN',  '12 rows dropped: null session_id in clickstream join',            '2025-04-02 10:03:00'),
  ('22000003-0000-0000-0000-000000000000', 'INFO',  'Training XGBoost: n_estimators=200, max_depth=8',                '2025-04-02 10:05:00'),
  ('22000003-0000-0000-0000-000000000000', 'INFO',  'Training complete. AUC-ROC: 0.89 (+0.07 vs baseline)',            '2025-04-02 11:23:00'),

  ('22000004-0000-0000-0000-000000000000', 'INFO',  'Loading 3 datasets: churn v3, clickstream v2, attribution v1',   '2025-04-03 07:01:00'),
  ('22000004-0000-0000-0000-000000000000', 'WARN',  'Attribution join produced 0 matches — cancelling run',           '2025-04-03 07:30:00'),

  ('22000005-0000-0000-0000-000000000000', 'INFO',  'Loading 3 datasets: churn v3, clickstream v2, attribution v1',   '2025-04-03 09:01:00'),
  ('22000005-0000-0000-0000-000000000000', 'INFO',  'Join produced 5 matched customers',                              '2025-04-03 09:05:00'),
  ('22000005-0000-0000-0000-000000000000', 'INFO',  'Training complete. AUC-ROC: 0.91',                               '2025-04-03 11:58:00'),

  ('22000006-0000-0000-0000-000000000000', 'INFO',  'Loading sensor-telemetry-raw v1 (4 rows)',                        '2025-04-05 14:00:35'),
  ('22000006-0000-0000-0000-000000000000', 'WARN',  'Detected outlier: dev-01 temp_c=999 at 00:05',                   '2025-04-05 14:01:00'),
  ('22000006-0000-0000-0000-000000000000', 'INFO',  'Isolation Forest complete. Anomaly rate: 4.8%',                  '2025-04-05 14:22:00'),

  ('22000007-0000-0000-0000-000000000000', 'INFO',  'Loading sensor-clean v2 and weather v1',                         '2025-04-07 10:01:05'),
  ('22000007-0000-0000-0000-000000000000', 'ERROR', 'Out of memory: ram_gb=96 insufficient for batch_size=4096',       '2025-04-07 10:08:00'),

  ('22000008-0000-0000-0000-000000000000', 'INFO',  'Loading sensor-clean v2 and weather v1',                         '2025-04-07 11:01:05'),
  ('22000008-0000-0000-0000-000000000000', 'DEBUG', 'Autoencoder: input=3, latent=8, output=3',                       '2025-04-07 11:02:00'),
  ('22000008-0000-0000-0000-000000000000', 'INFO',  'Epoch 10/50 — val_loss: 0.038',                                  '2025-04-07 11:15:00'),
  ('22000008-0000-0000-0000-000000000000', 'INFO',  'Epoch 50/50 — val_loss: 0.011',                                  '2025-04-07 12:45:00'),
  ('22000008-0000-0000-0000-000000000000', 'INFO',  'Training complete. Reconstruction threshold: 0.02',              '2025-04-07 13:15:00'),

  ('22000009-0000-0000-0000-000000000000', 'INFO',  'n_estimators=150, forecast_horizon=48h',                         '2025-04-08 08:01:10'),
  ('22000009-0000-0000-0000-000000000000', 'INFO',  'Training complete. MAE: 1.42 C',                                 '2025-04-08 08:45:00'),

  ('22000010-0000-0000-0000-000000000000', 'INFO',  'n_estimators=300, forecast_horizon=48h',                         '2025-04-08 09:01:10'),
  ('22000010-0000-0000-0000-000000000000', 'INFO',  'Training complete. MAE: 1.28 C (-0.14 vs run 1)',                 '2025-04-08 09:52:00'),

  ('22000011-0000-0000-0000-000000000000', 'INFO',  'Loading financial-transactions-enriched v1 (5 rows)',             '2025-04-10 10:01:05'),
  ('22000011-0000-0000-0000-000000000000', 'WARN',  'Class imbalance: 2/5 fraud (40%) — scale_pos_weight=20',         '2025-04-10 10:02:00'),
  ('22000011-0000-0000-0000-000000000000', 'INFO',  'Training complete. Precision: 0.91, Recall: 0.88',               '2025-04-10 11:40:00'),

  ('22000012-0000-0000-0000-000000000000', 'INFO',  'Loading financial-transactions-enriched v1',                     '2025-04-11 09:00:50'),
  ('22000012-0000-0000-0000-000000000000', 'DEBUG', 'Transformer: layers=[128,64,32], dropout=0.3',                   '2025-04-11 09:01:00'),
  ('22000012-0000-0000-0000-000000000000', 'INFO',  'Epoch 10/100 — val_loss: 0.22',                                  '2025-04-11 09:15:00');


-- ─── Run Output Artifacts ─────────────────────────────────────────────────────

INSERT INTO run.run_output_artifacts (run_id, artifact_type, artifact_payload) VALUES
  ('22000001-0000-0000-0000-000000000000', 'model_metrics', '{
    "auc_roc": 0.82, "precision": 0.74, "recall": 0.68, "f1": 0.71,
    "model_path": "s3://acme-models/churn-xgb-baseline/model.ubj"
  }'),
  ('22000003-0000-0000-0000-000000000000', 'model_metrics', '{
    "auc_roc": 0.89, "precision": 0.81, "recall": 0.76, "f1": 0.78,
    "model_path": "s3://acme-models/churn-xgb-nps/model.ubj",
    "feature_importance": {"nps_score": 0.23, "tenure_days": 0.41, "churn_label": 0.36}
  }'),
  ('22000005-0000-0000-0000-000000000000', 'model_metrics', '{
    "auc_roc": 0.91, "precision": 0.85, "recall": 0.80, "f1": 0.82,
    "model_path": "s3://acme-models/churn-xgb-attribution/model.ubj",
    "feature_importance": {"contract_value_usd": 0.31, "nps_score": 0.21, "attributed_revenue": 0.19}
  }'),
  ('22000006-0000-0000-0000-000000000000', 'model_metrics', '{
    "anomaly_rate": 0.048, "flagged_devices": ["dev-01"],
    "model_path": "s3://bright-models/sensor-iforest/model.pkl"
  }'),
  ('22000008-0000-0000-0000-000000000000', 'model_metrics', '{
    "reconstruction_threshold": 0.02, "anomaly_rate": 0.031, "flagged_devices": ["dev-01"],
    "model_path": "s3://bright-models/sensor-autoencoder/model.h5"
  }'),
  ('22000009-0000-0000-0000-000000000000', 'model_metrics', '{
    "mae_celsius": 1.42, "rmse_celsius": 2.01,
    "model_path": "s3://bright-models/weather-gbr-r1/model.pkl"
  }'),
  ('22000010-0000-0000-0000-000000000000', 'model_metrics', '{
    "mae_celsius": 1.28, "rmse_celsius": 1.87,
    "model_path": "s3://bright-models/weather-gbr-r2/model.pkl"
  }'),
  ('22000011-0000-0000-0000-000000000000', 'model_metrics', '{
    "precision": 0.91, "recall": 0.88, "f1": 0.895, "auc_roc": 0.96,
    "model_path": "s3://quantum-models/fraud-xgb-v1/model.ubj"
  }');
