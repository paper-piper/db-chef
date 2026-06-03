CREATE OR REPLACE VIEW public.v_dataset_versions_matrix AS
SELECT
  v.version_id,
  v.version_number,
  v.dataset_id,
  d.dataset_key,
  d.org_id,
  v.lineage_chain::text AS parent_chain
FROM public.v_dataset_lineage v
INNER JOIN ds.datasets d ON v.dataset_id = d.dataset_id
ORDER BY d.dataset_key, v.version_number;
