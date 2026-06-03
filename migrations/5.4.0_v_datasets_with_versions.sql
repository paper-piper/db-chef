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
