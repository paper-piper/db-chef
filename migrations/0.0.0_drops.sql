-- ============================================================================
-- FULL DATABASE RESET
-- Dynamically discovers and drops everything in all non-system schemas,
-- then nukes and recreates the public schema. Nothing gets left behind
-- regardless of what was added or renamed since the last run.
-- ============================================================================

DO $$
DECLARE
  r RECORD;
BEGIN
  -- Drop every non-system schema (covers orgs, ds, exp, run, and any future ones)
  FOR r IN
    SELECT schema_name
    FROM information_schema.schemata
    WHERE schema_name NOT IN ('public', 'information_schema')
      AND schema_name NOT LIKE 'pg_%'
  LOOP
    EXECUTE 'DROP SCHEMA IF EXISTS ' || quote_ident(r.schema_name) || ' CASCADE';
  END LOOP;
END;
$$;

-- Drop and recreate public — wipes all tables, views, functions, types,
-- sequences, and triggers in one shot, no matter what names they have.
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
