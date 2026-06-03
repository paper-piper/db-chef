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
