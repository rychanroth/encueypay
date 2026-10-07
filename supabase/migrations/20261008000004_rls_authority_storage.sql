-- Bridge M4/6 — RLS authority model + storage (pivot map §5, §8).
--
-- Authority: public.is_admin() is the only admin primitive. Admin read
-- policies on order-embedded children are mandatory — PostgREST embeds
-- return empty without them. Customer own-rows policies are retained from
-- the baseline. No owner/driver policies remain (dropped in M1/M2).
--
-- Public read follows the map: products visible regardless of status while
-- their business is active (archived products render as "Unavailable"
-- client-side; purchase-time validity is enforced server-side in M6),
-- brands while active, banners while approved. Promotions become
-- RPC-readable only, so their public policy is dropped.

-- ------------------------------------------------------------ admin: read
CREATE POLICY "orders_admin_read" ON "public"."orders"
  FOR SELECT USING ("public"."is_admin"());
CREATE POLICY "payments_admin_read" ON "public"."payments"
  FOR SELECT USING ("public"."is_admin"());
CREATE POLICY "order_items_admin_read" ON "public"."order_items"
  FOR SELECT USING ("public"."is_admin"());
CREATE POLICY "return_requests_admin_read" ON "public"."return_requests"
  FOR SELECT USING ("public"."is_admin"());
CREATE POLICY "return_items_admin_read" ON "public"."return_items"
  FOR SELECT USING ("public"."is_admin"());
CREATE POLICY "brands_admin_read" ON "public"."brands"
  FOR SELECT USING ("public"."is_admin"());

-- ---------------------------------------------------- admin: full control
CREATE POLICY "products_admin_all" ON "public"."products"
  USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());
CREATE POLICY "product_variants_admin_all" ON "public"."product_variants"
  USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());
CREATE POLICY "product_images_admin_all" ON "public"."product_images"
  USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());
CREATE POLICY "businesses_admin_all" ON "public"."businesses"
  USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());
CREATE POLICY "brands_admin_all" ON "public"."brands"
  USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());
CREATE POLICY "banners_admin_all" ON "public"."banners"
  USING ("public"."is_admin"()) WITH CHECK ("public"."is_admin"());

-- ------------------------------------------------------------ public read
-- Archived products stay visible (client renders "Unavailable") while the
-- store business is active.
DROP POLICY IF EXISTS "products_public_read_active" ON "public"."products";
CREATE POLICY "products_public_read" ON "public"."products"
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM "public"."businesses" "b"
       WHERE "b"."id" = "products"."business_id"
         AND "b"."status" = 'active'
    )
  );

-- Variants follow their product's business (any status): archived products
-- must still render name/price. Active-chain enforcement happens server-side
-- at checkout, not in the read model.
DROP POLICY IF EXISTS "product_variants_public_read_active" ON "public"."product_variants";
CREATE POLICY "product_variants_public_read" ON "public"."product_variants"
  FOR SELECT USING (
    EXISTS (
      SELECT 1
        FROM "public"."products" "p"
        JOIN "public"."businesses" "b" ON "b"."id" = "p"."business_id"
       WHERE "p"."id" = "product_variants"."product_id"
         AND "b"."status" = 'active'
    )
  );

CREATE POLICY "brands_public_read_active" ON "public"."brands"
  FOR SELECT USING ("status" = 'active');
CREATE POLICY "banners_public_read_approved" ON "public"."banners"
  FOR SELECT USING ("status" = 'approved');
CREATE POLICY "banners_creator_insert" ON "public"."banners"
  FOR INSERT WITH CHECK ("auth"."uid"() = "created_by");

-- Promotions are readable via RPCs only now; the admin read/update policies
-- from the baseline cover the admin list.
DROP POLICY IF EXISTS "promotions_public_read" ON "public"."promotions";

-- ---------------------------------------------------------- grants (new)
GRANT ALL ON TABLE "public"."brands" TO "anon";
GRANT ALL ON TABLE "public"."brands" TO "authenticated";
GRANT REFERENCES, TRIGGER, TRUNCATE, MAINTAIN ON TABLE "public"."brands" TO "service_role";
GRANT ALL ON TABLE "public"."banners" TO "anon";
GRANT ALL ON TABLE "public"."banners" TO "authenticated";
GRANT REFERENCES, TRIGGER, TRUNCATE, MAINTAIN ON TABLE "public"."banners" TO "service_role";

-- --------------------------------------------------------------- storage
-- Buckets: product_images + promo_assets public; payment_proofs private.
INSERT INTO "storage"."buckets" ("id", "name", "public")
VALUES ('product_images', 'product_images', true)
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "storage"."buckets" ("id", "name", "public")
VALUES ('promo_assets', 'promo_assets', true)
ON CONFLICT ("id") DO NOTHING;

INSERT INTO "storage"."buckets" ("id", "name", "public")
VALUES ('payment_proofs', 'payment_proofs', false)
ON CONFLICT ("id") DO NOTHING;

-- product_images: public read; admin writes under the {business_id}/...
-- path convention (the admin client derives the folder from the product's
-- business); admin delete.
CREATE POLICY "product_images_bucket_public_read" ON "storage"."objects"
  FOR SELECT TO anon, authenticated
  USING ("bucket_id" = 'product_images');

CREATE POLICY "product_images_bucket_admin_insert" ON "storage"."objects"
  FOR INSERT TO authenticated
  WITH CHECK (
    "bucket_id" = 'product_images'
    AND "public"."is_admin"()
    AND EXISTS (
      SELECT 1 FROM "public"."businesses" "b"
       WHERE "b"."id"::"text" = ("storage"."foldername"("name"))[1]
    )
  );

CREATE POLICY "product_images_bucket_admin_update" ON "storage"."objects"
  FOR UPDATE TO authenticated
  USING ("bucket_id" = 'product_images' AND "public"."is_admin"())
  WITH CHECK ("bucket_id" = 'product_images' AND "public"."is_admin"());

CREATE POLICY "product_images_bucket_admin_delete" ON "storage"."objects"
  FOR DELETE TO authenticated
  USING ("bucket_id" = 'product_images' AND "public"."is_admin"());

-- promo_assets: public read; admin upload (client uses {uid}/... folders).
CREATE POLICY "promo_assets_bucket_public_read" ON "storage"."objects"
  FOR SELECT TO anon, authenticated
  USING ("bucket_id" = 'promo_assets');

CREATE POLICY "promo_assets_bucket_admin_insert" ON "storage"."objects"
  FOR INSERT TO authenticated
  WITH CHECK ("bucket_id" = 'promo_assets' AND "public"."is_admin"());

CREATE POLICY "promo_assets_bucket_admin_delete" ON "storage"."objects"
  FOR DELETE TO authenticated
  USING ("bucket_id" = 'promo_assets' AND "public"."is_admin"());

-- payment_proofs: private; customer writes/reads own {uid}/... folder,
-- admin reviews.
CREATE POLICY "payment_proofs_bucket_insert_own" ON "storage"."objects"
  FOR INSERT TO authenticated
  WITH CHECK (
    "bucket_id" = 'payment_proofs'
    AND ("storage"."foldername"("name"))[1] = "auth"."uid"()::"text"
  );

CREATE POLICY "payment_proofs_bucket_select_own" ON "storage"."objects"
  FOR SELECT TO authenticated
  USING (
    "bucket_id" = 'payment_proofs'
    AND ("storage"."foldername"("name"))[1] = "auth"."uid"()::"text"
  );

CREATE POLICY "payment_proofs_bucket_select_admin" ON "storage"."objects"
  FOR SELECT TO authenticated
  USING ("bucket_id" = 'payment_proofs' AND "public"."is_admin"());
