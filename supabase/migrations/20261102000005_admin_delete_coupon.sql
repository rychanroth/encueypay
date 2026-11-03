-- Coupon hard delete for codes that were never redeemed.
--
-- Coupons are redeemable codes, not order history: order_coupons keeps the
-- historical per-code breakdown and its FK (no ON DELETE) intentionally
-- blocks removing a used code. An unused code is safe to remove; a used one
-- must be deactivated instead so past orders stay auditable.

CREATE OR REPLACE FUNCTION public.admin_delete_coupon(p_coupon_id uuid)
RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  if not public.is_admin() then
    raise exception 'Only admins can delete coupons';
  end if;

  if not exists (select 1 from public.coupons where id = p_coupon_id) then
    raise exception 'Coupon not found';
  end if;

  if exists (
    select 1 from public.order_coupons where coupon_id = p_coupon_id
  ) then
    raise exception
      'This coupon has been used on orders. Deactivate it instead of deleting.';
  end if;

  delete from public.coupons where id = p_coupon_id;

  perform public.record_admin_audit(
    'admin_delete_coupon', 'coupon', p_coupon_id, NULL);
end;
$$;
