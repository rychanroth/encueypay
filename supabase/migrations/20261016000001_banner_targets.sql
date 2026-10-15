-- Banner call-to-action targets (Section 9): a banner becomes a tappable
-- ad that deep-links into the Discovery feed pre-filtered to a brand or a
-- category. Discovery's deep-link contract already accepts
-- kind/id/name/image — this migration adds the destination fields.
--
--   target_kind 'none' (default)  → inert banner (today's behavior)
--   target_kind 'brand'           → target_id must be an existing brand
--   target_kind 'category'        → target_id must be an existing category
--   target_name                   → display-name snapshot for the Discovery
--                                   context banner (brands/categories may
--                                   change or be archived later)
ALTER TABLE "public"."banners"
  ADD COLUMN "target_kind" "text" DEFAULT 'none' NOT NULL,
  ADD COLUMN "target_id" "uuid",
  ADD COLUMN "target_name" "text";

ALTER TABLE "public"."banners"
  ADD CONSTRAINT "banners_target_kind_check"
  CHECK ("target_kind" IN ('none', 'brand', 'category'));

-- The new signature is a NEW function (different arg list), not a
-- replacement — drop the stale 4-arg overload so default-arg calls resolve
-- unambiguously (same cleanup as 20261013000010). Existing 4-arg call
-- sites keep working through the new function's defaults.
DROP FUNCTION IF EXISTS public.admin_create_banner(text, text, text, timestamptz);

CREATE OR REPLACE FUNCTION public.admin_create_banner(
    p_name text,
    p_description text,
    p_image_url text,
    p_ends_at timestamptz DEFAULT NULL,
    p_target_kind text DEFAULT 'none',
    p_target_id uuid DEFAULT NULL,
    p_target_name text DEFAULT NULL
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_banner_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create banners';
  end if;
  if p_target_kind not in ('none', 'brand', 'category') then
    raise exception 'Unknown banner target kind';
  end if;

  -- Fail-closed validation: a targeted banner must point at a real row of
  -- the declared kind — a dead CTA is worse than no CTA.
  if p_target_kind = 'brand' then
    if p_target_id is null or not exists (
      select 1 from public.brands where id = p_target_id
    ) then
      raise exception 'Banner brand target does not exist';
    end if;
  elsif p_target_kind = 'category' then
    if p_target_id is null or not exists (
      select 1 from public.categories where id = p_target_id
    ) then
      raise exception 'Banner category target does not exist';
    end if;
  else
    -- 'none': destination fields must be cleared together.
    if p_target_id is not null then
      raise exception 'Banner target id requires a target kind';
    end if;
  end if;

  insert into public.banners
    (created_by, name, description, image_path, ends_at, status,
     target_kind, target_id, target_name)
  values
    (auth.uid(), p_name, p_description, p_image_url, p_ends_at, 'pending',
     p_target_kind, p_target_id, p_target_name)
  returning id into v_banner_id;

  perform public.record_admin_audit(
    'admin_create_banner', 'banner', v_banner_id,
    jsonb_build_object('name', p_name, 'target_kind', p_target_kind));
  return v_banner_id;
end;
$$;
