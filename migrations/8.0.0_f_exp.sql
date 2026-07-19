CREATE OR REPLACE FUNCTION public.count_runs_by_status(p_status TEXT DEFAULT NULL)
RETURNS TABLE(status run.run_status, total BIGINT)
LANGUAGE plpgsql AS $$
DECLARE
v_sql TEXT;
BEGIN
IF p_status IS NOT NULL THEN
    v_sql := FORMAT(
        'SELECT status, COUNT(*) AS total FROM run.runs WHERE status = %L GROUP BY status',
        p_status
    );
ELSE
    v_sql := 'SELECT status, COUNT(*) AS total FROM run.runs GROUP BY status';
END IF;

v_sql := v_sql || ' ORDER BY status';  -- appended once here

RETURN QUERY EXECUTE v_sql;
$$;

CREATE OR REPLACE FUNCTION public.count_table_rows(p_schema TEXT, p_table TEXT)
RETURNS BIGINT
LANGUAGE plpgsql AS $$
DECLARE
v_sql TEXT;
BEGIN
v_sql := FORMAT('SELECT COUNT(*) FROM %I.%I', p_schema, p_table);
EXECUTE v_sql INTO row_count;
RETURN row_count;
END
$$;

CREATE OR REPLACE FUNCTION public.run_log_summary(p_run_id UUID, p_min_level TEXT DEFAULT 'DEBUG')
RETURNS TABLE(log_level run.log_level, total BIGINT, sample_message TEXT)
LANGUAGE plpgsql AS $$
DECLARE
v_sql TEXT;
v_schema TEXT;
v_table TEXT;
BEGIN
v_schema := 'run';
v_table := 'run_logs';
v_sql := FORMAT('
    SELECT
    log.log_level,
    COUNT(log.log_id),
    MIN(log.log_message) AS sample_message
    FROM %I.%I as log
    WHERE log.run_id = %L AND log_level >= %L::run.log_level
    GROUP BY log.log_level
    ORDER BY log.log_level
', v_schema, v_table, p_run_id, p_min_level);
RETURN QUERY EXECUTE v_sql;
END;
$$;