-- 2-Role Academic Prototype, Section 8D (living spec Part B §8): audit
-- completeness. The category, coupon, and banner-moderation RPCs wrote no
-- audit rows — administrative actions were only partially tracked. All
-- admin mutations now land in audit_logs (the existing system is reused,
-- not replaced).

create or replace function public.create_category(
  p_name text,
  p_parent_id uuid default null,
  p_image_url text default null
)
returns uuid
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'Category name is required';
  end if;
  insert into public.categories (name, parent_id, image_url)
  values (trim(p_name), p_parent_id, p_image_url)
  returning id into v_id;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_category_created', 'category', v_id,
          jsonb_build_object('name', trim(p_name)));

  return v_id;
end;
$$;

create or replace function public.rename_category(
  p_category_id uuid,
  p_name text,
  p_image_url text default null
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  update public.categories
  set name = trim(p_name),
      image_url = p_image_url
  where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_category_updated', 'category', p_category_id,
          jsonb_build_object('name', trim(p_name)));
end;
$$;

create or replace function public.delete_category(p_category_id uuid)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage categories';
  end if;
  delete from public.categories where id = p_category_id;
  if not found then
    raise exception 'Category not found';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_category_deleted', 'category', p_category_id, null);
end;
$$;

create or replace function public.create_platform_promotion(
  p_name text,
  p_description text,
  p_discount_type public.discount_type,
  p_discount_value bigint,
  p_code text,
  p_min_order_amount_minor bigint default 0,
  p_starts_at timestamptz default null,
  p_ends_at timestamptz default null,
  p_brand_id uuid default null
)
returns uuid
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_promotion_id uuid;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create promotions';
  end if;
  if p_discount_type = 'percent' and (p_discount_value < 1 or p_discount_value > 100) then
    raise exception 'Percent discount must be 1..100';
  end if;
  if coalesce(trim(p_code), '') = '' then
    raise exception 'Coupon code is required';
  end if;
  if p_min_order_amount_minor < 0 then
    raise exception 'Invalid minimum order amount';
  end if;
  if p_brand_id is not null and not exists (
    select 1 from public.brands br where br.id = p_brand_id
  ) then
    raise exception 'Brand not found';
  end if;

  insert into public.promotions (
    created_by, scope, brand_id, name, description, discount_type, discount_value
  ) values (
    v_actor,
    case when p_brand_id is null then 'platform'::public.promotion_scope
         else 'brand'::public.promotion_scope end,
    p_brand_id,
    trim(p_name), coalesce(p_description, ''),
    p_discount_type, p_discount_value
  ) returning id into v_promotion_id;

  insert into public.coupons
    (promotion_id, code, active, min_order_amount_minor, starts_at, ends_at)
  values (
    v_promotion_id, upper(trim(p_code)), true,
    p_min_order_amount_minor, p_starts_at, p_ends_at
  );

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_coupon_created', 'promotion', v_promotion_id,
          jsonb_build_object('code', upper(trim(p_code)),
            'scope', case when p_brand_id is null then 'platform' else 'brand' end));

  return v_promotion_id;
end;
$$;

create or replace function public.moderate_banner(
  p_banner_id uuid,
  p_action text
)
returns void
language plpgsql
as $$
declare
  v_actor uuid := auth.uid();
  v_new_status public.banner_status;
begin
  if not public.is_admin() then
    raise exception 'Only admins can moderate banners';
  end if;

  v_new_status := case p_action
    when 'approve' then 'approved'::public.banner_status
    when 'reject' then 'rejected'::public.banner_status
    when 'disable' then 'disabled'::public.banner_status
    else null::public.banner_status
  end;
  if v_new_status is null then
    raise exception 'Unknown action';
  end if;

  update public.banners
  set status = v_new_status,
      updated_at = now()
  where id = p_banner_id;
  if not found then
    raise exception 'Banner not found';
  end if;

  insert into public.audit_logs (actor, action, target_type, target_id, metadata)
  values (v_actor, 'admin_banner_' || p_action, 'banner', p_banner_id, null);
end;
$$;
