CREATE OR REPLACE FUNCTION public.used_ds_ver(exp_id UUID)
RETURNS TABLE (dataset_version_number INT)
LANGUAGE sql AS $$
    WITH used_versions AS (
        SELECT
            runs.dataset_version_id
        FROM
            run.runs
        WHERE
            runs.experiment_id = exp_id
    )
    SELECT
        dv.version_number
    FROM
        experiments.experiment_data_ver_refs edvr
    JOIN
        datasets.dataset_versions dv ON edvr.dataset_version_id = dv.version_id
    WHERE
        dv.version_id IN(SELECT dataset_version_id FROM used_versions)
$$;