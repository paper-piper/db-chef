-- ============================================================================
-- LEGACY CLEANUP — tables that existed in public before schemas were introduced.
-- These drops are no-ops on a fresh database; they only matter when migrating
-- an old single-schema installation.  CASCADE handles FK ordering.
-- ============================================================================
DROP TABLE IF EXISTS public.run_output_artifacts  CASCADE;
DROP TABLE IF EXISTS public.run_logs              CASCADE;
DROP TABLE IF EXISTS public.runs                  CASCADE;
DROP TABLE IF EXISTS public.compute_clusters      CASCADE;
DROP TABLE IF EXISTS public.experiment_parameters CASCADE;
DROP TABLE IF EXISTS public.experiment_data_ver_refs CASCADE;
DROP TABLE IF EXISTS public.experiments           CASCADE;
DROP TABLE IF EXISTS public.dataset_data_points   CASCADE;
DROP TABLE IF EXISTS public.dataset_versions      CASCADE;
DROP TABLE IF EXISTS public.datasets              CASCADE;
DROP TABLE IF EXISTS public.user_role_assignments CASCADE;
DROP TABLE IF EXISTS public.roles                 CASCADE;
DROP TABLE IF EXISTS public.user_org_memberships  CASCADE;
DROP TABLE IF EXISTS public.organizations         CASCADE;

-- ============================================================================
-- CURRENT SCHEMA CLEANUP — drops all four non-public schemas and everything in them.
-- CASCADE drops all tables, views, indexes, and sequences within each schema.
-- ============================================================================
DROP SCHEMA IF EXISTS run  CASCADE;
DROP SCHEMA IF EXISTS exp  CASCADE;
DROP SCHEMA IF EXISTS ds   CASCADE;
DROP SCHEMA IF EXISTS orgs CASCADE;

-- public-schema tables dropped individually (public schema itself is never dropped)
DROP TABLE IF EXISTS public.audit_log CASCADE;
DROP TABLE IF EXISTS public.users     CASCADE;

-- Functions live in public
DROP FUNCTION IF EXISTS public.fn_append_only CASCADE;
DROP FUNCTION IF EXISTS public.fn_audit_log   CASCADE;
