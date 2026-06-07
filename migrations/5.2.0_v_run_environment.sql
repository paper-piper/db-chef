CREATE OR REPLACE VIEW public.v_run_environment AS
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
  EXTRACT(EPOCH FROM (r.ended_at - r.started_at)) AS execution_seconds,
  r.dataset_version_id,
  dv.version_number                                AS dataset_version_number,
  d.dataset_key
FROM run.runs r
INNER JOIN exp.experiments       e   ON r.experiment_id        = e.experiment_id
INNER JOIN run.compute_clusters  cc  ON r.cluster_id           = cc.cluster_id
INNER JOIN ds.dataset_versions   dv  ON r.dataset_version_id  = dv.version_id
INNER JOIN ds.datasets           d   ON dv.dataset_id         = d.dataset_id
ORDER BY r.created_at DESC;
