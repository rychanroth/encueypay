-- Drops stale RPC overloads left behind by CREATE OR REPLACE signature
-- changes: Postgres overloads instead of replacing when the argument list
-- changes, so earlier migrations left unreachable variants of these
-- functions. The app always calls with named arguments, which now resolve
-- to the current signatures — these drops just remove the ambiguity.

-- admin_create_product: the 0008 signature has no p_business_id.
DROP FUNCTION IF EXISTS "public"."admin_create_product"(
    uuid, uuid, text, text, bigint, uuid, integer, jsonb);

-- rename_category: the current signature carries p_parent_id (0009).
DROP FUNCTION IF EXISTS "public"."rename_category"(uuid, text);
DROP FUNCTION IF EXISTS "public"."rename_category"(uuid, text, text);

-- create_category: the current signature carries p_image_path (0001).
DROP FUNCTION IF EXISTS "public"."create_category"(text, uuid);
