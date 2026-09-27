-- Restore Data API DML privileges for the public schema.
--
-- The current Supabase CLI default no longer auto-exposes tables created by
-- migrations (the legacy `auto_expose_new_tables` behaviour, deprecated and
-- removed on 2026-10-30): new tables only receive REFERENCES, TRIGGER and
-- TRUNCATE for `anon`/`authenticated`, so every Data API read/write fails
-- with 403 "permission denied for table …" regardless of RLS policies.
--
-- Our migrations assume the legacy model — table-level grants are open and
-- RLS policies are the row-level gate. This migration reinstates it: full
-- DML on existing and future public tables/sequences for both API roles.
-- Row access stays governed exclusively by the RLS policies defined in the
-- earlier migrations.

grant usage on schema public to anon, authenticated;

grant select, insert, update, delete on all tables in schema public
  to anon, authenticated;
grant usage, select, update on all sequences in schema public
  to anon, authenticated;

-- Future objects created by subsequent migrations (run as `postgres`).
alter default privileges for role postgres in schema public
  grant select, insert, update, delete on tables to anon, authenticated;
alter default privileges for role postgres in schema public
  grant usage, select, update on sequences to anon, authenticated;
