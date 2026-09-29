-- Edit a variant's name/price from the business product form. SECURITY
-- INVOKER: product_variants_owner_all gates the update; the explicit
-- ownership check keeps the error actionable. Duplicate names are rejected
-- (excluding the variant being edited).
create or replace function public.update_product_variant(
  p_variant_id uuid,
  p_name text,
  p_price_minor bigint
)
returns void
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_product_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  select product_id into v_product_id
  from public.product_variants
  where id = p_variant_id;
  if v_product_id is null or not exists (
    select 1
    from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = v_product_id and b.owner_id = v_user
  ) then
    raise exception 'Variant not found';
  end if;
  if p_price_minor is not null and p_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if exists (
    select 1 from public.product_variants
    where product_id = v_product_id
      and id <> p_variant_id
      and name = trim(p_name)
  ) then
    raise exception 'Variant name already exists';
  end if;

  update public.product_variants
  set name = trim(p_name), price_minor = p_price_minor
  where id = p_variant_id;
end;
$$;
