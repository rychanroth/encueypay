-- Bridge M2/6 — drop deprecated 4-role routines, policies, and columns
-- (pivot map §1).
--
-- Removes every business-portal / driver-pipeline / role-application
-- function, the owner-era RLS policies they served, and the columns whose
-- concepts moved (banner-as-promotion-row → banners table in M3; driver
-- commission → none; coupon windows → coupons in M3).
--
-- Kept on purpose (not in the map §1 drop list): coupons_creator_write and
-- promotions_creator_all — creator-scoped, not owner/driver-scoped;
-- promotions_creator_all is what lets the INVOKER admin RPC insert
-- promotions (created_by = admin). Revisited by M6's rewrites.
--
-- RPCs whose *signature* changes (create_order_from_cart, cancel_order,
-- create_category, rename_category, create_platform_promotion,
-- moderate_banner) are dropped here and freshly created in M6 — CREATE OR
-- REPLACE would only add overloads.

-- ------------------------------------------------------------- triggers
-- businesses.status becomes admin-writable (M4 adds the admin policy);
-- the block trigger goes with the business portal.
DROP TRIGGER IF EXISTS "businesses_block_status_self_change" ON "public"."businesses";

-- ------------------------------------------------------------- functions
-- Deprecated outright (map §1 list, minus transition_business_order —
-- already dropped in M1 for its enum-typed argument).
-- NOTE: argument type names are deliberately UNQUOTED — quoted aliases
-- ("boolean", "bigint") do not resolve in DROP FUNCTION arg lists.
DROP FUNCTION IF EXISTS public.create_business(text, text, text);
DROP FUNCTION IF EXISTS public.update_my_business(text, text);
DROP FUNCTION IF EXISTS public.create_product(uuid, text, text, bigint, jsonb);
DROP FUNCTION IF EXISTS public.update_product(uuid, uuid, text, text, bigint);
DROP FUNCTION IF EXISTS public.set_product_archived(uuid, boolean);
DROP FUNCTION IF EXISTS public.add_product_variant(uuid, text, bigint);
DROP FUNCTION IF EXISTS public.update_product_variant(uuid, text, bigint);
DROP FUNCTION IF EXISTS public.set_variant_image(uuid, text);
DROP FUNCTION IF EXISTS public.add_product_image(uuid, text);
DROP FUNCTION IF EXISTS public.get_business_analytics();
DROP FUNCTION IF EXISTS public.get_business_transactions(date);
DROP FUNCTION IF EXISTS public.get_driver_transactions(date);
DROP FUNCTION IF EXISTS public.accept_delivery(uuid);
DROP FUNCTION IF EXISTS public.reject_delivery(uuid);
DROP FUNCTION IF EXISTS public.complete_pickup_stop(uuid);
DROP FUNCTION IF EXISTS public.start_delivery(uuid);
DROP FUNCTION IF EXISTS public.mark_delivered(uuid);
DROP FUNCTION IF EXISTS public.process_return(uuid, boolean);
DROP FUNCTION IF EXISTS public.submit_banner(text, text, text, timestamptz);
DROP FUNCTION IF EXISTS public.create_coupon_promotion(text, text, discount_type, bigint, text, timestamptz);
DROP FUNCTION IF EXISTS public.submit_role_application(text);
DROP FUNCTION IF EXISTS public.review_role_application(uuid, boolean, text);
DROP FUNCTION IF EXISTS public.is_driver();
DROP FUNCTION IF EXISTS public.driver_can_view_business_order(uuid);
DROP FUNCTION IF EXISTS public.driver_can_view_delivery(uuid);
DROP FUNCTION IF EXISTS public.driver_can_view_order(uuid);
DROP FUNCTION IF EXISTS public.driver_can_view_user(uuid);
DROP FUNCTION IF EXISTS public.owns_business_order_driver(uuid);
-- Business-owner helper; its last policy consumers were rewritten in M1.
DROP FUNCTION IF EXISTS public.owns_returned_items(uuid);
-- Trigger bodies whose tables/triggers died in M1.
DROP FUNCTION IF EXISTS public.record_business_order_state();
DROP FUNCTION IF EXISTS public.notify_business_new_order();
DROP FUNCTION IF EXISTS public.notify_customer_on_business_order();
DROP FUNCTION IF EXISTS public.notify_customer_on_delivery();
DROP FUNCTION IF EXISTS public.block_business_status_self_change();

-- Signature-changing RPCs: dropped here, recreated in M6.
DROP FUNCTION IF EXISTS public.create_order_from_cart(uuid, payment_method, text[]);
DROP FUNCTION IF EXISTS public.cancel_order(uuid);
DROP FUNCTION IF EXISTS public.create_category(text, uuid);
DROP FUNCTION IF EXISTS public.rename_category(uuid, text);
DROP FUNCTION IF EXISTS public.create_platform_promotion(text, text, discount_type, bigint, text, timestamptz);
DROP FUNCTION IF EXISTS public.moderate_banner(uuid, text);

-- -------------------------------------------------------------- policies
-- Owner-era write paths; authority moves to is_admin() in M4/M6.
DROP POLICY IF EXISTS "products_owner_all" ON "public"."products";
DROP POLICY IF EXISTS "product_variants_owner_all" ON "public"."product_variants";
DROP POLICY IF EXISTS "product_images_owner_all" ON "public"."product_images";
DROP POLICY IF EXISTS "businesses_owner_insert" ON "public"."businesses";
DROP POLICY IF EXISTS "businesses_owner_read" ON "public"."businesses";
DROP POLICY IF EXISTS "businesses_owner_update" ON "public"."businesses";

-- --------------------------------------------------------------- columns
ALTER TABLE "public"."platform_settings" DROP COLUMN "driver_commission_percent";

-- Banner-as-promotion-row is replaced by the banners table (M3); coupon
-- windows move from the promotion to the coupon itself (M3).
ALTER TABLE "public"."promotions" DROP COLUMN "banner_image_path";
ALTER TABLE "public"."promotions" DROP COLUMN "banner_status";
ALTER TABLE "public"."promotions" DROP COLUMN "starts_at";
ALTER TABLE "public"."promotions" DROP COLUMN "ends_at";

-- Restore the strict discount check: the banner exemption existed only for
-- banner rows, which no longer live in promotions (pivot map §10.1). The
-- old constraint was auto-dropped with the banner_status column above.
ALTER TABLE "public"."promotions" DROP CONSTRAINT IF EXISTS "promotions_discount_value_check";
ALTER TABLE "public"."promotions"
  ADD CONSTRAINT "promotions_discount_value_check" CHECK ("discount_value" > 0);
