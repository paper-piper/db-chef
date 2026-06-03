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

CREATE TABLE experiment_data_ver_refs (
  experiment_id UUID NOT NULL REFERENCES experiments(experiment_id) ON DELETE CASCADE,
  dataset_version_id UUID NOT NULL REFERENCES dataset_versions(version_id) ON DELETE RESTRICT,
  ref_order INT NOT NULL,

  PRIMARY KEY (experiment_id, dataset_version_id),
  CONSTRAINT ref_order_positive CHECK (ref_order > 0)
);

CREATE INDEX idx_experiment_data_ver_refs_dataset_version_id ON experiment_data_ver_refs(dataset_version_id);

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
