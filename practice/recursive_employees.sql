-- ============================================================================
-- PRACTICE: Recursive CTEs — Employee Hierarchy
-- Standalone file, no dependencies on the main project schema.
-- Run this in a fresh session or wrap in a transaction to keep things clean.
-- ============================================================================

-- ─── Setup ───────────────────────────────────────────────────────────────────

DROP TABLE IF EXISTS public.employees CASCADE;

CREATE TABLE public.employees (
    employee_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT NOT NULL,
    manager_id  UUID REFERENCES public.employees(employee_id)
);


-- ─── Seed Data ────────────────────────────────────────────────────────────────

INSERT INTO public.employees (employee_id, name, manager_id) VALUES
  ('00000001-0000-0000-0000-000000000000', 'Alice (CEO)',  NULL),
  ('00000002-0000-0000-0000-000000000000', 'Bob',          '00000001-0000-0000-0000-000000000000'),
  ('00000003-0000-0000-0000-000000000000', 'Carol',        '00000001-0000-0000-0000-000000000000'),
  ('00000004-0000-0000-0000-000000000000', 'Dan',          '00000002-0000-0000-0000-000000000000'),
  ('00000005-0000-0000-0000-000000000000', 'Eve',          '00000002-0000-0000-0000-000000000000'),
  ('00000006-0000-0000-0000-000000000000', 'Frank',        '00000003-0000-0000-0000-000000000000');


-- ─── Your Query ───────────────────────────────────────────────────────────────

WITH RECURSIVE hierarchy AS (
    -- base case: start at the top (no manager)
    SELECT employee_id, name, manager_id, '' AS name_path
    FROM public.employees
    WHERE manager_id IS NULL

    UNION ALL

    -- recursive case
    SELECT e.employee_id, e.name, e.manager_id, name_path || e.name
    FROM public.employees e
    JOIN hierarchy ON hierarchy.employee_id = e.manager_id
)
SELECT * FROM hierarchy ORDER BY name_path, name;
