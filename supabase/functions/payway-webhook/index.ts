// ABA PayWay server-to-server payment callback (Section 6b — PayWay path).
//
// Configure as the callback target in the PayWay portal (API Settings /
// return URL) or via callback_url on generate-qr:
//   https://<project>.supabase.co/functions/v1/payway-webhook
//
// Documented scheme (developer.payway.com.kh → Ecommerce Checkout → Verify
// Callback Signature): the request body is JSON and PayWay signs it in the
// `X-PayWay-HMAC-SHA512` header — base64(HMAC-SHA512(concatenated values in
// ascending key order, secretKey)), with objects/arrays JSON-encoded and
// nulls treated as empty. `status` "0" means success. Fail-closed without
// PAYWAY_API_KEY; confirmations go through the idempotent, pending-guarded
// confirm_qr_payment RPC, so duplicate/delayed callbacks are no-ops.
import { createClient } from 'jsr:@supabase/supabase-js@2';

const API_KEY = Deno.env.get('PAYWAY_API_KEY');

async function hmacSha512Base64(key: string, payload: string): Promise<string> {
  const cryptoKey = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(key),
    { name: 'HMAC', hash: 'SHA-512' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign(
    'HMAC',
    cryptoKey,
    new TextEncoder().encode(payload),
  );
  return btoa(String.fromCharCode(...new Uint8Array(signature)));
}

// Constant-time-enough equality for same-length base64 digests.
function digestsMatch(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

// The callback's signature concatenates the values of every body field in
// ascending key order — nested objects/arrays JSON-encoded, nulls empty.
// Number stringification must match PayWay's (PHP strval of the decoded
// JSON value): both sides round-trip the same JSON text, so plain String()
// matches for the decimal amounts in this schema.
function signaturePayload(body: Record<string, unknown>): string {
  return Object.keys(body)
    .sort()
    .map((key) => {
      const value = body[key];
      if (value === null || value === undefined) return '';
      if (typeof value === 'object') return JSON.stringify(value);
      return String(value);
    })
    .join('');
}

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('method not allowed', { status: 405 });
  }
  if (!API_KEY) {
    console.error('PAYWAY_API_KEY not configured — rejecting callback');
    return new Response('webhook not configured', { status: 503 });
  }

  const body = await req.json().catch(() => null);
  if (body === null || typeof body !== 'object') {
    return new Response('bad request', { status: 400 });
  }
  const fields = body as Record<string, unknown>;

  const received = req.headers.get('x-payway-hmac-sha512') ?? '';
  const expected = await hmacSha512Base64(API_KEY, signaturePayload(fields));
  if (!digestsMatch(expected, received)) {
    return new Response('invalid hash', { status: 401 });
  }

  const tranId = typeof fields['tran_id'] === 'string' ? fields['tran_id'] : '';
  if (!tranId) {
    return new Response('missing tran_id', { status: 400 });
  }
  if (String(fields['status'] ?? '') !== '0') {
    // Declines/cancellations never flip the row; ack so PayWay stops
    // retrying.
    console.log('payway callback non-success', tranId, fields['status']);
    return Response.json({ ok: true, confirmed: false });
  }

  // payway-create stashed the order mapping in return_params (echoed back
  // verbatim) — tran_id itself is a truncated id and never parsed.
  let orderId: string | null = null;
  if (typeof fields['return_params'] === 'string') {
    try {
      const parsed = JSON.parse(fields['return_params']);
      if (typeof parsed?.order_id === 'string') orderId = parsed.order_id;
    } catch {
      orderId = null;
    }
  }
  if (!orderId) {
    console.error('payway callback unmapped', tranId);
    return Response.json({ ok: true, confirmed: false, reason: 'unmapped' });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );
  const { data: payment, error } = await supabase
    .from('payments')
    .select('amount_minor, status')
    .eq('order_id', orderId)
    .maybeSingle();
  if (error || !payment) {
    console.error('payway callback unknown order', orderId, error?.message);
    return Response.json({ ok: true, confirmed: false, reason: 'unknown_order' });
  }

  // Never confirm a different amount than the one the order asked for.
  const paidAmount = Number(
    fields['payment_amount'] ?? fields['total_amount'] ?? fields['original_amount'],
  );
  if (
    Number.isFinite(paidAmount) &&
    Math.abs(paidAmount - payment.amount_minor / 100) > 0.005
  ) {
    console.error('payway callback amount mismatch', orderId, paidAmount);
    return Response.json({ ok: true, confirmed: false, reason: 'amount_mismatch' });
  }

  const reference = typeof fields['apv'] === 'string' && fields['apv'] !== ''
    ? fields['apv']
    : typeof fields['bank_ref'] === 'string' && fields['bank_ref'] !== ''
    ? fields['bank_ref']
    : 'payway';
  const { error: confirmError } = await supabase.rpc('confirm_qr_payment', {
    p_order_id: orderId,
    p_reference: reference,
  });
  if (confirmError) {
    console.error('confirm_qr_payment failed', orderId, confirmError.message);
    return new Response('confirm failed', { status: 500 });
  }
  return Response.json({ ok: true, confirmed: true });
});
