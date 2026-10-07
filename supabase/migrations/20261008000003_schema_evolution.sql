-- Bridge M3/6 — schema evolution for the 2-role prototype (pivot map §3, §4.2).
--
-- Adds the catalog entities (brands, banners), the single order lifecycle
-- (orders.status), the QR payment surface, and every column the current
-- Dart DTOs select. RLS policies for the new tables follow in M4; SQL-side
-- first-use of the enum values added here happens in M6 (separate
-- transaction — pivot map §0).

-- --------------------------------------------------------------- new tables
CREATE TABLE "public"."brands" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" DEFAULT '' NOT NULL,
    "image_url" "text",
    "status" "public"."product_status" DEFAULT 'active' NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "brands_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "brands_name_key" UNIQUE ("name")
);

CREATE TABLE "public"."banners" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_by" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" DEFAULT '' NOT NULL,
    "image_path" "text" NOT NULL,
    "promotion_id" "uuid",
    "starts_at" timestamp with time zone,
    "ends_at" timestamp with time zone,
    "status" "public"."banner_status" DEFAULT 'pending' NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "banners_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "banners_created_by_fkey" FOREIGN KEY ("created_by")
      REFERENCES "public"."users"("id"),
    CONSTRAINT "banners_promotion_id_fkey" FOREIGN KEY ("promotion_id")
      REFERENCES "public"."promotions"("id") ON DELETE SET NULL
);

ALTER TABLE "public"."brands" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."banners" ENABLE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------- catalog
ALTER TABLE "public"."products"
  ADD COLUMN "brand_id" "uuid",
  ADD COLUMN "stock" integer DEFAULT 0 NOT NULL,
  ADD CONSTRAINT "products_stock_check" CHECK ("stock" >= 0),
  ADD CONSTRAINT "products_brand_id_fkey" FOREIGN KEY ("brand_id")
    REFERENCES "public"."brands"("id") ON DELETE SET NULL;

CREATE INDEX "products_brand_idx" ON "public"."products" USING btree ("brand_id");

ALTER TABLE "public"."categories" ADD COLUMN "image_url" "text";

-- -------------------------------------------------------------- promotions
ALTER TABLE "public"."promotions"
  ADD COLUMN "active" boolean DEFAULT true NOT NULL,
  ADD COLUMN "brand_id" "uuid",
  ADD CONSTRAINT "promotions_brand_id_fkey" FOREIGN KEY ("brand_id")
    REFERENCES "public"."brands"("id") ON DELETE SET NULL;

ALTER TYPE "public"."promotion_scope" ADD VALUE IF NOT EXISTS 'brand';

-- ------------------------------------------------------- single lifecycle
CREATE TYPE "public"."order_status" AS ENUM
  ('pending','confirmed','processing','packed','shipped',
   'out_for_delivery','delivered','cancelled','returned');

ALTER TABLE "public"."orders"
  ADD COLUMN "status" "public"."order_status" DEFAULT 'pending' NOT NULL,
  ADD COLUMN "note" "text" DEFAULT '' NOT NULL,
  ADD COLUMN "cancelled_at" timestamp with time zone,
  ADD COLUMN "cancellation_reason" "text" DEFAULT '' NOT NULL;

-- ---------------------------------------------------------------- payments
ALTER TYPE "public"."payment_method" ADD VALUE IF NOT EXISTS 'qr';

ALTER TABLE "public"."payments"
  ADD COLUMN "qr_payload" "text",
  ADD COLUMN "qr_md5" "text",
  ADD COLUMN "transaction_reference" "text";

-- ----------------------------------------------------------------- returns
ALTER TYPE "public"."return_status" ADD VALUE IF NOT EXISTS 'completed';

-- One return per order item, ever (pivot map §4.7).
ALTER TABLE "public"."return_items"
  ADD CONSTRAINT "return_items_order_item_id_key" UNIQUE ("order_item_id");

-- ------------------------------------------------------------- coupons
-- Coupon validity windows move from the promotion to the coupon itself.
ALTER TABLE "public"."coupons"
  ADD COLUMN "min_order_amount_minor" bigint DEFAULT 0 NOT NULL,
  ADD COLUMN "starts_at" timestamp with time zone,
  ADD COLUMN "ends_at" timestamp with time zone,
  ADD CONSTRAINT "coupons_min_order_amount_minor_check" CHECK ("min_order_amount_minor" >= 0);

UPDATE "public"."coupons"
   SET "ends_at" = "expires_at"
 WHERE "ends_at" IS NULL AND "expires_at" IS NOT NULL;

ALTER TABLE "public"."coupons" DROP COLUMN "expires_at";

-- --------------------------------------------------------------- addresses
ALTER TABLE "public"."addresses"
  ADD COLUMN "is_default" boolean DEFAULT false NOT NULL;

-- Backfill: the oldest address per user becomes the default.
UPDATE "public"."addresses" "a"
   SET "is_default" = true
 WHERE "a"."id" IN (
    SELECT DISTINCT ON ("user_id") "id"
      FROM "public"."addresses"
     ORDER BY "user_id", "created_at" ASC, "id" ASC
 );

CREATE UNIQUE INDEX "addresses_user_default_key"
  ON "public"."addresses" USING btree ("user_id")
  WHERE "is_default";

-- -------------------------------------------------------- platform settings
ALTER TABLE "public"."platform_settings"
  ADD COLUMN "qr_account_id" "text" DEFAULT '' NOT NULL;

-- The singleton row: the frozen baseline is schema-only, and both the
-- checkout fee read and the admin settings update target this row.
INSERT INTO "public"."platform_settings" ("id") VALUES (1)
ON CONFLICT ("id") DO NOTHING;

-- -------------------------------------------------------------- realtime
ALTER PUBLICATION "supabase_realtime" ADD TABLE "public"."payments";
