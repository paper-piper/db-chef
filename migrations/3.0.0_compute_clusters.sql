-- ============================================================================
-- SECTION E: COMPUTE CLUSTERS
-- ============================================================================

CREATE TABLE run.compute_clusters (
  cluster_id              UUID           PRIMARY KEY DEFAULT gen_random_uuid(),
  cluster_name            VARCHAR(255)   NOT NULL UNIQUE,
  region                  VARCHAR(100)   NOT NULL,
  ip_address              INET           NOT NULL,
  cpu_cores               INT            NOT NULL,
  ram_gb                  INT            NOT NULL,
  disk_tb                 DECIMAL(10, 2) NOT NULL,
  network_bandwidth_mbps  INT            NOT NULL,
  created_at              TIMESTAMPTZ      DEFAULT NOW(),
  is_active               BOOLEAN        DEFAULT TRUE,

  CONSTRAINT cluster_name_not_empty    CHECK (cluster_name != ''),
  CONSTRAINT cpu_cores_positive        CHECK (cpu_cores > 0),
  CONSTRAINT ram_gb_positive           CHECK (ram_gb > 0),
  CONSTRAINT disk_tb_positive          CHECK (disk_tb > 0),
  CONSTRAINT network_bandwidth_positive CHECK (network_bandwidth_mbps > 0)
);

CREATE INDEX idx_compute_clusters_region    ON run.compute_clusters(region);
CREATE INDEX idx_compute_clusters_is_active ON run.compute_clusters(is_active);
