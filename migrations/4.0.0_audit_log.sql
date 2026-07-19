-- ============================================================================
-- SECTION G: AUDIT LOG (Tamper-Evident)
-- ============================================================================

CREATE TYPE public.audit_entity_type AS ENUM ('dataset', 'dataset_version', 'experiment', 'run', 'permission');
CREATE TYPE public.audit_operation   AS ENUM ('INSERT', 'UPDATE', 'DELETE');

CREATE TABLE public.audit_log (
  id          BIGSERIAL                NOT NULL PRIMARY KEY,
  entity_type public.audit_entity_type NOT NULL,
  entity_id   UUID                     NOT NULL,
  operation   public.audit_operation   NOT NULL,
  old_values  JSONB,
  new_values  JSONB,
  changed_by  UUID                     REFERENCES public.users(id) ON DELETE SET NULL,
  changed_at  TIMESTAMPTZ              DEFAULT NOW(),

  CONSTRAINT new_values_required_for_insert CHECK (operation != 'INSERT' OR new_values IS NOT NULL),
  CONSTRAINT old_values_required_for_delete CHECK (operation != 'DELETE' OR old_values IS NOT NULL)
);

CREATE INDEX idx_audit_log_entity_type_id ON public.audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_log_changed_by     ON public.audit_log(changed_by);
CREATE INDEX idx_audit_log_changed_at     ON public.audit_log(changed_at);
CREATE INDEX idx_audit_log_operation      ON public.audit_log(operation);
