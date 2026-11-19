# EncueYPay — v1.0

EncueYPay is a single-seller Cambodian commerce app: a Flutter storefront backed by
Supabase, with a built-in admin console. Customers browse an admin-curated catalog,
pay by **KHQR (ABA PayWay)** or **cash on delivery**, and track a server-driven order
lifecycle; admins run the same app through a four-tab executive shell.

**Release:** `v1.0.0` — feature-complete MVP, merged from `impl/mvp` into `master`.

## What's in v1.0

**Customer**

- Email/password and Google sign-in, plus first-run onboarding.
- Hierarchical catalog (categories, sub-categories, brands), search/filter/sort,
  sales, coupons, and banners.
- Explicit product variants with server-authoritative pricing and stock.
- Wishlist and a selectable cart (tick lines, select-all, swipe-to-delete).
- Single-page checkout: delivery address, payment method, coupon, note, and
  server-priced totals; only the selected cart lines are placed.
- KHQR payment with a realtime webhook-confirmed state, or COD.
- Order history and detailed status tracking with logged transition times.
- Reviews on delivered items, notifications, and profile/address management.

**Admin**

- Dashboard KPIs, stock alerts, 14-day trend, and top sellers.
- Product/variant/image, category, brand, and stock management.
- Full order lifecycle: pending → confirmed → processing → packed → shipped →
  out for delivery → delivered, cancellation with reason, and COD mark-paid.
- Sales, coupons, and banner authoring; archive/disable states.
- Reports with date ranges, payment split, best sellers, categories, brands, and
  CSV/JSON/XLSX exports.

## Stack

| Piece | Choice |
|---|---|
| App | Flutter, Dart SDK `^3.12.2` |
| State | Riverpod 3 codegen (`@riverpod`) with freezed state |
| Routing | GoRouter 18, named routes, `StatefulShellRoute.indexedStack` |
| Backend | Supabase (Postgres, Auth, Storage, Realtime) |
| Server logic | SQL RPCs/views + Deno Edge Functions (`payway-create`, `payway-webhook`, `push-dispatch`) |
| Payments | ABA PayWay KHQR + cash on delivery |
| Push | Firebase Cloud Messaging |
| Local persistence | Theme mode only (`shared_preferences`) |

## Layout

```
lib/
  core/                     # theme, responsive, network, routing composition root
  features/<feature>/       # data / domain / presentation, per feature
supabase/
  migrations/               # versioned schema + RPCs
  functions/                # Edge Functions
  seed.sql                  # demo catalog
  testing/                  # local migration replay + RPC smoke suite
docs/                       # contract, design, handoffs, setup guides
test/                       # unit and widget tests
```

Features: `admin`, `auth`, `cart`, `catalog`, `checkout`, `dashboard`,
`notifications`, `orders`, `profile`, `promotions`, `reviews`, `wishlist`.
Features never import other features; `core/router` is the composition root.

The authoritative engineering contract is
[`docs/architecture-contract.md`](docs/architecture-contract.md); working notes and the
feature state index are in [`AGENTS.md`](AGENTS.md); product/UX specs live in
[`docs/DESIGN.md`](docs/DESIGN.md).

## Run

Requires a Flutter SDK, a Supabase project, and compile-time config. Create a
gitignored env file (see [`docs/PROTOTYPE_SETUP.md`](docs/PROTOTYPE_SETUP.md) for a
local stack and [`docs/REMOTE_SETUP.md`](docs/REMOTE_SETUP.md) for a hosted one):

```bash
flutter pub get

# local Supabase stack (supabase start)
flutter run --dart-define-from-file=config/.env

# hosted project
flutter run --dart-define-from-file=config/.remote
```

Or pass the two values explicitly:

```bash
flutter run \
  --dart-define=SUPABASE_URL=<url> \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<publishable-key>
```

OAuth, PayWay, push, and local-device prerequisites are in
[`supabase/README.md`](supabase/README.md). Web geolocation ("Use my current
location") needs `https://` or `http://localhost`; the address form falls back to
tap-to-place on the map otherwise.

## Backend

```bash
supabase db push                                            # apply migrations
supabase functions deploy payway-create payway-webhook push-dispatch
bash supabase/testing/run.sh                               # replay + RPC smoke
```

Migrations apply in filename order and ship with the app as vertical slices. Notes:

- Changing a function signature requires `DROP FUNCTION` first.
- `ALTER TYPE ... ADD VALUE` must be its own migration file.
- Drop dependent RLS policies before `DROP COLUMN`.
- Never re-run `supabase/APPLY-UI-OVERHAUL-MIGRATIONS.sql`; it regresses current RPCs.
- PostgREST has no inline aggregates here — use views/RPCs.

## Verify

```bash
dart run build_runner build --delete-conflicting-outputs   # after annotations change
flutter analyze                                            # must be clean
flutter test                                               # no CI — run locally
bash supabase/testing/run.sh                               # migrations + RPC smoke
```

v1.0.0 status: `flutter analyze` clean and all tests passing.

## Docs

- [`docs/DESIGN.md`](docs/DESIGN.md) — screens, tokens, flows.
- [`docs/DEVELOPER-HANDOFF.md`](docs/DEVELOPER-HANDOFF.md) — routes, RPCs, state.
- [`docs/PROTOTYPE_SETUP.md`](docs/PROTOTYPE_SETUP.md) / [`docs/REMOTE_SETUP.md`](docs/REMOTE_SETUP.md) — step-by-step setup.
- `docs/HANDOFF-*.md` — per-feature state; `docs/figma/` — frozen design mirror.
