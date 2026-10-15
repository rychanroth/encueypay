-- Admin variant management (Section 2b). admin_update_product gains an
-- optional p_variants payload with full-list sync semantics; the create RPC
-- (20261013000008) already authors variants at creation time.
--
--   p_variants IS NULL  → variants untouched (back-compat default).
--   p_variants provided → rows with an `id` update name/price in place
--                         (must belong to the product), id-less rows insert
--                         as active, and active variants missing from the
--                         list are archived — order_items and cart_items
--                         reference variants, so removal is archival, never
--                         deletion. A null price_minor keeps tracking the
--                         product's base price (§1.2).
--   Guard: at least one active variant must survive the sync — a
--   variant-less product is un-buyable (map §10.3).
CREATE OR REPLACE FUNCTION public.admin_update_product(
    p_product_id uuid,
    p_category_id uuid,
    p_name text,
    p_description text,
    p_base_price_minor bigint,
    p_brand_id uuid DEFAULT NULL,
    p_stock integer DEFAULT 0,
    p_variants jsonb DEFAULT NULL
) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_variant record;
  v_active_count integer;
begin
  if not public.is_admin() then
    raise exception 'Only admins can update products';
  end if;

  update public.products
     set category_id = p_category_id,
         name = p_name,
         description = p_description,
         base_price_minor = p_base_price_minor,
         brand_id = p_brand_id,
         stock = p_stock
   where id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  if p_variants is not null then
    -- Validate up front so a bad row aborts before any write.
    for v_variant in
      select * from jsonb_to_recordset(p_variants) as x(id uuid, name text, price_minor bigint)
    loop
      if coalesce(trim(v_variant.name), '') = '' then
        raise exception 'Variant name is required';
      end if;
      if v_variant.price_minor is not null and v_variant.price_minor < 0 then
        raise exception 'Variant price cannot be negative';
      end if;
    end loop;

    -- Ids surviving this sync (updated in place OR freshly inserted) — the
    -- archive step cannot match payload ids alone: inserted rows have
    -- server-generated ids the payload cannot reference. Drop-guard: the
    -- RPC may run twice inside one transaction.
    drop table if exists _variant_keep;
    create temp table _variant_keep (id uuid primary key) on commit drop;

    -- Apply the desired list: update in place, or insert id-less rows.
    for v_variant in
      select * from jsonb_to_recordset(p_variants) as x(id uuid, name text, price_minor bigint)
    loop
      if v_variant.id is null then
        insert into public.product_variants (product_id, name, price_minor, attributes)
        values (p_product_id, v_variant.name, v_variant.price_minor, '{}')
        returning id into v_variant.id;
      else
        update public.product_variants
           set name = v_variant.name,
               price_minor = v_variant.price_minor
         where id = v_variant.id
           and product_id = p_product_id;
        if not found then
          raise exception 'Variant does not belong to this product';
        end if;
      end if;
      insert into _variant_keep (id) values (v_variant.id);
    end loop;

    -- Archive active variants absent from the kept set (never delete:
    -- orders and carts reference these rows).
    update public.product_variants
       set status = 'archived'
     where product_id = p_product_id
       and status = 'active'
       and not exists (
         select 1 from _variant_keep k where k.id = product_variants.id
       );

    select count(*) into v_active_count
      from public.product_variants
     where product_id = p_product_id
       and status = 'active';
    if v_active_count = 0 then
      raise exception 'A product needs at least one active variant';
    end if;
  end if;

  perform public.record_admin_audit(
    'admin_update_product', 'product', p_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock,
                       'variants_synced', p_variants is not null));
end;
$$;
