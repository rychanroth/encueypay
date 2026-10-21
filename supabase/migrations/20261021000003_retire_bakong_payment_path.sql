-- Retires the direct-Bakong payment path for good (PayWay is the
-- production path — see docs/HANDOFF-KHQR.md):
--   * register_qr_payment stored a client-generated KHQR plus its
--     Postgres-computed MD5 (the Bakong check_transaction_by_md5 key);
--     the PayWay flow has no client-side payload — payway-create stores
--     PayWay's own QR string server-side.
--   * payments.qr_md5 held that MD5 key; platform_settings.qr_account_id
--     fed the local KHQR builder. Both unused since the PayWay rewiring.
DROP FUNCTION IF EXISTS public.register_qr_payment(p_order_id uuid, p_payload text);
ALTER TABLE public.payments DROP COLUMN IF EXISTS qr_md5;
ALTER TABLE public.platform_settings DROP COLUMN IF EXISTS qr_account_id;
