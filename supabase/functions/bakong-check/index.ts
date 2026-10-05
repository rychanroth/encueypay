// Bakong transaction confirmation poller (Section 6b).
//
// The customer app calls this function (invoked with its anon key) while
// waiting on the order-success screen; the function checks the payment's
// KHQR MD5 against Bakong's check_transaction_by_md5 using the
// BAKONG_TOKEN secret:
//   supabase secrets set BAKONG_TOKEN=...
// Without the token the function reports { configured: false } and the app
// offers the simulation path instead.
import { createClient } from 'jsr:@supabase/supabase-js@2';

const BAKONG_TOKEN = Deno.env.get('BAKONG_TOKEN');

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('method not allowed', { status: 405 });
  }
  const { orderId } = await req.json();
  if (!orderId) {
    return new Response('missing orderId', { status: 400 });
  }

  if (!BAKONG_TOKEN) {
    return Response.json({ configured: false, paid: false });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  // The MD5 transaction key is computed SQL-side from the stored payload —
  // never trusted from the client.
  const { data: payment } = await supabase
    .from('payments')
    .select('qr_payload, status, payments_qr_md5:md5(qr_payload)')
    .eq('order_id', orderId)
    .maybeSingle();
  const md5 = (payment as { payments_qr_md5?: string } | null)?.payments_qr_md5;
  if (!md5) {
    return Response.json({ configured: true, paid: false, error: 'no qr' });
  }
  if (payment.status !== 'pending') {
    return Response.json({ configured: true, paid: payment.status === 'transaction_verified' });
  }

  const response = await fetch(
    'https://api-bakong.nbc.gov.kh/v1/check_transaction_by_md5',
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${BAKONG_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ md5 }),
    },
  );
  const result = await response.json();
  const paid = result?.responseCode === 0 && result?.data?.paid === true;
  if (paid) {
    await supabase.rpc('confirm_qr_payment', {
      p_order_id: orderId,
      p_reference: result?.data?.hash ?? 'bakong',
    });
  }
  return Response.json({ configured: true, paid });
});
