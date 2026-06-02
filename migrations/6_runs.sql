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
