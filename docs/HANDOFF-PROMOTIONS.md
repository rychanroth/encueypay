# HANDOFF — Sales, Coupons & Banners (the untangled model)

> Rewritten 2026-10-29 after the architecture reset (user decision: the
> campaign system was **truncated**, not migrated). Read before touching
> `sales`, `coupons`, or `banners`. Supersedes every description of the
> old promotion/coupon/banner campaign model.

## 0. State right now

- **Code**: committed through `cd86fc8`; `flutter analyze` clean; the DB
  chain replays from zero (`supabase db reset` green) and the model was
  verified by an end-to-end SQL smoke (rolled back).
- **Pending user action**: `supabase db push` — FIVE migrations are
  unpushed: `20261028000003` (variant flow), `20261028000004` (the OLD
  campaign model — immediately superseded), `20261029000001` (drop stale
  RPC overloads), `20261029000002` (category scope enum value),
  `20261029000003` (sales + standalone codes). The push **truncates**
  `sales`, `coupons`, `banners`, `order_coupons` — the admin recreates
  live sales through the new UI, which doubles as its first test. Past
  orders keep their aggregate `discount_minor`; only per-code breakdown
  rows go.
- The app and DB ship together (the `promotions`→`sales` rename breaks the
  old queries): push, then hot-restart.

## 1. The model (three independent concepts)

- **`sales`** (renamed from `promotions`) — the pricing layer: scope
  `platform | brand | category` (enum `sale_scope`; `'business'` remains a
  dormant enum value Postgres cannot drop), `discount_type`
  (`percent | fixed` per-unit), `discount_value > 0` (hard constraint
  again), `active` kill switch, own `starts_at`/`ends_at`. No code, no
  minimum order, no stacking.
- **`coupons`** — standalone cart-wide codes: `name`, `code` (unique),
  own `discount_type`/`discount_value`, `min_order_amount_minor`, window,
  `active`. `promotion_id` and `auto_apply` are gone. Codes stack on top
  of the sale-applied subtotal and are recorded in `order_coupons`
  (`auto_applied` column remains for historical rows; always false now).
- **`banners`** — cosmetic: image + moderation + optional `sale_id` used
  ONLY for the Discovery tap target. A banner whose sale is inactive or
  out of window is filtered out client-side (auto-hide). `sale_id` NULL =
  inert display-only banner.

**Rule set (one place each):** applicability + "live" live in the
`active_sales` view; the effective price lives in
`best_sale_price_minor(product_id, price)` — lowest resulting price among
applicable sales (percent truncates `(p×v)/100`, fixed floors at 0).
Overlapping sales: **lowest final price wins** (the user's "higher
discount wins", which also compares percent vs dollars by outcome).

## 2. Server surface

- `active_sales` view (`security_invoker`, granted to anon/authenticated)
  — the single live-definition; the client fetch reads it directly, so no
  window logic exists in Dart.
- `best_sale_price_minor()` — used by `validate_coupon`,
  `preview_order_totals`, and `create_order_from_cart`. Sales are pricing:
  order lines are charged at the sale price (`order_items.unit_price_minor`
  = historical truth); no ledger for sales.
- `admin_create_sale(p_name, p_description, p_discount_type,
  p_discount_value, p_scope, p_brand_id, p_category_id, p_starts_at,
  p_ends_at, p_image_path)` → `{sale_id, banner_id}` — with an image, the
  same call inserts an approved banner linked to the sale (one-step
  campaign UX, single-admin). `admin_set_sale_active`,
  `admin_create_coupon` (replaces `create_platform_promotion`).
- `validate_coupon(p_code)` — standalone, cart-wide, sale-applied base;
  returns `{valid, message, discount_minor}` (no scope).
- `preview_order_totals(p_codes)` → `{subtotal_minor, manual[],
  total_discount_minor, delivery_fee_minor, total_minor}` — the checkout
  summary renders exactly these; placement recomputes the same numbers.
- Retired: `admin_create_campaign`, `admin_set_promotion_active`,
  `create_platform_promotion`, `preview_cart_discounts`, the auto-apply
  block, `CAMP-` code generation.
- RLS: `sales` keeps the legacy `promotions_*` policy names (policies
  can't be renamed); public read is intentional (all sale data is
  customer-facing). `coupons` writes are admin-only now
  (`coupons_admin_write` — the old creator policy subqueried the dropped
  `promotion_id`).

## 3. Client surface

- `features/catalog`: `ActiveSale` entity (+ `sale_providers.dart`:
  `activeSalesProvider`, `saleForIds`/`saleForProduct`,
  `displayPriceMinor`); ProductCard / product detail / CTA / variant sheet
  render struck-through sale prices; the chip label is `15% OFF` /
  `$3.00 OFF` (no minimum suffix — sales have none).
- `fetchApprovedBanners` embeds `sales(...)` and derives brand/category/
  platform targets (Discovery already accepts `kind=category`); banners
  with a dead sale are dropped.
- `features/wishlist` + `features/cart` lines carry
  `brand_id`/`category_id`; the composition root (`core/router/branches/`)
  resolves sale prices into a plain item-id → unit-price map passed to
  `CartScreen` / `CheckoutScreen` (features never import features,
  ARCH-04).
- `features/checkout`: `preview_order_totals` via
  `order_totals_provider.dart` + `OrderTotalsPreview`; summary rows are
  Subtotal / Discount (codes) / Delivery / Total — no Auto-applied row.
- `features/promotions` (admin): Sales / Coupons / Banners sections;
  `ManagedSale` / `ManagedCoupon` / `ManagedBanner` entities;
  `AdminSalesController` / `AdminCouponsController` /
  `AdminBannersController`.

## 4. Root causes found on the way (don't rediscover)

1. **Overload lesson** (contract ACTION-02/03): `CREATE OR REPLACE
   FUNCTION` with a changed signature ADDS an overload; PostgREST then
   fails every call valid for both with "Could not choose the best
   candidate function". Every signature change = explicit `DROP FUNCTION`
   first.
2. **RLS policies block column drops** — drop dependent policies BEFORE
   `DROP COLUMN` (hit twice in one migration).
3. `ALTER TYPE ... ADD VALUE` lives in its own migration file.
4. `block_role_self_change` guards `users.active_role` — role changes go
   through role applications. For SQL smokes: set up the identity BEFORE
   `SET LOCAL request.jwt.claims`; `auth.users` inserts auto-create the
   `public.users` row (update, don't insert).
5. Stale scripts: `supabase/testing/*.sql` reference retired RPCs;
   `supabase/APPLY-UI-OVERHAUL-MIGRATIONS.sql` must NEVER be re-run (it
   would regress `validate_coupon` to the business-era body).

## 5. Settled decisions (do not re-litigate without the user)

- Sales are pricing — no code, no minimum order, no stacking; codes stack
  on the sale-applied subtotal.
- Higher discount wins = lowest final price (compares percent vs fixed).
- Banners auto-hide when their sale is off; display-only banners inert.
- Old campaign data truncated (user decision), not migrated.
- Fixed dollar sales render struck-through per unit like percent sales.
- Coupon codes kept (simplified), not deleted.

## 6. Verification checklist (user, after `supabase db push` + restart)

1. Admin → Sales & coupons → campaign icon → "New sale": scope
   platform/brand/category, percent or fixed, optional image → the sale
   appears (+ an approved banner when an image was attached).
2. Home banner strip: the sale-linked banner taps to Discovery filtered by
   the sale's brand/category (platform = full feed); flip the sale's
   switch → the banner disappears, chips and struck prices vanish.
3. Product card, detail page, CTA, variant sheet, wishlist card, cart
   line: all show the same struck-through sale price for a product.
4. Checkout: Subtotal reflects sale prices; create a coupon ("New
   coupon"), type it at step 5 → "Discount (codes)" row; the total matches
   the placed order's.
5. Coupon minimum order: a below-minimum cart silently skips the code at
   placement (known gap — no "why didn't it apply" notice yet).

## 7. Known gaps / deferred (do not build unasked)

- No "why didn't my code apply" notice (min-order/invalid skips are silent
  in `preview_order_totals`).
- No per-sale reporting; `order_coupons` is write-only bookkeeping.
- Admin product lists show base price only (no effective-price column).
- Multi-code stacking follows the assignment sequence (codes sum, capped
  at the sale-applied subtotal); per-customer redemption limits remain a
  non-goal.
