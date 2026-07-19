CREATE OR REPLACE FUNCTION public.generate_cluster_run_counts_view()
RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
    v_cols TEXT;
BEGIN
    -- Step 1: build the column list — one entry per cluster
    SELECT string_agg(
        FORMAT(
            'COUNT(*) FILTER (WHERE r.cluster_id = %L) AS %I',
            c.id, c.cluster_name
        ),
        E',\n    '
        ORDER BY c.cluster_name
    )
    INTO v_cols
    FROM run.compute_clusters c;

    -- Step 2: drop the old view
    EXECUTE 'DROP VIEW IF EXISTS public.v_cluster_run_counts';

    -- Step 3: create the new view, injecting the column list with %s
    IF v_cols IS NULL THEN
        EXECUTE 'CREATE VIEW public.v_cluster_run_counts AS
                 SELECT NULL::text AS experiment_name WHERE false';
    ELSE
        EXECUTE FORMAT(
            'CREATE VIEW public.v_cluster_run_counts AS
             SELECT e.experiment_name,
                    %s
             FROM experiments.experiments e
             LEFT JOIN run.runs r ON e.id = r.experiment_id
             GROUP BY e.experiment_name
             ORDER BY e.experiment_name',
            v_cols
        );
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.fn_refresh_cluster_run_counts()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
    PERFORM public.generate_cluster_run_counts_view();
    RETURN NULL;
END;
$$;

CREATE TRIGGER tg_refresh_cluster_run_counts
  AFTER INSERT OR UPDATE OR DELETE ON run.compute_clusters
  FOR EACH STATEMENT
  EXECUTE FUNCTION public.fn_refresh_cluster_run_counts();
  