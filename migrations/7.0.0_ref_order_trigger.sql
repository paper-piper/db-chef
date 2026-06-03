-- ============================================================================
-- REF ORDER AUTO-NORMALIZATION
-- Keeps exp.experiment_data_ver_refs.ref_order as a dense 1-based sequence
-- per experiment (no duplicates, no gaps) on every INSERT.
--
-- Rules applied BEFORE each INSERT:
--   • NULL / too large  → append at the end (next available number)
--   • in-range value    → shift every existing row at that position or higher
--                         up by one, then claim the requested slot
--   • below 1           → clamped to 1, which pushes all existing rows
-- ============================================================================

CREATE OR REPLACE FUNCTION public.fn_ref_order_insert()
RETURNS TRIGGER
LANGUAGE plpgsql AS $$
DECLARE
  v_next_val INT;
BEGIN
  -- Highest occupied slot + 1, or 1 when the experiment has no refs yet
  SELECT COALESCE(MAX(ref_order), 0) + 1
    INTO v_next_val
    FROM exp.experiment_data_ver_refs
    WHERE experiment_id = NEW.experiment_id;

  IF NEW.ref_order IS NULL OR NEW.ref_order >= v_next_val THEN
    -- Append to end (also handles values beyond the current range)
    NEW.ref_order := v_next_val;

  ELSE
    -- Clamp to 1 so ref_order never dips below the sequence floor
    NEW.ref_order := GREATEST(NEW.ref_order, 1);

    -- Push every ref at the target slot and above up by one to make room
    UPDATE exp.experiment_data_ver_refs
      SET ref_order = ref_order + 1
      WHERE experiment_id = NEW.experiment_id
        AND ref_order >= NEW.ref_order;
  END IF;

  RETURN NEW;
END;
$$;

CREATE TRIGGER tg_ref_order_insert
  BEFORE INSERT ON exp.experiment_data_ver_refs
  FOR EACH ROW EXECUTE FUNCTION public.fn_ref_order_insert();
