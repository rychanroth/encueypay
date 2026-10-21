-- The ABA PayWay webhook (payway-webhook) is now the sole QR settlement
-- path (user decision 2026-10-21): the admin demo shortcut is retired, and
-- confirm_qr_payment — SECURITY DEFINER, called by the webhook with the
-- service role — is locked down to that role. Leaving PUBLIC execute on it
-- would let any PostgREST caller settle their own pending payment.

DROP FUNCTION IF EXISTS public.simulate_qr_payment(uuid);

REVOKE EXECUTE ON FUNCTION public.confirm_qr_payment(uuid, text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.confirm_qr_payment(uuid, text) TO service_role;
