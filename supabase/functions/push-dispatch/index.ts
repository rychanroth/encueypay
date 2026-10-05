// FCM push dispatch (Section 8E).
//
// Configure a Database Webhook on `public.notifications` (INSERT) in the
// Supabase dashboard pointing at this function's URL. The webhook payload
// carries the new notification row; the function looks up the recipient's
// FCM tokens and sends via the FCM HTTP v1 API.
//
// Required secret (service-account JSON for a Firebase project with FCM
// enabled):
//   supabase secrets set FCM_SERVICE_ACCOUNT='{"type": "service_account", ...}'
// Without it the function no-ops (in-app notifications are unaffected).
import { createClient } from 'jsr:@supabase/supabase-js@2';

interface ServiceAccount {
  client_email: string;
  private_key: string;
  project_id: string;
}

function base64Url(bytes: Uint8Array): string {
  return btoa(String.fromCharCode(...bytes))
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '');
}

async function getAccessToken(account: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = base64Url(
    new TextEncoder().encode(JSON.stringify({ alg: 'RS256', typ: 'JWT' })),
  );
  const claims = base64Url(
    new TextEncoder().encode(
      JSON.stringify({
        iss: account.client_email,
        scope: 'https://www.googleapis.com/auth/firebase.messaging',
        aud: 'https://oauth2.googleapis.com/token',
        iat: now,
        exp: now + 3600,
      }),
    ),
  );
  // Base64-decode the PEM body.
  const pemBody = account.private_key
    .replace(/\\n/g, '\n')
    .replace('-----BEGIN PRIVATE KEY-----', '')
    .replace('-----END PRIVATE KEY-----', '')
    .replace(/\s+/g, '');
  const rawKey = Uint8Array.from(atob(pemBody), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    'pkcs8',
    rawKey,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    key,
    new TextEncoder().encode(`${header}.${claims}`),
  );
  const jwt = `${header}.${claims}.${base64Url(new Uint8Array(signature))}`;

  const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  });
  const tokenJson = await tokenResponse.json();
  return tokenJson.access_token as string;
}

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('method not allowed', { status: 405 });
  }

  const accountRaw = Deno.env.get('FCM_SERVICE_ACCOUNT');
  if (!accountRaw) {
    // In-app notifications are unaffected; push is simply not configured.
    return Response.json({ configured: false });
  }
  const account: ServiceAccount = JSON.parse(accountRaw);

  // Database Webhook payload: { type, table, record, ... }.
  const body = await req.json();
  const notification = body?.record ?? body;
  const recipient: string | undefined = notification?.recipient;
  const title: string = notification?.title ?? 'EncueYPay';
  const content: string = notification?.content ?? '';
  if (!recipient) {
    return Response.json({ sent: 0, reason: 'no recipient' });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const { data: tokens } = await supabase
    .from('device_tokens')
    .select('token')
    .eq('user_id', recipient);
  if (!tokens || tokens.length === 0) {
    return Response.json({ sent: 0, reason: 'no devices' });
  }

  const accessToken = await getAccessToken(account);
  let sent = 0;
  for (const { token } of tokens) {
    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${account.project_id}/messages:send`,
      {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          message: {
            token,
            notification: { title, body: content },
            data: { notification_id: notification.id ?? '' },
          },
        }),
      },
    );
    if (response.ok) sent += 1;
  }
  return Response.json({ sent });
});
