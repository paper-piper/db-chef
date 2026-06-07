-- ============================================================================
-- RUN DATASET REFS
-- Snapshots the dataset versions a run actually consumed at execution time.
-- Kept separate from exp.experiment_data_ver_refs because experiment refs can
-- change after the run — this table is the immutable record of what was used.
-- ============================================================================

CREATE TABLE run.run_dataset_refs (
  run_id             UUID NOT NULL REFERENCES run.runs(run_id)                ON DELETE CASCADE,
  dataset_version_id UUID NOT NULL REFERENCES ds.dataset_versions(version_id) ON DELETE RESTRICT,
  ref_order          INT  NOT NULL,

  PRIMARY KEY (run_id, dataset_version_id),
  CONSTRAINT ref_order_positive CHECK (ref_order > 0)
);

CREATE INDEX idx_run_dataset_refs_dataset_version_id ON run.run_dataset_refs(dataset_version_id);
