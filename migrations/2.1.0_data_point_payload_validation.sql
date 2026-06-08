-- ============================================================================
-- DATA POINT PAYLOAD VALIDATION
-- Ensures data_payload keys and types match the version's schema_definition
-- on every INSERT into datasets.dataset_data_points.
--
-- schema_definition format: { "field_name": "<jsonb_type>", ... }
-- Valid types: string, number, boolean, object, array, null
--
-- Rules enforced:
--   1. Every field declared in schema_definition must be present in data_payload.
--   2. Each field's JSON type must match the declared type.
--   3. data_payload must not contain fields absent from schema_definition.
-- ============================================================================

CREATE OR REPLACE FUNCTION datasets.validate_data_point_payload()
RETURNS TRIGGER AS $$
DECLARE
  v_schema   JSONB;
  v_field    TEXT;
  v_expected TEXT;
  v_actual   TEXT;
BEGIN
  SELECT schema_definition INTO v_schema
  FROM datasets.dataset_versions
  WHERE version_id = NEW.version_id;

  FOR v_field, v_expected IN SELECT key, value FROM jsonb_each_text(v_schema) LOOP
    IF NOT (NEW.data_payload ? v_field) THEN
      RAISE EXCEPTION 'data_payload missing required field "%"', v_field;
    END IF;

    v_actual := jsonb_typeof(NEW.data_payload -> v_field);
    IF v_actual <> v_expected THEN
      RAISE EXCEPTION 'field "%" expected type "%" but got "%"', v_field, v_expected, v_actual;
    END IF;
  END LOOP;

  FOR v_field IN SELECT key FROM jsonb_each(NEW.data_payload) LOOP
    IF NOT (v_schema ? v_field) THEN
      RAISE EXCEPTION 'data_payload contains undeclared field "%"', v_field;
    END IF;
  END LOOP;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validate_data_point_payload
  BEFORE INSERT ON datasets.dataset_data_points
  FOR EACH ROW EXECUTE FUNCTION datasets.validate_data_point_payload();
