-- ============================================================================
-- SECTION C: DATASETS & VERSIONING
-- ============================================================================

CREATE TABLE ds.datasets (
  dataset_id  UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id      UUID         NOT NULL REFERENCES orgs.organizations(org_id) ON DELETE CASCADE,
  dataset_key VARCHAR(255) NOT NULL,
  created_at  TIMESTAMP    DEFAULT NOW(),
  created_by  UUID         REFERENCES public.users(user_id) ON DELETE SET NULL,

  UNIQUE (org_id, dataset_key),
  CONSTRAINT dataset_key_not_empty CHECK (dataset_key != '')
);

CREATE INDEX idx_datasets_org_id     ON ds.datasets(org_id);
CREATE INDEX idx_datasets_created_by ON ds.datasets(created_by);

CREATE TABLE ds.dataset_versions (
  version_id        UUID    PRIMARY KEY DEFAULT gen_random_uuid(),
  dataset_id        UUID    NOT NULL REFERENCES ds.datasets(dataset_id)             ON DELETE CASCADE,
  version_number    INT     NOT NULL,
  description       TEXT,
  schema_definition JSONB   NOT NULL,
  parent_version_id UUID    REFERENCES ds.dataset_versions(version_id)              ON DELETE SET NULL,
  created_at        TIMESTAMP DEFAULT NOW(),
  created_by        UUID    REFERENCES public.users(user_id)                        ON DELETE SET NULL,

  UNIQUE (dataset_id, version_number),
  CONSTRAINT version_number_positive CHECK (version_number > 0),
  CONSTRAINT schema_not_empty        CHECK (schema_definition != '{}'::jsonb)
);

CREATE INDEX idx_dataset_versions_dataset_id        ON ds.dataset_versions(dataset_id);
CREATE INDEX idx_dataset_versions_parent_version_id ON ds.dataset_versions(parent_version_id);
CREATE INDEX idx_dataset_versions_created_by        ON ds.dataset_versions(created_by);

CREATE TABLE ds.dataset_data_points (
  data_point_id UUID  PRIMARY KEY DEFAULT gen_random_uuid(),
  version_id    UUID  NOT NULL REFERENCES ds.dataset_versions(version_id) ON DELETE RESTRICT,
  data_payload  JSONB NOT NULL,
  created_at    TIMESTAMP DEFAULT NOW(),
  created_by    UUID  REFERENCES public.users(user_id) ON DELETE SET NULL,

  CONSTRAINT data_payload_not_empty CHECK (data_payload != '{}'::jsonb)
);

CREATE INDEX idx_dataset_data_points_version_id  ON ds.dataset_data_points(version_id);
CREATE INDEX idx_dataset_data_points_created_at  ON ds.dataset_data_points(created_at);
CREATE INDEX idx_dataset_data_points_created_by  ON ds.dataset_data_points(created_by);
