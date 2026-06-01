-- ============================================================================
-- EXPERIMENT TRACKING SYSTEM - DATABASE SCHEMA
-- ============================================================================
-- This script creates all tables, relationships, and constraints for the 
-- experiment tracking and dataset versioning system.
-- ============================================================================

-- Drop existing tables (for clean slate - comment out if preserving data)
DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS run_output_artifacts CASCADE;
DROP TABLE IF EXISTS run_logs CASCADE;
DROP TABLE IF EXISTS runs CASCADE;
DROP TABLE IF EXISTS compute_clusters CASCADE;
DROP TABLE IF EXISTS experiment_parameters CASCADE;
DROP TABLE IF EXISTS experiment_dataset_refs CASCADE;
DROP TABLE IF EXISTS experiments CASCADE;
DROP TABLE IF EXISTS dataset_data_points CASCADE;
DROP TABLE IF EXISTS dataset_versions CASCADE;
DROP TABLE IF EXISTS datasets CASCADE;
DROP TABLE IF EXISTS user_role_assignments CASCADE;
DROP TABLE IF EXISTS role_policy_assignments CASCADE;
DROP TABLE IF EXISTS access_policies CASCADE;
DROP TABLE IF EXISTS roles CASCADE;
DROP TABLE IF EXISTS user_org_memberships CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS organizations CASCADE;

-- ============================================================================
-- SECTION A: ORGANIZATION & USER MANAGEMENT
-- ============================================================================

CREATE TABLE organizations (
  org_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  metadata JSONB DEFAULT '{}'::jsonb,
  
  CONSTRAINT org_name_not_empty CHECK (org_name != '')
);

CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  state_id VARCHAR(9) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE,
  
  CONSTRAINT state_id_format CHECK (state_id ~ '^\d{9}$'),
  CONSTRAINT email_format CHECK (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$')
);

CREATE TABLE user_org_memberships (
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  joined_at TIMESTAMP DEFAULT NOW(),
  
  PRIMARY KEY (user_id, org_id)
);

-- Indexes for common queries
CREATE INDEX idx_user_org_memberships_org_id ON user_org_memberships(org_id);
CREATE INDEX idx_user_org_memberships_user_id ON user_org_memberships(user_id);

-- ============================================================================
-- SECTION B: ROLES & ACCESS CONTROL
-- ============================================================================

CREATE TABLE access_policies (
  policy_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  policy_name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  
  CONSTRAINT policy_name_not_empty CHECK (policy_name != '')
);

-- Insert predefined policies
INSERT INTO access_policies (policy_name, description) VALUES
  ('dataset_editor', 'Can create, edit, and manage datasets'),
  ('experiment_runner', 'Can create and run experiments'),
  ('admin', 'Full administrative access to organization'),
  ('analytics_team', 'Can view analytics and reports');

CREATE TABLE roles (
  role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  role_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE (org_id, role_name),
  CONSTRAINT role_name_not_empty CHECK (role_name != '')
);

CREATE INDEX idx_roles_org_id ON roles(org_id);

CREATE TABLE role_policy_assignments (
  role_id UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
  policy_id UUID NOT NULL REFERENCES access_policies(policy_id) ON DELETE RESTRICT,
  
  PRIMARY KEY (role_id, policy_id)
);

CREATE INDEX idx_role_policy_assignments_policy_id ON role_policy_assignments(policy_id);

CREATE TABLE user_role_assignments (
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  role_id UUID NOT NULL REFERENCES roles(role_id) ON DELETE CASCADE,
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  assigned_at TIMESTAMP DEFAULT NOW(),
  
  PRIMARY KEY (user_id, role_id, org_id),
  CONSTRAINT user_role_org_consistency CHECK (
    -- Ensures user_role_assignments.role_id belongs to the specified org
    -- This is a soft constraint; hard constraint handled via trigger
  )
);

CREATE INDEX idx_user_role_assignments_user_id ON user_role_assignments(user_id);
CREATE INDEX idx_user_role_assignments_role_id ON user_role_assignments(role_id);
CREATE INDEX idx_user_role_assignments_org_id ON user_role_assignments(org_id);

-- ============================================================================
-- SECTION C: DATASETS & VERSIONING
-- ============================================================================

CREATE TABLE datasets (
  dataset_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  dataset_key VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
  
  UNIQUE (org_id, dataset_key),
  CONSTRAINT dataset_key_not_empty CHECK (dataset_key != '')
);

CREATE INDEX idx_datasets_org_id ON datasets(org_id);
CREATE INDEX idx_datasets_created_by ON datasets(created_by);

CREATE TABLE dataset_versions (
  version_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  dataset_id UUID NOT NULL REFERENCES datasets(dataset_id) ON DELETE CASCADE,
  version_number INT NOT NULL,
  description TEXT,
  schema_definition JSONB NOT NULL,
  parent_version_id UUID REFERENCES dataset_versions(version_id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
  
  UNIQUE (dataset_id, version_number),
  CONSTRAINT version_number_positive CHECK (version_number > 0),
  CONSTRAINT schema_not_empty CHECK (schema_definition != '{}'::jsonb)
);

CREATE INDEX idx_dataset_versions_dataset_id ON dataset_versions(dataset_id);
CREATE INDEX idx_dataset_versions_parent_version_id ON dataset_versions(parent_version_id);
CREATE INDEX idx_dataset_versions_created_by ON dataset_versions(created_by);

CREATE TABLE dataset_data_points (
  data_point_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  version_id UUID NOT NULL REFERENCES dataset_versions(version_id) ON DELETE RESTRICT,
  data_payload JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
  
  CONSTRAINT data_payload_not_empty CHECK (data_payload != '{}'::jsonb)
);

CREATE INDEX idx_dataset_data_points_version_id ON dataset_data_points(version_id);
CREATE INDEX idx_dataset_data_points_created_at ON dataset_data_points(created_at);
CREATE INDEX idx_dataset_data_points_created_by ON dataset_data_points(created_by);

-- ============================================================================
-- SECTION D: EXPERIMENTS
-- ============================================================================

CREATE TABLE experiments (
  experiment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES organizations(org_id) ON DELETE CASCADE,
  experiment_name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
  
  CONSTRAINT experiment_name_not_empty CHECK (experiment_name != '')
);

CREATE INDEX idx_experiments_org_id ON experiments(org_id);
CREATE INDEX idx_experiments_created_by ON experiments(created_by);

CREATE TABLE experiment_dataset_refs (
  experiment_id UUID NOT NULL REFERENCES experiments(experiment_id) ON DELETE CASCADE,
  dataset_version_id UUID NOT NULL REFERENCES dataset_versions(version_id) ON DELETE RESTRICT,
  ref_order INT NOT NULL,
  
  PRIMARY KEY (experiment_id, dataset_version_id),
  CONSTRAINT ref_order_positive CHECK (ref_order > 0)
);

CREATE INDEX idx_experiment_dataset_refs_dataset_version_id ON experiment_dataset_refs(dataset_version_id);

CREATE TABLE experiment_parameters (
  experiment_id UUID NOT NULL REFERENCES experiments(experiment_id) ON DELETE CASCADE,
  param_key VARCHAR(255) NOT NULL,
  param_type VARCHAR(50) NOT NULL,
  param_value JSONB NOT NULL,
  
  PRIMARY KEY (experiment_id, param_key),
  CONSTRAINT param_type_valid CHECK (param_type IN ('int', 'string', 'float', 'boolean', 'json')),
  CONSTRAINT param_key_not_empty CHECK (param_key != '')
);

CREATE INDEX idx_experiment_parameters_experiment_id ON experiment_parameters(experiment_id);

-- ============================================================================
-- SECTION E: COMPUTE CLUSTERS
-- ============================================================================

CREATE TABLE compute_clusters (
  cluster_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cluster_name VARCHAR(255) NOT NULL UNIQUE,
  region VARCHAR(100) NOT NULL,
  ip_address INET NOT NULL,
  cpu_cores INT NOT NULL,
  ram_gb INT NOT NULL,
  disk_tb DECIMAL(10, 2) NOT NULL,
  network_bandwidth_mbps INT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE,
  
  CONSTRAINT cluster_name_not_empty CHECK (cluster_name != ''),
  CONSTRAINT cpu_cores_positive CHECK (cpu_cores > 0),
  CONSTRAINT ram_gb_positive CHECK (ram_gb > 0),
  CONSTRAINT disk_tb_positive CHECK (disk_tb > 0),
  CONSTRAINT network_bandwidth_positive CHECK (network_bandwidth_mbps > 0)
);

CREATE INDEX idx_compute_clusters_region ON compute_clusters(region);
CREATE INDEX idx_compute_clusters_is_active ON compute_clusters(is_active);

-- ============================================================================
-- SECTION F: RUNS & EXECUTION
-- ============================================================================

CREATE TABLE runs (
  run_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  experiment_id UUID NOT NULL REFERENCES experiments(experiment_id) ON DELETE RESTRICT,
  cluster_id UUID NOT NULL REFERENCES compute_clusters(cluster_id) ON DELETE RESTRICT,
  status VARCHAR(50) NOT NULL DEFAULT 'queued',
  created_at TIMESTAMP DEFAULT NOW(),
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  created_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
  
  CONSTRAINT status_valid CHECK (status IN ('queued', 'running', 'succeeded', 'failed', 'cancelled')),
  CONSTRAINT started_after_created CHECK (started_at IS NULL OR started_at >= created_at),
  CONSTRAINT ended_after_started CHECK (ended_at IS NULL OR (started_at IS NOT NULL AND ended_at >= started_at))
);

CREATE INDEX idx_runs_experiment_id ON runs(experiment_id);
CREATE INDEX idx_runs_cluster_id ON runs(cluster_id);
CREATE INDEX idx_runs_status ON runs(status);
CREATE INDEX idx_runs_experiment_status ON runs(experiment_id, status);
CREATE INDEX idx_runs_created_by ON runs(created_by);

CREATE TABLE run_logs (
  log_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id UUID NOT NULL REFERENCES runs(run_id) ON DELETE CASCADE,
  log_message TEXT NOT NULL,
  log_level VARCHAR(20) DEFAULT 'INFO',
  created_at TIMESTAMP DEFAULT NOW(),
  
  CONSTRAINT log_level_valid CHECK (log_level IN ('DEBUG', 'INFO', 'WARN', 'ERROR')),
  CONSTRAINT log_message_not_empty CHECK (log_message != '')
);

CREATE INDEX idx_run_logs_run_id ON run_logs(run_id);
CREATE INDEX idx_run_logs_created_at ON run_logs(created_at);
CREATE INDEX idx_run_logs_log_level ON run_logs(log_level);

CREATE TABLE run_output_artifacts (
  artifact_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id UUID NOT NULL UNIQUE REFERENCES runs(run_id) ON DELETE CASCADE,
  artifact_type VARCHAR(100) NOT NULL,
  artifact_payload JSONB NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  
  CONSTRAINT artifact_type_not_empty CHECK (artifact_type != ''),
  CONSTRAINT artifact_payload_not_empty CHECK (artifact_payload != '{}'::jsonb)
);

CREATE INDEX idx_run_output_artifacts_run_id ON run_output_artifacts(run_id);
CREATE INDEX idx_run_output_artifacts_artifact_type ON run_output_artifacts(artifact_type);

-- ============================================================================
-- SECTION G: AUDIT LOG (Tamper-Evident)
-- ============================================================================

CREATE TABLE audit_log (
  audit_id BIGSERIAL PRIMARY KEY,
  entity_type VARCHAR(100) NOT NULL,
  entity_id UUID NOT NULL,
  operation VARCHAR(10) NOT NULL,
  old_values JSONB,
  new_values JSONB,
  changed_by UUID REFERENCES users(user_id) ON DELETE SET NULL,
  changed_at TIMESTAMP DEFAULT NOW(),
  
  CONSTRAINT entity_type_valid CHECK (entity_type IN ('dataset', 'dataset_version', 'experiment', 'run', 'permission')),
  CONSTRAINT operation_valid CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
  CONSTRAINT new_values_required_for_insert CHECK (operation != 'INSERT' OR new_values IS NOT NULL),
  CONSTRAINT old_values_required_for_delete CHECK (operation != 'DELETE' OR old_values IS NOT NULL)
);

CREATE INDEX idx_audit_log_entity_type_id ON audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_log_changed_by ON audit_log(changed_by);
CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at);
CREATE INDEX idx_audit_log_operation ON audit_log(operation);

-- ============================================================================
-- SECTION H: VIEWS FOR REPRODUCIBILITY & ANALYTICS
-- ============================================================================

-- View: Dataset lineage (parent chain for each version)
CREATE OR REPLACE VIEW v_dataset_lineage AS
WITH RECURSIVE lineage AS (
  -- Base case: all dataset versions
  SELECT
    version_id,
    dataset_id,
    version_number,
    parent_version_id,
    ARRAY[version_id] AS lineage_chain
  FROM dataset_versions
  WHERE parent_version_id IS NULL
  
  UNION ALL
  
  -- Recursive case: build parent chain
  SELECT
    dv.version_id,
    dv.dataset_id,
    dv.version_number,
    dv.parent_version_id,
    lineage.lineage_chain || ARRAY[dv.version_id]
  FROM dataset_versions dv
  INNER JOIN lineage ON dv.parent_version_id = lineage.version_id
)
SELECT
  version_id,
  dataset_id,
  version_number,
  parent_version_id,
  lineage_chain,
  array_length(lineage_chain, 1) AS chain_depth
FROM lineage
ORDER BY dataset_id, version_number;

-- View: Dataset versions used by experiment
CREATE OR REPLACE VIEW v_experiment_dataset_usage AS
SELECT
  e.experiment_id,
  e.experiment_name,
  e.org_id,
  edr.dataset_version_id,
  dv.dataset_id,
  d.dataset_key,
  dv.version_number,
  edr.ref_order
FROM experiments e
LEFT JOIN experiment_dataset_refs edr ON e.experiment_id = edr.experiment_id
LEFT JOIN dataset_versions dv ON edr.dataset_version_id = dv.version_id
LEFT JOIN datasets d ON dv.dataset_id = d.dataset_id
ORDER BY e.experiment_id, edr.ref_order;

-- View: Run execution environment (captures reproducibility data)
CREATE OR REPLACE VIEW v_run_environment AS
SELECT
  r.run_id,
  r.experiment_id,
  e.org_id,
  cc.cluster_id,
  cc.cluster_name,
  cc.region,
  cc.cpu_cores,
  cc.ram_gb,
  cc.disk_tb,
  cc.network_bandwidth_mbps,
  r.status,
  r.created_at,
  r.started_at,
  r.ended_at,
  EXTRACT(EPOCH FROM (r.ended_at - r.started_at)) AS execution_seconds
FROM runs r
INNER JOIN experiments e ON r.experiment_id = e.experiment_id
INNER JOIN compute_clusters cc ON r.cluster_id = cc.cluster_id
ORDER BY r.created_at DESC;

-- View: All dataset versions as columns with parent chains as rows
CREATE OR REPLACE VIEW v_dataset_versions_matrix AS
SELECT
  v.version_id,
  v.version_number,
  v.dataset_id,
  d.dataset_key,
  d.org_id,
  v.lineage_chain::text AS parent_chain
FROM v_dataset_lineage v
INNER JOIN datasets d ON v.dataset_id = d.dataset_id
ORDER BY d.dataset_key, v.version_number;

-- View: All dataset IDs with their versions
CREATE OR REPLACE VIEW v_datasets_with_versions AS
SELECT
  d.dataset_id,
  d.dataset_key,
  d.org_id,
  COALESCE(dv.version_id::text, '-') AS version_id,
  COALESCE(dv.version_number::text, '-') AS version_number
FROM datasets d
LEFT JOIN dataset_versions dv ON d.dataset_id = dv.dataset_id
ORDER BY d.dataset_key, COALESCE(dv.version_number, 0);

-- ============================================================================
-- SECTION I: GRANT PERMISSIONS (Append-Only Enforcement)
-- ============================================================================

-- Revoke UPDATE/DELETE on append-only tables to enforce immutability
-- Note: This assumes you have an 'app_user' role. Adjust as needed.
-- ALTER DEFAULT PRIVILEGES REVOKE UPDATE, DELETE ON TABLES FROM PUBLIC;
-- REVOKE UPDATE, DELETE ON dataset_data_points FROM PUBLIC;
-- REVOKE UPDATE, DELETE ON run_logs FROM PUBLIC;
-- REVOKE UPDATE, DELETE ON audit_log FROM PUBLIC;

-- ============================================================================
-- COMPLETION MESSAGE
-- ============================================================================

-- Uncomment this to verify all tables were created:
-- SELECT table_name FROM information_schema.tables 
-- WHERE table_schema = 'public' ORDER BY table_name;
