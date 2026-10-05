-- 2-Role Academic Prototype, Section 2d (living spec Part B §3/§5/§8):
-- catalog model revision — stock, availability visibility, brand-wide coupons.
--
-- Stock is REINTRODUCED (assignment §3 "Stock Quantity", §4 "stock
-- availability validations prior to checkout", §8 "Low-Stock Products"),
-- superseding the old §7 inventory-removal decision. It is PRODUCT-WIDE by
-- design (user decision, 2026-10-05): purchasing any variant deducts the
-- product's stock; variants carry no stock of their own.
--
-- Availability visibility (user decision): products of active businesses are
-- readable by customers regardless of product status — archived products
-- render as "Unavailable" instead of disappearing. The old
-- products_public_read_active policy is replaced.
--
-- Coupon scope gains 'brand' (assignment §5; user decision): brand-wide
-- coupons apply to cart lines of that brand. NOTE: the new enum value is
-- added here but only USED by the RPC re-creations in 0032 — PostgreSQL
-- rejects referencing a just-added enum value within the same transaction.

-- ------------------------------------------------------------------- stock
alter table public.products
  add column stock integer not null default 0 check (stock >= 0);

-- --------------------------------------------------- availability visibility
drop policy "products_public_read_active" on public.products;
create policy "products_public_read" on public.products
  for select using (
    exists (
      select 1 from public.businesses b
      where b.id = business_id and b.status = 'active'
    )
  );

-- ------------------------------------------------------- brand coupon scope
alter type public.promotion_scope add value 'brand';

alter table public.promotions
  add column brand_id uuid references public.brands (id) on delete set null;

alter table public.promotions
  add constraint promotions_brand_scope_check
  check (scope <> 'brand' or brand_id is not null);
