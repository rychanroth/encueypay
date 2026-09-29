-- Banner promotions carry no discount, but promotions_discount_value_check
-- demanded discount_value > 0 while submit_banner inserts 0 — every banner
-- creation failed with a check-constraint violation (coupons insert real
-- values and were unaffected). Banners always have banner_status <> 'none',
-- so exempt them from the positivity requirement.
alter table public.promotions drop constraint promotions_discount_value_check;
alter table public.promotions
  add constraint promotions_discount_value_check
  check (discount_value > 0 or banner_status <> 'none');
