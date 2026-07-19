CREATE OR REPLACE VIEW public.v_version_depth_from_leaf AS
WITH RECURSIVE lineage AS (
  SELECT
    dv.version_id AS leaf_id,
    dv.version_id,
    ds.dataset_key,
    dv.version_number,
    ARRAY[dv.version_id] AS path_arr
  FROM datasets.dataset_versions dv
  JOIN datasets.datasets ds ON dv.dataset_id = ds.id
  WHERE dv.version_id NOT IN(
    SELECT dv.parent_version_id
    FROM datasets.dataset_versions 
    WHERE parent_version_id IS NOT NULL  
  )
  UNION ALL

  SELECT
    l.root_id,
    dv.version_id,
    ds.dataset_key,
    dv.version_number,
    l.path_arr || dv.version_id::text
  FROM datasets.dataset_versions dv
  JOIN lineage l ON dv.version_id = l.parent_version_id
  JOIN datasets.datasets ds ON dv.dataset_id = ds.id

)
SELECT
  leaf_id,
  MAX(lineage.path_arr) AS ancestor_id,
    COUNT(*) - 1 AS steps_up,
  lineage.dataset_key
FROM lineage
ORDER BY leaf_id, dataset_key;
GROUP BY leaf_id