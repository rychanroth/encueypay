-- businesses-survivor repair (follows 20261013000008_single_seller_retirement).
-- The retirement migration dropped the businesses table but three functions
-- survived with live references to it; any invocation now fails with
-- "relation public.businesses does not exist":
--   add_cart_item            — joins businesses for the active-status guard
--                              (breaks every add-to-cart).
--   get_platform_report      — counts active_businesses (breaks the report).
--   owns_product_image_object — vendor-era storage ownership check; no
--                              policy references it anymore (dead code).
-- No trigger survives with a businesses reference (verified via pg_trigger).

-- ------------------------------------------------- add-to-cart availability
-- Same contract as the baseline RPC (spec §53): only active variants of
-- active products are addable — minus the retired business dimension.
CREATE OR REPLACE FUNCTION public.add_cart_item(p_variant_id uuid, p_quantity integer)
RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_user uuid := auth.uid();
  v_cart uuid;
begin
  if v_user is null then
    raise exception 'Not authenticated';
  end if;
  if p_quantity is null or p_quantity < 1 then
    raise exception 'Invalid quantity';
  end if;

  -- Server-authoritative: only active variants of active products are
  -- addable (spec §53; single-seller — no business dimension).
  if not exists (
    select 1
    from public.product_variants pv
    join public.products p on p.id = pv.product_id
    where pv.id = p_variant_id
      and pv.status = 'active'
      and p.status = 'active'
  ) then
    raise exception 'Product is unavailable';
  end if;

  select id into v_cart from public.carts where user_id = v_user;
  if v_cart is null then
    insert into public.carts (user_id) values (v_user) returning id into v_cart;
  end if;

  insert into public.cart_items (cart_id, product_variant_id, quantity)
  values (v_cart, p_variant_id, p_quantity)
  on conflict (cart_id, product_variant_id)
  do update set quantity = public.cart_items.quantity + excluded.quantity;
end;
$$;

-- ------------------------------------------------------------ platform report
-- Same report shape minus the dead active_businesses key (the table it
-- counted no longer exists).
CREATE OR REPLACE FUNCTION public.get_platform_report() RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can view reports';
  end if;

  return jsonb_build_object(
    'order_count', (select count(*) from public.orders),
    'gmv_minor', coalesce((
      select sum(o.total_minor) from public.orders o
       where o.status not in ('cancelled', 'returned')
    ), 0),
    'delivery_fees_minor', coalesce((
      select sum(o.delivery_fee_minor) from public.orders o
       where o.status not in ('cancelled', 'returned')
    ), 0),
    'active_products', (
      select count(*) from public.products where status = 'active'
    )
  );
end;
$$;

-- ----------------------------------------------------- dead vendor-era helper
DROP FUNCTION IF EXISTS public.owns_product_image_object(text);
