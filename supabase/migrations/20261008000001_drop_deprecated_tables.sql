-- Bridge M1/6 — drop deprecated 4-role domains (pivot map §1, §4.1).
--
-- Removes the business/driver/role-application server domains:
--   tables   pickup_stops, deliveries, business_orders, role_applications
--   enums    pickup_stop_status, delivery_status, business_order_status,
--            role_application_status
-- and pivots order_items from business_order_id to a direct order_id FK
-- (the single-lifecycle prerequisite: order_items hang off orders directly).
--
-- Also re-attaches the auth.users signup trigger, which the frozen baseline
-- dump lost — without it new signups get no public.users row.
--
-- Note: RPC bodies that still reference the dropped tables (baseline
-- create_order_from_cart / cancel_order / request_return ...) are replaced
-- in M6; the schema is valid from here on, the app surface is complete
-- after M6. The user_role enum is intentionally untouched (4 values kept;
-- legacy rows fall back to the customer surface).

-- ---------------------------------------------------------------- signup fix
-- handle_new_user() exists in the baseline but has no trigger attached.
CREATE TRIGGER "on_auth_user_created"
  AFTER INSERT ON "auth"."users"
  FOR EACH ROW EXECUTE FUNCTION "public"."handle_new_user"();

-- ------------------------------------------------- old join-path policies
-- Policies on surviving tables that reach orders through business_orders /
-- deliveries reference columns/tables that go away in this file. Drop them
-- first (they hold pg_depend entries on the column/table), rewrite after
-- the FK move.

DROP POLICY IF EXISTS "order_items_customer_insert" ON "public"."order_items";
DROP POLICY IF EXISTS "order_items_participant_select" ON "public"."order_items";
DROP POLICY IF EXISTS "return_requests_read" ON "public"."return_requests";
DROP POLICY IF EXISTS "return_items_read" ON "public"."return_items";

-- Driver-era policies on surviving tables. The functions they reference are
-- dropped in M2; policies must go first.
DROP POLICY IF EXISTS "users_driver_read" ON "public"."users";
DROP POLICY IF EXISTS "orders_driver_select" ON "public"."orders";
DROP POLICY IF EXISTS "payments_driver_update" ON "public"."payments";

-- ------------------------------------------------------- order_items FK move
ALTER TABLE "public"."order_items" ADD COLUMN "order_id" "uuid";

-- Backfill from the per-business grouping before it disappears.
UPDATE "public"."order_items" "oi"
   SET "order_id" = "bo"."order_id"
  FROM "public"."business_orders" "bo"
 WHERE "bo"."id" = "oi"."business_order_id";

ALTER TABLE "public"."order_items"
  ALTER COLUMN "order_id" SET NOT NULL;

ALTER TABLE "public"."order_items"
  ADD CONSTRAINT "order_items_order_id_fkey"
  FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;

CREATE INDEX "order_items_order_idx" ON "public"."order_items" USING btree ("order_id");

ALTER TABLE "public"."order_items" DROP COLUMN "business_order_id";

-- --------------------------------------------- policy rewrites (new join path)

-- order_items: insert/select via the new order_id FK.
CREATE POLICY "order_items_customer_insert" ON "public"."order_items"
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1
        FROM "public"."orders" "o"
       WHERE "o"."id" = "order_items"."order_id"
         AND "o"."customer_id" = "auth"."uid"()
    )
  );

CREATE POLICY "order_items_participant_select" ON "public"."order_items"
  FOR SELECT USING (
    EXISTS (
      SELECT 1
        FROM "public"."orders" "o"
       WHERE "o"."id" = "order_items"."order_id"
         AND "o"."customer_id" = "auth"."uid"()
    )
  );

-- return_requests / return_items: customer-own term only; the
-- owns_returned_items() (business-owner) term is removed with the portal.
CREATE POLICY "return_requests_read" ON "public"."return_requests"
  FOR SELECT USING ("auth"."uid"() = "customer_id");

CREATE POLICY "return_items_read" ON "public"."return_items"
  FOR SELECT USING (
    EXISTS (
      SELECT 1
        FROM "public"."return_requests" "rr"
       WHERE "rr"."id" = "return_items"."return_request_id"
         AND "rr"."customer_id" = "auth"."uid"()
    )
  );

-- transition_business_order takes a business_order_status argument; drop it
-- before the enum or DROP TYPE fails on the signature dependency.
DROP FUNCTION IF EXISTS
  "public"."transition_business_order"("uuid", "public"."business_order_status", "text");

-- -------------------------------------------------------------- publications
ALTER PUBLICATION "supabase_realtime" DROP TABLE "public"."deliveries";
ALTER PUBLICATION "supabase_realtime" DROP TABLE "public"."business_orders";

-- --------------------------------------------------------------- table drops
-- Child-most first (pickup_stops → deliveries → business_orders).
DROP TABLE IF EXISTS "public"."pickup_stops" CASCADE;
DROP TABLE IF EXISTS "public"."deliveries" CASCADE;
DROP TABLE IF EXISTS "public"."business_orders" CASCADE;
DROP TABLE IF EXISTS "public"."role_applications" CASCADE;

-- ---------------------------------------------------------------- enum drops
DROP TYPE IF EXISTS "public"."pickup_stop_status";
DROP TYPE IF EXISTS "public"."delivery_status";
DROP TYPE IF EXISTS "public"."business_order_status";
DROP TYPE IF EXISTS "public"."role_application_status";
