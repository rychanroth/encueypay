-- Customer order search (user feedback 2026-11-10): the history list had
-- status groups + a custom date range, but no way to find an order by its id
-- or by what was bought. Server-side because the list is paginated.
--
-- Returns the same JSON shape as the PostgREST select in the orders
-- repository (order_items with reviews + product image paths, one payment),
-- so OrderDto/OrderDtoX keep working unchanged. Always scoped to auth.uid().

CREATE OR REPLACE FUNCTION public.customer_search_orders(
    p_search text DEFAULT NULL,
    p_statuses text[] DEFAULT NULL,
    p_from date DEFAULT NULL,
    p_to date DEFAULT NULL,
    p_to_review boolean DEFAULT false,
    p_limit integer DEFAULT 10,
    p_offset integer DEFAULT 0
) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
declare
  v_uid uuid := auth.uid();
  v_search text := nullif(trim(coalesce(p_search, '')), '');
  v_from timestamptz := p_from::timestamptz;
  v_to timestamptz := (p_to + 1)::timestamptz;
  v_limit integer := least(greatest(coalesce(p_limit, 10), 1), 100);
  v_offset integer := greatest(coalesce(p_offset, 0), 0);
begin
  if v_uid is null then
    raise exception 'Not authenticated';
  end if;

  return coalesce((
    select jsonb_agg(
      jsonb_build_object(
        'id', o.id,
        'created_at', o.created_at,
        'status', o.status,
        'subtotal_minor', o.subtotal_minor,
        'discount_minor', o.discount_minor,
        'delivery_fee_minor', o.delivery_fee_minor,
        'total_minor', o.total_minor,
        'note', o.note,
        'cancellation_reason', o.cancellation_reason,
        'shipping_recipient_name', o.shipping_recipient_name,
        'shipping_phone', o.shipping_phone,
        'shipping_line1', o.shipping_line1,
        'shipping_line2', o.shipping_line2,
        'shipping_city', o.shipping_city,
        'order_items', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'id', oi.id,
              'product_id', oi.product_id,
              'product_name', oi.product_name,
              'variant_name', oi.variant_name,
              'unit_price_minor', oi.unit_price_minor,
              'discount_minor', oi.discount_minor,
              'quantity', oi.quantity,
              'line_total_minor', oi.line_total_minor,
              'reviews', (
                select jsonb_build_object('id', r.id)
                from public.reviews r
                where r.order_item_id = oi.id
                limit 1
              ),
              'products', jsonb_build_object(
                'product_images', coalesce((
                  select jsonb_agg(
                    jsonb_build_object(
                      'storage_path', pi.storage_path,
                      'sort_order', pi.sort_order
                    )
                    order by pi.sort_order
                  )
                  from public.product_images pi
                  where pi.product_id = oi.product_id
                ), '[]'::jsonb)
              )
            )
            order by oi.created_at, oi.id
          )
          from public.order_items oi
          where oi.order_id = o.id
        ), '[]'::jsonb),
        'payments', (
          select jsonb_build_object(
            'method', p.method,
            'status', p.status,
            'amount_minor', p.amount_minor
          )
          from public.payments p
          where p.order_id = o.id
          limit 1
        )
      )
      order by o.created_at desc, o.id desc
    )
    from (
      select o.*
      from public.orders o
      where o.customer_id = v_uid
        and (v_from is null or o.created_at >= v_from)
        and (v_to is null or o.created_at < v_to)
        and (coalesce(array_length(p_statuses, 1), 0) = 0
             or o.status::text = any(p_statuses))
        and (not p_to_review or (
          o.status = 'delivered'
          and exists (
            select 1
            from public.order_items oi
            where oi.order_id = o.id
              and not exists (
                select 1 from public.reviews r
                where r.order_item_id = oi.id
              )
          )
        ))
        and (v_search is null
             or o.id::text ilike '%' || v_search || '%'
             or exists (
                  select 1
                  from public.order_items oi
                  where oi.order_id = o.id
                    and (oi.product_name ilike '%' || v_search || '%'
                         or coalesce(oi.variant_name, '')
                            ilike '%' || v_search || '%')))
      order by o.created_at desc, o.id desc
      limit v_limit offset v_offset
    ) o
  ), '[]'::jsonb);
end;
$$;
