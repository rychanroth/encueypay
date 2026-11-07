-- push-dispatch reads device tokens through PostgREST as service_role.
-- The frozen baseline granted service_role only REFERENCES/TRIGGER/TRUNCATE/
-- MAINTAIN on public tables (20261007000000_frozen_baseline.sql:3904), so the
-- dispatcher's SELECT failed with 42501 and was reported as "no devices".
-- rolbypassrls does not bypass table GRANTs — same class as
-- 20261021000001_grant_service_role_payments.sql.
GRANT SELECT ON TABLE "public"."device_tokens" TO "service_role";
