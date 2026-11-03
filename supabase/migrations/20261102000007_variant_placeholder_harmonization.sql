-- Harmonize the variant model: the null-price "Default" row is a
-- single-price placeholder, not an admin-managed variant.
--
-- Every product still keeps at least one active variant so cart/order
-- references stay non-null. Single-price products keep exactly one active
-- null-price placeholder (base-price tracking); multi-variant products keep
-- only priced variants. `admin_update_product` treats an empty variant list
-- as "switch to single price" instead of trying to leave zero variants.

-- A product with no active variant is un-buyable. Backfill the placeholder
-- only there — never onto products that already have real variants.
insert into public.product_variants (product_id, name)
select p.id, 'Default'
from public.products p
where not exists (
  select 1
  from public.product_variants pv
  where pv.product_id = p.id
    and pv.status = 'active'
);

-- Keep only the oldest active placeholder before enforcing the invariant.
with ranked as (
  select id,
         row_number() over (
           partition by product_id
           order by created_at, id
         ) as rn
  from public.product_variants
  where status = 'active'
    and price_minor is null
)
update public.product_variants pv
   set status = 'archived'
  from ranked r
 where pv.id = r.id
   and r.rn > 1;

create unique index if not exists product_variants_one_placeholder_idx
  on public.product_variants (product_id)
  where status = 'active' and price_minor is null;

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
  v_placeholder_id uuid;
  v_effective_base bigint;
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
    if jsonb_array_length(p_variants) = 0 then
      -- Single-price mode: keep (or create) one base-tracking placeholder
      -- and archive every priced variant. Historical orders keep their
      -- variant references; carts referencing an archived variant are
      -- rejected at checkout, as with any variant archive.
      select id into v_placeholder_id
        from public.product_variants
       where product_id = p_product_id
         and status = 'active'
         and price_minor is null
       order by created_at, id
       limit 1;

      if v_placeholder_id is null then
        insert into public.product_variants (product_id, name)
        values (p_product_id, 'Default')
        returning id into v_placeholder_id;
      end if;

      update public.product_variants
         set status = 'archived'
       where product_id = p_product_id
         and status = 'active'
         and id <> v_placeholder_id;
    else
      -- Multi-variant mode: every payload row is a real, priced variant.
      -- The placeholder is not sent and gets archived by the full-list
      -- sync below, so it never appears as a customer-selectable option.
      for v_variant in
        select * from jsonb_to_recordset(p_variants)
          as x(id uuid, name text, price_minor bigint, image_path text)
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
      end loop;

      -- The base price is derived from the cheapest authored variant; the
      -- admin form hides the field in multi-variant mode.
      select min((v->>'price_minor')::bigint)
        into v_effective_base
        from jsonb_array_elements(p_variants) v;
      update public.products
         set base_price_minor = v_effective_base
       where id = p_product_id;

      -- Ids surviving this sync (updated in place OR freshly inserted) — the
      -- archive step cannot match payload ids alone: inserted rows have
      -- server-generated ids the payload cannot reference. Drop-guard: the
      -- RPC may run twice inside one transaction.
      drop table if exists _variant_keep;
      create temp table _variant_keep (id uuid primary key) on commit drop;

      for v_variant in
        select * from jsonb_to_recordset(p_variants)
          as x(id uuid, name text, price_minor bigint, image_path text)
      loop
        if v_variant.id is null then
          insert into public.product_variants
            (product_id, name, price_minor, image_path)
          values
            (p_product_id, v_variant.name, v_variant.price_minor,
             v_variant.image_path)
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
      -- orders and carts reference these rows). This also retires the
      -- single-price placeholder.
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
  end if;

  perform public.record_admin_audit(
    'admin_update_product', 'product', p_product_id,
    jsonb_build_object('name', p_name, 'stock', p_stock,
                       'variants_synced', p_variants is not null));
end;
$$;
