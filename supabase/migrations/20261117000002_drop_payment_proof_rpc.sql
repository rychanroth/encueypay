-- Retire the bank-transfer proof upload path (2026-11-17).
--
-- `submit_payment_proof` let a customer self-verify a bank transfer by
-- uploading a receipt: it set payments.status = 'transaction_verified' and
-- paid_at = now(). Bank transfer was replaced by KHQR before launch, checkout
-- can only create `cod`/`qr`, and the app's upload UI is gone, so the RPC is
-- an unreachable write path that trusted the customer to mark money received.
--
-- Deliberately NOT dropped here:
--   * the `bank_transfer` payment_method enum value — legacy rows still read
--     it (Postgres cannot drop a single enum value anyway);
--   * the `payments.proof_path` column and the `payment_proofs` storage bucket
--     — removing those deletes stored objects, and no client can write to them
--     any more.

DROP FUNCTION IF EXISTS public.submit_payment_proof(uuid, text);
