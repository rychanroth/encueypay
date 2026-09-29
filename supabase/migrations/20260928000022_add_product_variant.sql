-- Add a variant to an existing product from the edit form. SECURITY INVOKER:
-- product_variants_owner_all gates the insert; the explicit ownership check
-- keeps the error message actionable. Duplicate names on the same product
-- are rejected — unlike the create flow, an added variant colliding with an
-- existing one is almost certainly a mistake.
create or replace function public.add_product_variant(
  p_product_id uuid,
  p_name text,
  p_price_minor bigint
)
returns uuid
language plpgsql
as $$
declare
  v_user uuid := auth.uid();
  v_variant_id uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if not exists (
    select 1
    from public.products p
    join public.businesses b on b.id = p.business_id
    where p.id = p_product_id and b.owner_id = v_user
  ) then
    raise exception 'Product not found';
  end if;
  if p_price_minor is not null and p_price_minor < 0 then
    raise exception 'Invalid price';
  end if;
  if exists (
    select 1 from public.product_variants
    where product_id = p_product_id and name = trim(p_name)
  ) then
    raise exception 'Variant name already exists';
  end if;

  insert into public.product_variants (product_id, name, price_minor)
  values (p_product_id, trim(p_name), p_price_minor)
  returning id into v_variant_id;
  return v_variant_id;
end;
$$;
