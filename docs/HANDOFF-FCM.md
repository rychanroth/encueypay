# FCM Push — handoff & verification

**Status (2026-11-07):** hosted pipeline verified end-to-end. Background/terminated
pushes appear in the Android tray; tap opens the linked order. Foreground pushes now
render as native local notifications (Android). In-app Supabase Realtime is a separate
channel and does not drive push delivery.

## Flow

```text
domain event -> trigger inserts notifications row
             -> DB webhook (notifications INSERT) -> push-dispatch Edge Function
             -> device_tokens lookup -> FCM HTTP v1
             -> OS tray (background) / local notification (foreground)
```

The in-app inbox is a Supabase Realtime stream on `notifications`; it works without
FCM configured. Push delivery never updates screen state — that is Realtime's job.

## Remote configuration checklist

- [ ] Firebase project + `android/app/google-services.json`; Gradle `google-services`
      plugin applied (`android/settings.gradle.kts`, `android/app/build.gradle.kts`).
- [ ] `FCM_SERVICE_ACCOUNT` set as a Supabase Edge Function secret.
- [ ] `push-dispatch` deployed.
- [ ] Database Webhook: table `notifications`, event **INSERT**, type Edge Function,
      secret key added (otherwise `verify_jwt` rejects with 401), URL
      `https://<project-ref>.supabase.co/functions/v1/push-dispatch`.
- [ ] Device has Google Play services; app signed in so `register_device_token` upserts.

Local stack specifics (URL/secret loading) are in `docs/PROTOTYPE_SETUP.md` Phase 7.

## Events map (current triggers)

| Source | Wire event | Notification |
|---|---|---|
| `orders.status` | confirmed / processing / packed / shipped / out_for_delivery / delivered / cancelled | Order status notification |
| `orders.status` | pending (creation) | none (intentional) |
| `orders.status` | returned | unreachable via `admin_transition_order` |
| `payments.status` | transaction_verified | “Payment received” (QR webhook or admin COD) |
| promotions / coupons | — | not implemented |
| admin “new order” | — | not implemented (customer-only recipients) |

Every order/payment notification carries `order_id`; taps deep-link to OrderDetail.
Rows without an order link open the inbox.

## Fixed root cause (2026-11-07)

Symptom: every webhook run returned HTTP 200 with `{"sent":0,"reason":"no devices"}`
even though the recipient had a `device_tokens` row.

Cause: the frozen baseline granted `service_role` only
`REFERENCES, TRIGGER, TRUNCATE, MAINTAIN` on public tables. `push-dispatch` queries
`device_tokens` through PostgREST as `service_role`, so the SELECT failed with
`42501 permission denied` — and the function discarded the error as “no devices”.
`rolbypassrls` does not bypass table GRANTs. The same class of bug was previously
fixed for PayWay (`20261021000001_grant_service_role_payments.sql`).

Fix:
- `20261107000001_grant_service_role_device_tokens.sql` — `GRANT SELECT` to
  `service_role`.
- `push-dispatch` now returns 500 + the PostgREST error when the lookup fails, and
  reports FCM failures as `{sent, failed, error}`.

Verified: a test notification produced `{"sent":1,"failed":0}`.

## Foreground rendering

- Android never auto-renders an FCM `notification` message while the app is
  foregrounded; `FirebaseMessaging.onMessage` owns it.
- `PushNotificationsService` shows a native local notification via
  `flutter_local_notifications` (channel `order_updates`, high importance,
  swipe-dismissible) with `order_id`/`notification_id` payload.
- Tapping marks the notification read and routes through `openPushTarget`.
- If the local plugin cannot initialize, `main.dart` shows a fallback SnackBar with a
  finite duration + close icon.
- Android build: `compileSdk` 36 (plugin v22 requires ≥35) and core-library
  desugaring are enabled in `android/app/build.gradle.kts`.
- iOS still needs `GoogleService-Info.plist` + notification capability; push remains
  inert there until configured.

## QA checklist

1. Sign in on a physical Android device with Play services; confirm a `device_tokens`
   row exists for the user.
2. Background/terminated: transition an order as admin → tray notification appears.
3. Tap the tray notification → OrderDetail opens, notification is marked read.
4. Foreground: transition again → native heads-up notification appears (not a
   SnackBar) and can be swiped away.
5. Tap the foreground notification → OrderDetail opens.
6. Sign out → this device's token row is deleted; sign in with another account →
   token re-registers.
7. Trigger a COD payment via admin → “Payment received” push arrives.

## Diagnostics

```sql
-- Webhook registration + run history
select * from supabase_functions.hooks order by id desc limit 10;
-- What the Edge Function returned (pg_net)
select id, status_code, timed_out, left(content, 500)
  from net._http_response order by id desc limit 10;
```

`{"sent":0,"reason":"no devices"}` → token lookup empty (check recipient/tokens).
`{"sent":0,"failed":1,"error":"..."}` → FCM rejected the token/credentials.
Non-200 webhook → verify the secret key and function URL.

## Files

- `supabase/functions/push-dispatch/index.ts`
- `supabase/migrations/20261102000009_notification_order_link.sql`
- `supabase/migrations/20261107000001_grant_service_role_device_tokens.sql`
- `lib/features/notifications/data/push_notifications_service.dart`
- `lib/main.dart`
- `docs/PROTOTYPE_SETUP.md` Phase 7 / `docs/app_implementation_specification.md` §A.6
