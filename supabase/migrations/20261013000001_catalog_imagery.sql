-- Catalog imagery pipeline (DESIGN.md §2c/§5.1.2/§6.1): brands and
-- categories gain the storage-path convention already used by banners and
-- promotions (image_path in a public bucket, resolved to a public URL at
-- the repository boundary).

-- ------------------------------------------------------------- columns
ALTER TABLE "public"."brands"
  ADD COLUMN IF NOT EXISTS "image_path" "text";
ALTER TABLE "public"."categories"
  ADD COLUMN IF NOT EXISTS "image_path" "text";

-- image_url is deprecated: it was never populated by the seed or the admin
-- forms, and new reads/writes use image_path exclusively. Kept for
-- rollback safety.
COMMENT ON COLUMN "public"."brands"."image_url"
  IS 'DEPRECATED — use image_path (catalog_assets storage convention)';
COMMENT ON COLUMN "public"."categories"."image_url"
  IS 'DEPRECATED — use image_path (catalog_assets storage convention)';

-- -------------------------------------------------------------- storage
-- catalog_assets: brand/category imagery. Public read; admin-only writes
-- (same authority shape as promo_assets).
INSERT INTO "storage"."buckets" ("id", "name", "public")
VALUES ('catalog_assets', 'catalog_assets', true)
ON CONFLICT ("id") DO NOTHING;

CREATE POLICY "catalog_assets_bucket_public_read" ON "storage"."objects"
  FOR SELECT TO anon, authenticated
  USING ("bucket_id" = 'catalog_assets');

CREATE POLICY "catalog_assets_bucket_admin_insert" ON "storage"."objects"
  FOR INSERT TO authenticated
  WITH CHECK ("bucket_id" = 'catalog_assets' AND "public"."is_admin"());

CREATE POLICY "catalog_assets_bucket_admin_update" ON "storage"."objects"
  FOR UPDATE TO authenticated
  USING ("bucket_id" = 'catalog_assets' AND "public"."is_admin"())
  WITH CHECK ("bucket_id" = 'catalog_assets' AND "public"."is_admin"());

CREATE POLICY "catalog_assets_bucket_admin_delete" ON "storage"."objects"
  FOR DELETE TO authenticated
  USING ("bucket_id" = 'catalog_assets' AND "public"."is_admin"());

-- ----------------------------------------------------------------- rpcs
-- Category management RPCs move from image_url to image_path (the client
-- uploads into catalog_assets first, then hands over the path). Old
-- signatures are dropped so the named-arg binding stays unambiguous.
DROP FUNCTION IF EXISTS "public"."create_category"(text, uuid, text);
CREATE OR REPLACE FUNCTION "public"."create_category"(
    p_name text,
    p_parent_id uuid DEFAULT NULL,
    p_image_path text DEFAULT NULL
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_category_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create categories';
  end if;
  if p_parent_id is not null and not exists (
    select 1 from public.categories where id = p_parent_id
  ) then
    raise exception 'Parent category not found';
  end if;

  insert into public.categories (name, parent_id, image_path)
  values (p_name, p_parent_id, p_image_path)
  returning id into v_category_id;

  perform public.record_admin_audit(
    'create_category', 'category', v_category_id, jsonb_build_object('name', p_name));
  return v_category_id;
end;
$$;

DROP FUNCTION IF EXISTS "public"."rename_category"(uuid, text, text);
CREATE OR REPLACE FUNCTION "public"."rename_category"(
    p_category_id uuid,
    p_name text,
    p_image_path text DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can rename categories';
  end if;

  update public.categories
     set name = p_name,
         image_path = coalesce(p_image_path, image_path)
   where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;

  perform public.record_admin_audit(
    'rename_category', 'category', p_category_id, jsonb_build_object('name', p_name));
end;
$$;
