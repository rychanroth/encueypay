-- payway-create validates the order lifecycle before minting a QR — a
-- cancelled/returned/delivered order must not take money. Edge functions
-- reach PostgREST as service_role, and the baseline left service_role
-- without SELECT on orders (42501), so the embedded `orders(status)` read
-- failed and every payway-create call answered `lookup_failed`.
-- Same class as 20261021000001_grant_service_role_payments.sql and
-- 20261107000001_grant_service_role_device_tokens.sql.
GRANT SELECT ON TABLE "public"."orders" TO "service_role";
