-- ============================================================================
-- SECTION F: RUNS & EXECUTION
-- ============================================================================

CREATE TYPE run.run_status AS ENUM ('queued', 'running', 'succeeded', 'failed', 'cancelled');
CREATE TYPE run.log_level  AS ENUM ('DEBUG', 'INFO', 'WARN', 'ERROR');

CREATE TABLE run.runs (
  run_id             UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  experiment_id      UUID           NOT NULL REFERENCES experiments.experiments(experiment_id)   ON DELETE RESTRICT,
  cluster_id         UUID           NOT NULL REFERENCES run.compute_clusters(cluster_id) ON DELETE RESTRICT,
  dataset_version_id UUID           NOT NULL,
  status             run.run_status NOT NULL DEFAULT 'queued',
  created_at         TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
  started_at         TIMESTAMPTZ,
  ended_at           TIMESTAMPTZ,
  created_by         UUID           REFERENCES public.users(user_id) ON DELETE SET NULL,

  CONSTRAINT started_after_created CHECK (started_at IS NULL OR started_at >= created_at),
  CONSTRAINT ended_after_started   CHECK (ended_at IS NULL OR (started_at IS NOT NULL AND ended_at >= started_at))
);

CREATE INDEX idx_runs_experiment_id     ON run.runs(experiment_id);
CREATE INDEX idx_runs_cluster_id        ON run.runs(cluster_id);
CREATE INDEX idx_runs_status            ON run.runs(status);
CREATE INDEX idx_runs_experiment_status ON run.runs(experiment_id, status);
CREATE INDEX idx_runs_created_by        ON run.runs(created_by);

CREATE TABLE run.run_logs (
  log_id      UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id      UUID        NOT NULL REFERENCES run.runs(run_id) ON DELETE CASCADE,
  log_message TEXT        NOT NULL,
  log_level   run.log_level NOT NULL DEFAULT 'INFO',
  created_at  TIMESTAMPTZ   NOT NULL DEFAULT NOW(),

  CONSTRAINT log_message_not_empty CHECK (log_message != '')
);

CREATE INDEX idx_run_logs_run_id     ON run.run_logs(run_id);
CREATE INDEX idx_run_logs_created_at ON run.run_logs(created_at);
CREATE INDEX idx_run_logs_log_level  ON run.run_logs(log_level);

CREATE TABLE run.run_output_artifacts (
  artifact_id      UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  run_id           UUID         NOT NULL UNIQUE REFERENCES run.runs(run_id) ON DELETE CASCADE,
  artifact_type    VARCHAR(100) NOT NULL,
  artifact_payload JSONB        NOT NULL,
  created_at       TIMESTAMPTZ    NOT NULL DEFAULT NOW(),

  CONSTRAINT artifact_type_not_empty    CHECK (artifact_type != ''),
  CONSTRAINT artifact_payload_not_empty CHECK (artifact_payload != '{}'::jsonb)
);

CREATE INDEX idx_run_output_artifacts_run_id        ON run.run_output_artifacts(run_id);
CREATE INDEX idx_run_output_artifacts_artifact_type ON run.run_output_artifacts(artifact_type);
