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
