-- ============================================================================
-- SECTION I: AUDIT TRIGGERS & APPEND-ONLY ENFORCEMENT
-- ============================================================================

-- ─── Append-Only Guard ────────────────────────────────────────────────────────
-- Blocks UPDATE and DELETE on tables that must be immutable after insert.
-- Covers: ds.dataset_data_points (§1.2) and run.run_logs (§1.4).

CREATE OR REPLACE FUNCTION public.fn_append_only()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION
    'Table % is append-only: % is not allowed',
    TG_TABLE_NAME, TG_OP;
END;
$$;

CREATE TRIGGER tg_dataset_data_points_append_only
  BEFORE UPDATE OR DELETE ON ds.dataset_data_points
  FOR EACH ROW EXECUTE FUNCTION public.fn_append_only();

CREATE TRIGGER tg_run_logs_append_only
  BEFORE UPDATE OR DELETE ON run.run_logs
  FOR EACH ROW EXECUTE FUNCTION public.fn_append_only();


-- ─── Generic Audit Logger ─────────────────────────────────────────────────────
-- Writes one row to public.audit_log for every INSERT / UPDATE / DELETE.
--
-- TG_ARGV[0] = entity_type  (must match audit_log CHECK constraint)
-- TG_ARGV[1] = pk_column    (name of the UUID PK column on the target table)
--
-- changed_by is resolved from the session variable app.current_user_id,
-- which the application layer must SET LOCAL before each statement.
-- If the variable is absent or not a valid UUID the column is left NULL.

CREATE OR REPLACE FUNCTION public.fn_audit_log()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
  v_entity_type VARCHAR(100) := TG_ARGV[0];
  v_pk_column   TEXT         := TG_ARGV[1];
  v_entity_id   UUID;
  v_old_values  JSONB;
  v_new_values  JSONB;
  v_changed_by  UUID;
BEGIN
  -- Resolve caller identity from session-level variable (best-effort)
  BEGIN
    v_changed_by := current_setting('app.current_user_id', true)::UUID;
  EXCEPTION WHEN OTHERS THEN
    v_changed_by := NULL;
  END;

  IF TG_OP = 'INSERT' THEN
    v_entity_id  := (to_jsonb(NEW) ->> v_pk_column)::UUID;
    v_new_values := to_jsonb(NEW);
    v_old_values := NULL;

  ELSIF TG_OP = 'UPDATE' THEN
    v_entity_id  := (to_jsonb(NEW) ->> v_pk_column)::UUID;
    v_old_values := to_jsonb(OLD);
    v_new_values := to_jsonb(NEW);

  ELSIF TG_OP = 'DELETE' THEN
    v_entity_id  := (to_jsonb(OLD) ->> v_pk_column)::UUID;
    v_old_values := to_jsonb(OLD);
    v_new_values := NULL;
  END IF;

  INSERT INTO public.audit_log
    (entity_type, entity_id, operation, old_values, new_values, changed_by)
  VALUES
    (v_entity_type, v_entity_id, TG_OP, v_old_values, v_new_values, v_changed_by);

  RETURN NULL; -- AFTER trigger; return value is ignored
END;
$$;


-- ─── Audit Triggers ───────────────────────────────────────────────────────────

-- ds.datasets
CREATE TRIGGER tg_audit_datasets
  AFTER INSERT OR UPDATE OR DELETE ON ds.datasets
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log('dataset', 'dataset_id');

-- ds.dataset_versions
CREATE TRIGGER tg_audit_dataset_versions
  AFTER INSERT OR UPDATE OR DELETE ON ds.dataset_versions
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log('dataset_version', 'version_id');

-- exp.experiments
CREATE TRIGGER tg_audit_experiments
  AFTER INSERT OR UPDATE OR DELETE ON exp.experiments
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log('experiment', 'experiment_id');

-- run.runs
CREATE TRIGGER tg_audit_runs
  AFTER INSERT OR UPDATE OR DELETE ON run.runs
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log('run', 'run_id');

-- orgs.user_role_assignments (permissions)
-- Composite PK (user_id, role_id, org_id) — user_id is used as entity_id
-- because it is the most meaningful query axis for permission audits.
CREATE TRIGGER tg_audit_permissions
  AFTER INSERT OR UPDATE OR DELETE ON orgs.user_role_assignments
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log('permission', 'user_id');
