-- Make the redeemed-coupon check see the FK rows.
--
-- `order_coupons` RLS only exposes a customer's own rows; an admin calling
-- `admin_delete_coupon` saw none, so the existence check passed and the
-- DELETE hit the FK constraint (a raw Postgrest error instead of the
-- actionable "deactivate it" message). SECURITY DEFINER runs the check as
-- the owner; `is_admin()` still gates the call.

CREATE OR REPLACE FUNCTION public.admin_delete_coupon(p_coupon_id uuid)
RETURNS void
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path TO 'public'
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

REVOKE ALL ON FUNCTION public.admin_delete_coupon(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.admin_delete_coupon(uuid) FROM anon;
GRANT EXECUTE ON FUNCTION public.admin_delete_coupon(uuid) TO authenticated;
