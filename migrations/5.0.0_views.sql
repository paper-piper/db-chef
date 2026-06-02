-- ============================================================================
-- SECTION H: VIEWS FOR REPRODUCIBILITY & ANALYTICS
-- ============================================================================

-- Dataset lineage (parent chain for each version)
CREATE OR REPLACE VIEW v_dataset_lineage AS
WITH RECURSIVE lineage AS (
  SELECT
    version_id,
    dataset_id,
    version_number,
    parent_version_id,
    ARRAY[version_id] AS lineage_chain
  FROM dataset_versions
  WHERE parent_version_id IS NULL

  UNION ALL

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

-- Dataset versions used by experiment
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

-- Run execution environment (captures reproducibility data)
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

-- All dataset versions with parent chains
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

-- All dataset IDs with their versions
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
