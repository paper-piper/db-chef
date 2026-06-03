-- Ancestry map: { version_id -> [all ancestor version_ids, oldest first] }
-- True dynamic columns are impossible in SQL views (schema is fixed at creation time).
-- Root versions map to null; others map to an ordered ancestor array (self excluded).
CREATE OR REPLACE VIEW v_version_ancestry_map AS
SELECT
  jsonb_object_agg(
    version_id::text,
    CASE
      WHEN array_length(lineage_chain, 1) <= 1 THEN NULL
      ELSE to_jsonb(lineage_chain[1 : array_length(lineage_chain, 1) - 1])
    END
  ) AS ancestry_map
FROM v_dataset_lineage;
