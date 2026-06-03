-- ============================================================================
-- SECTION G: AUDIT LOG (Tamper-Evident)
-- ============================================================================

CREATE TABLE public.audit_log (
  audit_id   BIGSERIAL    PRIMARY KEY,
  entity_type VARCHAR(100) NOT NULL,
  entity_id   UUID         NOT NULL,
  operation   VARCHAR(10)  NOT NULL,
  old_values  JSONB,
  new_values  JSONB,
  changed_by  UUID         REFERENCES public.users(user_id) ON DELETE SET NULL,
  changed_at  TIMESTAMPTZ    DEFAULT NOW(),

  CONSTRAINT entity_type_valid CHECK (entity_type IN ('dataset', 'dataset_version', 'experiment', 'run', 'permission')),
  CONSTRAINT operation_valid   CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
  CONSTRAINT new_values_required_for_insert CHECK (operation != 'INSERT' OR new_values IS NOT NULL),
  CONSTRAINT old_values_required_for_delete CHECK (operation != 'DELETE' OR old_values IS NOT NULL)
);

CREATE INDEX idx_audit_log_entity_type_id ON public.audit_log(entity_type, entity_id);
CREATE INDEX idx_audit_log_changed_by     ON public.audit_log(changed_by);
CREATE INDEX idx_audit_log_changed_at     ON public.audit_log(changed_at);
CREATE INDEX idx_audit_log_operation      ON public.audit_log(operation);
