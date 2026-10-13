-- 2-Role prototype: the product form no longer asks for a store
-- (DESIGN.md §1.1 — "Catalog ownership is retained under the hood
-- (products.business_id pointing to a seeded prototype business), but the
-- customer experiences a unified store without vendor fragmentation").
--
-- admin_create_product makes p_business_id optional: when omitted it
-- resolves the singleton active prototype business, provisioning it owned
-- by the calling admin on first use. Explicit ids still validate as before,
-- so the multi-vendor data model stays intact for future re-enablement.

CREATE OR REPLACE FUNCTION public.admin_create_product(
    p_business_id uuid DEFAULT NULL,
    p_category_id uuid DEFAULT NULL,
    p_name text DEFAULT NULL,
    p_description text DEFAULT NULL,
    p_base_price_minor bigint DEFAULT 0,
    p_brand_id uuid DEFAULT NULL,
    p_stock integer DEFAULT 0,
    p_variants jsonb DEFAULT '[]'
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_product_id uuid;
  v_business_id uuid := p_business_id;
  v_variant record;
  v_variant_count integer;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create products';
  end if;

  if v_business_id is null then
    -- Resolve the singleton prototype business; provision it on first use
    -- (the seed cannot: businesses.owner_id references an auth user).
    select id into v_business_id
      from public.businesses
     where status = 'active'
     order by created_at
     limit 1;
    if v_business_id is null then
      insert into public.businesses (owner_id, name, description, status)
      values (
        auth.uid(),
        'EncueYPay Prototype Store',
        'Auto-provisioned prototype catalog owner (2-role simplification).',
        'active'
      )
      returning id into v_business_id;
    end if;
  elsif not exists (
    select 1 from public.businesses where id = v_business_id
  ) then
    raise exception 'Business not found';
  end if;

  insert into public.products
    (business_id, category_id, name, description, base_price_minor, brand_id, stock)
  values
    (v_business_id, p_category_id, p_name, p_description, p_base_price_minor, p_brand_id, p_stock)
  returning id into v_product_id;

  select count(*) into v_variant_count
  from jsonb_to_recordset(p_variants) as x(name text, price_minor bigint);
  if v_variant_count = 0 then
    -- Auto-'Default' variant (null price tracks the base price) — a
    -- variant-less product is un-buyable (map §10.3).
    insert into public.product_variants (product_id, name, attributes)
    values (v_product_id, 'Default', '{}');
  else
    for v_variant in
      select * from jsonb_to_recordset(p_variants) as x(name text, price_minor bigint)
    loop
      insert into public.product_variants (product_id, name, price_minor, attributes)
      values (v_product_id, v_variant.name, v_variant.price_minor, '{}');
    end loop;
  end if;

  perform public.record_admin_audit(
    'admin_create_product', 'product', v_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock));
  return v_product_id;
end;
$$;
