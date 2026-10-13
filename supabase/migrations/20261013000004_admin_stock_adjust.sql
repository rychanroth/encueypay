-- Admin inline stock adjustment (DESIGN.md §5.2.2): quick [- Stock +]
-- controls on the admin products list. Server-authoritative — the client
-- never writes stock directly; the products_stock_check constraint still
-- guards negatives.

CREATE OR REPLACE FUNCTION public.admin_adjust_product_stock(
    p_product_id uuid,
    p_new_stock integer
) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can manage products';
  end if;
  if p_new_stock < 0 then
    raise exception 'Stock cannot be negative';
  end if;

  update public.products
     set stock = p_new_stock,
         updated_at = now()
   where id = p_product_id;
  if not found then
    raise exception 'Product not found';
  end if;

  perform public.record_admin_audit(
    'adjust_product_stock', 'product', p_product_id,
    jsonb_build_object('stock', p_new_stock));
end;
$$;
