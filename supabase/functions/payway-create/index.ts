// ABA PayWay QR initiation (Section 6b — PayWay production path).
//
// The customer app invokes this function (anon key) once per pending QR
// payment; the function creates the transaction via PayWay's QR API,
// stores the returned KHQR string on the payments row, and returns it for
// rendering. All signing secrets live here — never in the app:
//   PAYWAY_BASE_URL      https://checkout-sandbox.payway.com.kh (sandbox)
//                        or https://checkout.payway.com.kh (production)
//   PAYWAY_MERCHANT_ID   merchant id from ABA Bank
//   PAYWAY_API_KEY       the HMAC secret ("Public Key" in the portal)
//   PAYWAY_CALLBACK_URL  optional webhook override (tunnels); defaults to
//                        $SUPABASE_URL/functions/v1/payway-webhook
//
// Official spec: developer.payway.com.kh → ABA QR API → QR API
// (POST /api/payment-gateway/v1/payments/generate-qr). The hash covers
// exactly the parameters posted, concatenated in the spec's canonical
// order, HMAC-SHA512'd with the API key and Base64-encoded. Soft failures
// return 200 with a `reason` (the app reads it); only unexpected
// conditions answer non-2xx.
import { createClient } from 'jsr:@supabase/supabase-js@2';

const MERCHANT_ID = Deno.env.get('PAYWAY_MERCHANT_ID');
const API_KEY = Deno.env.get('PAYWAY_API_KEY');
const BASE_URL = (Deno.env.get('PAYWAY_BASE_URL') ??
  'https://checkout-sandbox.payway.com.kh').replace(/\/+$/, '');

// Canonical hash order from the generate-qr spec.
const CANONICAL_ORDER = [
  'req_time', 'merchant_id', 'tran_id', 'amount', 'items',
  'first_name', 'last_name', 'email', 'phone', 'purchase_type',
  'payment_option', 'callback_url', 'return_deeplink', 'currency',
  'custom_fields', 'return_params', 'payout', 'lifetime',
  'qr_image_template',
];

// PayWay caps tran_id at 20 chars; order ids are 36-char UUIDs. The
// derivation is stable per order (idempotent retries reuse the same
// transaction) and is NEVER parsed back — the webhook maps via
// return_params.order_id instead.
const tranIdFor = (orderId: string) => orderId.replaceAll('-', '').slice(0, 20);

// UTC YYYYMMDDHHmmss.
const utcNow = () =>
  new Date().toISOString().replace(/[-:T]/g, '').slice(0, 14);

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

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('method not allowed', { status: 405 });
  }
  const { orderId } = await req.json().catch(() => ({}) as { orderId?: string });
  if (!orderId) {
    return new Response('missing orderId', { status: 400 });
  }

  if (!MERCHANT_ID || !API_KEY) {
    return Response.json({ configured: false, reason: 'secrets_missing' });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );
  const { data: payment, error: fetchError } = await supabase
    .from('payments')
    .select('status, method, amount_minor, qr_payload')
    .eq('order_id', orderId)
    .maybeSingle();
  if (fetchError) {
    console.error('payment lookup failed', fetchError.message);
    return Response.json(
      { configured: true, reason: 'lookup_failed' },
      { status: 502 },
    );
  }
  if (!payment) {
    return Response.json({ configured: true, reason: 'no_payment' });
  }
  if (payment.method !== 'qr' || payment.status !== 'pending') {
    return Response.json({
      configured: true,
      reason: payment.status === 'transaction_verified'
        ? 'already_paid'
        : 'not_pending',
    });
  }

  const callbackUrl = (Deno.env.get('PAYWAY_CALLBACK_URL') ??
    `${Deno.env.get('SUPABASE_URL')!.replace(/\/+$/, '')}/functions/v1/payway-webhook`);

  // Only non-empty params are posted; the hash covers exactly those, in
  // canonical order ("optional parameters not relevant to your use case
  // may be omitted" — API Endpoints guide).
  const params: Record<string, string | number> = {
    req_time: utcNow(),
    merchant_id: MERCHANT_ID,
    tran_id: tranIdFor(orderId),
    // USD cents → dollars. Hashed as its shortest string form, matching
    // how PayWay stringifies the decoded JSON number server-side.
    amount: payment.amount_minor / 100,
    purchase_type: 'purchase',
    payment_option: 'abapay_khqr',
    callback_url: btoa(callbackUrl),
    currency: 'USD',
    return_params: JSON.stringify({ order_id: orderId }),
    lifetime: 60, // minutes — the QR stops accepting payment after 1 h
  };
  const b4hash = CANONICAL_ORDER
    .filter((key) => key in params)
    .map((key) => String(params[key]))
    .join('');
  const hash = await hmacSha512Base64(API_KEY, b4hash);

  const response = await fetch(
    `${BASE_URL}/api/payment-gateway/v1/payments/generate-qr`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ...params, hash }),
    },
  );
  const contentType = response.headers.get('content-type') ?? '';
  if (!contentType.includes('application/json')) {
    // Checkout-profile HTML instead of the QR API's JSON — the merchant
    // profile likely lacks the QR Payment API service (or is whitelisting).
    const text = await response.text();
    console.error('generate-qr non-JSON response', response.status, text.slice(0, 200));
    return Response.json(
      { configured: true, reason: 'unexpected_response' },
      { status: 502 },
    );
  }
  const result = await response.json();
  const code = String(result?.status?.code ?? '');
  const qr: unknown = result?.qrString ?? result?.qr_string;
  if (response.ok && (code === '0' || code === '00') && typeof qr === 'string' && qr.length > 0) {
    const { error: updateError } = await supabase
      .from('payments')
      .update({ qr_payload: qr })
      .eq('order_id', orderId)
      .eq('status', 'pending');
    if (updateError) {
      console.error('qr_payload store failed', updateError.message);
      return Response.json(
        { configured: true, reason: 'store_failed' },
        { status: 502 },
      );
    }
    return Response.json({ configured: true, qrPayload: qr });
  }

  // Documented generate-qr error codes: 1 wrong hash, 6/102 whitelist,
  // 12 currency, 23 option not enabled, 403 duplicate tran_id, 429 limit.
  console.error(
    'generate-qr failed',
    code,
    result?.status?.message,
    result?.status?.trace_id,
  );
  return Response.json({
    configured: true,
    reason: 'payway_error',
    code,
    message: result?.status?.message ?? null,
  });
});
