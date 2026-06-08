CREATE OR REPLACE VIEW public.v_experiment_dataset_usage AS
SELECT
  e.experiment_id,
  e.experiment_name,
  o.org_name,
  d.dataset_key,
  dv.version_number,
  edr.ref_order
FROM experiments.experiments e
LEFT JOIN organisations.organizations o             ON e.org_id = o.org_id
LEFT JOIN experiments.experiment_data_ver_refs edr ON e.experiment_id = edr.experiment_id
LEFT JOIN datasets.dataset_versions dv           ON edr.dataset_version_id = dv.version_id
LEFT JOIN datasets.datasets d                    ON dv.dataset_id = d.dataset_id
ORDER BY e.experiment_id, edr.ref_order;
