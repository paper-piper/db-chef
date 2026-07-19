CREATE OR REPLACE VIEW public.v_run_display AS
SELECT
  FORMAT('[%s] %s → %s', re.status, re.experiment_name, re.cluster_name) AS run_label,
  FORMAT('%s', 're.execution_seconds') AS run_execution_seconds,
  FORMAT('%s@%s', re.dataset_key, re.dataset_version_number) AS run_dataset
FROM public.v_run_environment re;