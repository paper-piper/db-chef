-- ============================================================================
-- FULL DATABASE RESET
-- Explicitly drops every schema this project creates (organizations,
-- datasets, experiments, run), then nukes and recreates public — wipes
-- all tables, views, functions, types, sequences, and triggers in it.
-- ============================================================================

DROP SCHEMA IF EXISTS run CASCADE;
DROP SCHEMA IF EXISTS experiments CASCADE;
DROP SCHEMA IF EXISTS datasets CASCADE;
DROP SCHEMA IF EXISTS organizations CASCADE;

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
