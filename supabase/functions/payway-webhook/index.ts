// ABA PayWay server-to-server transaction callback (Section 6b).
//
// Configure the callback URL in the PayWay merchant portal to this
// function's public URL:
//   https://<project>.supabase.co/functions/v1/payway-webhook
//
// The payload is form-encoded and carries an HMAC-SHA512 `hash` signed with
// the merchant API key. Validation requires the PAYWAY_API_KEY secret:
//   supabase secrets set PAYWAY_API_KEY=...
// Without the secret the function rejects callbacks (fail-closed) — the
// prototype demos run through simulate_qr_payment instead.
import { createClient } from 'jsr:@supabase/supabase-js@2';

const PAYWAY_API_KEY = Deno.env.get('PAYWAY_API_KEY');

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('method not allowed', { status: 405 });
  }

  const form = await req.formData();
  const field = (name: string) => form.get(name)?.toString() ?? '';
  const tranId = field('tran_id');
  const status = field('status').toUpperCase();
  const hash = field('hash');

  if (!tranId) {
    return new Response('missing tran_id', { status: 400 });
  }

  // Fail-closed HMAC validation ( PayWay: hash = HMAC-SHA512 over the
  // concatenated payload fields, base64-encoded).
  if (!PAYWAY_API_KEY) {
    console.error('PAYWAY_API_KEY not configured — rejecting callback');
    return new Response('webhook not configured', { status: 503 });
  }
  const payload = ['tran_id', 'status', 'apv']
    .map((name) => form.get(name)?.toString() ?? '')
    .join('');
  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(PAYWAY_API_KEY),
    { name: 'HMAC', hash: 'SHA-512' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(payload));
  const expected = btoa(String.fromCharCode(...new Uint8Array(signature)));
  if (expected !== hash) {
    return new Response('invalid hash', { status: 401 });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  if (status === 'SUCCESS' || status === 'PRE_AUTH_SUCCESS') {
    const { error } = await supabase.rpc('confirm_qr_payment', {
      p_order_id: tranId,
      p_reference: field('apv') || 'payway',
    });
    if (error) {
      console.error('confirm failed', error);
      return new Response('confirm failed', { status: 500 });
    }
  }
  // Non-success statuses are recorded but not confirmed; pending stays
  // pending (the customer can retry/cancel per the checkout flow).
  return new Response('ok', { status: 200 });
});
