-- Server-side cart line pricing.
--
-- Cart and checkout used to receive sale-adjusted prices from a
-- composition-root map built from a separate `active_sales` fetch. That
-- made line display depend on an async provider plus denormalized
-- brand/category ids cached in the cart state, while the order totals were
-- priced in SQL — so stale client state could show base prices beside a
-- correctly discounted total.
--
-- This view is the read model for cart/checkout lines: the same
-- `best_sale_price_minor()` that `preview_order_totals` and
-- `create_order_from_cart` use prices every row. security_invoker keeps the
-- caller's cart_items RLS in force.

CREATE VIEW public.cart_item_details WITH (security_invoker = true) AS
SELECT
  ci.id,
  ci.cart_id,
  ci.created_at,
  ci.updated_at,
  ci.quantity,
  pv.id AS variant_id,
  pv.name AS variant_name,
  p.id AS product_id,
  p.name AS product_name,
  p.stock,
  p.brand_id,
  p.category_id,
  coalesce(pv.price_minor, p.base_price_minor) AS unit_price_minor,
  public.best_sale_price_minor(
    p.id,
    coalesce(pv.price_minor, p.base_price_minor)
  ) AS sale_unit_price_minor,
  (
    SELECT pi.storage_path
      FROM public.product_images pi
     WHERE pi.product_id = p.id
     ORDER BY pi.sort_order
     LIMIT 1
  ) AS image_storage_path
FROM public.cart_items ci
JOIN public.product_variants pv ON pv.id = ci.product_variant_id
JOIN public.products p ON p.id = pv.product_id;

GRANT SELECT ON public.cart_item_details TO authenticated;

COMMENT ON VIEW public.cart_item_details IS
  'Cart/checkout line read model with server-authoritative sale pricing.';
