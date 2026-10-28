-- Product-variant flow (user decision 2026-10-28, hybrid pricing):
--
--   * Authored variant rows (the payload the product form sends) are
--     strict: name AND price are required; image_path is optional (the
--     client uploads picks to the product_images bucket first and passes
--     the storage path).
--   * The auto-'Default' variant keeps the null-price base-tracking
--     convention (§1.2) — it always charges the product's current base
--     price. On admin_update_product a null price_minor continues to mean
--     base-price tracking (the form reserves it for the Default row).
--   * product_variants.attributes is dead weight (every writer stored
--     '{}', nothing ever read it) — dropped. Client field removed in the
--     same change set.

-- ---------------------------------------------------------------- create
CREATE OR REPLACE FUNCTION public.admin_create_product(
    p_category_id uuid,
    p_name text,
    p_description text,
    p_base_price_minor bigint,
    p_brand_id uuid DEFAULT NULL,
    p_stock integer DEFAULT 0,
    p_variants jsonb DEFAULT '[]'
) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
declare
  v_product_id uuid;
  v_variant record;
  v_variant_count integer;
begin
  if not public.is_admin() then
    raise exception 'Only admins can create products';
  end if;

  insert into public.products
    (category_id, name, description, base_price_minor, brand_id, stock)
  values
    (p_category_id, p_name, p_description, p_base_price_minor, p_brand_id, p_stock)
  returning id into v_product_id;

  select count(*) into v_variant_count
  from jsonb_to_recordset(p_variants) as x(name text, price_minor bigint);
  if v_variant_count = 0 then
    -- Auto-'Default' variant (null price tracks the base price) — a
    -- variant-less product is un-buyable (map §10.3).
    insert into public.product_variants (product_id, name)
    values (v_product_id, 'Default');
  else
    -- Authored rows are strict (hybrid pricing): name and price are
    -- required, image_path is optional.
    for v_variant in
      select * from jsonb_to_recordset(p_variants)
        as x(name text, price_minor bigint, image_path text)
    loop
      if coalesce(trim(v_variant.name), '') = '' then
        raise exception 'Variant name is required';
      end if;
      if v_variant.price_minor is null then
        raise exception 'Variant price is required';
      end if;
      if v_variant.price_minor < 0 then
        raise exception 'Variant price cannot be negative';
      end if;
      insert into public.product_variants (product_id, name, price_minor, image_path)
      values (v_product_id, v_variant.name, v_variant.price_minor, v_variant.image_path);
    end loop;
  end if;

  perform public.record_admin_audit(
    'admin_create_product', 'product', v_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock));
  return v_product_id;
end;
$$;

-- ---------------------------------------------------------------- update
-- Full-list sync semantics unchanged (archive, never delete); rows now
-- carry image_path (overwritten from the payload — the form seeds it from
-- the existing variant, so an untouched row keeps its image).
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
    -- Validate up front so a bad row aborts before any write. A null
    -- price_minor is the documented base-price-tracking convention (the
    -- form reserves it for the Default row) — negative is still rejected.
    for v_variant in
      select * from jsonb_to_recordset(p_variants)
        as x(id uuid, name text, price_minor bigint, image_path text)
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
      select * from jsonb_to_recordset(p_variants)
        as x(id uuid, name text, price_minor bigint, image_path text)
    loop
      if v_variant.id is null then
        insert into public.product_variants (product_id, name, price_minor, image_path)
        values (p_product_id, v_variant.name, v_variant.price_minor, v_variant.image_path)
        returning id into v_variant.id;
      else
        update public.product_variants
           set name = v_variant.name,
               price_minor = v_variant.price_minor,
               image_path = v_variant.image_path
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

-- Dead weight: always '{}', never read by any RPC, view, or client path.
ALTER TABLE public.product_variants DROP COLUMN attributes;
