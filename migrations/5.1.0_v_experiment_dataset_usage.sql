CREATE OR REPLACE VIEW public.v_experiment_dataset_usage AS
SELECT
  e.id AS experiment_id,
  e.experiment_name,
  o.org_name,
  d.dataset_key,
  dv.version_number,
  edr.ref_order
FROM experiments.experiments e
LEFT JOIN organizations.organizations o            ON e.org_id = o.id
LEFT JOIN experiments.experiment_data_ver_refs edr ON e.id = edr.experiment_id
LEFT JOIN datasets.dataset_versions dv           ON edr.dataset_version_id = dv.version_id
LEFT JOIN datasets.datasets d                    ON dv.dataset_id = d.id
ORDER BY e.id, edr.ref_order;
