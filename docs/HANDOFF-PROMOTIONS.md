# HANDOFF — Sales, Coupons & Banners (the untangled model)

> Rewritten 2026-10-29 after the architecture reset (user decision: the
> campaign system was **truncated**, not migrated). Read before touching
> `sales`, `coupons`, or `banners`. Supersedes every description of the
> old promotion/coupon/banner campaign model.

## 0. State right now — 2026-11-02

- **Code**: committed through `410a7ba` (combined UX/variants/promotions/
  push checkpoint). Promotions fixes landed in `e649771`; the address/QR
  work in later commits is unrelated. The promotions slice includes:
  - The promotions DTOs (`SaleDto`, `CouponDto`, `BannerDto`, brand/category
    refs) no longer cast nullable wire values to non-null `String`; text
    fields default to `''`, `image_path` is nullable and a missing banner
    image renders a placeholder. `fetchApprovedBanners` skips banners with
    no image path and nullable target ids.
  - `admin_create_sale` failures now best-effort delete the uploaded
    banner image (no orphan asset).
  - Coupon delete: `admin_delete_coupon` (migration
    `20261102000005`) hard-deletes only unredeemed codes; a code referenced
    by `order_coupons` is rejected with "deactivate instead". The admin
    coupon row has a delete action with confirmation.
  - Fixed-amount admin inputs parse dollars with `Money.parse`; percent
    stays a whole number.
  - Structured coupon validation/preview feedback, rejected-code rows,
    and the product-detail sale sheet.
  - Cart/checkout line prices come from `cart_item_details`.
- **Runtime status**: the null-cast hardening is covered by
  `test/promotion_model_test.dart` (sale/coupon/banner DTOs with null
  fields) and `flutter analyze`/`flutter test` pass. **End-to-end sale
  creation with a banner has not been re-tested after the changes.** If the
  `UnexpectedFailure(type 'Null' ... String ...)` still appears, capture
  the `[data-error] unexpected ...` stack — the remaining suspects are a
  stale installed build or a deployed schema/function that differs from
  `supabase/migrations/`.
- **Live data observation**: the hosted project has a `bon om tuk` 10%
  platform sale with an empty description, and coupons
  `XXXYYY`/`XXXEEE` (`fixed`, value `2`), `YYYZZZ` (`fixed`, value `12`),
  and `WWWEEE` (`fixed`, value `50`). Those fixed rows carried the old
  wrong units (`$0.02`/`$0.12`/`$0.50`); corrected in place on 2026-11-03 to
  minor units `200`/`200`/`1200`/`5000` (`$2`/`$2`/`$12`/`$50`). The
  percent coupon is fine.
- **Remote migrations applied (2026-11-03):** `20261028000003`,
  `20261028000004`, `20261029000001`, `20261029000002`, `20261029000003`,
  `20261102000001`–`20261102000009` are on the hosted project. Remaining
  work is runtime verification (§6) and a sale-with-banner re-test. The old
  fixed-value coupons were corrected in place on 2026-11-03. The app and DB
  ship together (the `promotions`→`sales` rename breaks old queries), so
  hot-restart after any further backend change.

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
  `admin_create_coupon` (replaces `create_platform_promotion`),
  `admin_delete_coupon` (unredeemed codes only; used codes must be
  deactivated because `order_coupons` keeps the historical breakdown).
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
  `AdminBannersController`. The Coupons section shows only live or
  scheduled codes; expired or manually deactivated codes move to a
  read-only **Archived coupons** screen
  (`AppRoutes.adminArchivedCoupons`, nested under the promotions route).
  Each live coupon row keeps the active switch and adds a confirmed delete
  action; the server rejects used codes.

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
6. RLS can make an admin RPC's pre-check lie: `order_coupons` only exposes
   a customer's own rows, so the original `admin_delete_coupon` saw no
   reference, deleted, and got a raw FK violation. Cross-tenant existence
   checks inside admin RPCs need `SECURITY DEFINER` (plus `SET search_path`
   and the `is_admin()` gate), not a wider read policy.

## 5. Settled decisions (do not re-litigate without the user)

- Sales are pricing — no code, no minimum order, no stacking; codes stack
  on the sale-applied subtotal.
- Higher discount wins = lowest final price (compares percent vs fixed).
- Banners auto-hide when their sale is off; display-only banners inert.
- Old campaign data truncated (user decision), not migrated.
- Fixed dollar sales render struck-through per unit like percent sales.
- Coupon codes are never auto-deleted. An unredeemed code may be hard
  deleted by the admin; a redeemed code is deactivated so `order_coupons`
  history and its FK stay intact.
- Archive split: main list = active and not past `ends_at` (scheduled
  coupons stay main). Archive = deactivated or expired. The archive is
  view-only by user decision (no restore action yet).

## 6. Verification checklist (user, after `supabase db push` + restart)

1. Admin → Sales & coupons → campaign icon → "New sale": scope
   platform/brand/category, percent or fixed, optional image → the sale
   appears (+ an approved banner when an image was attached).
2. Home banner strip: the sale-linked banner taps to Discovery filtered by
   the sale's brand/category (platform = full feed); flip the sale's
   switch → the banner disappears, chips and struck prices vanish.
3. Product card, detail page, CTA, variant sheet, wishlist card, cart
   line: all show the same struck-through sale price. Cart/checkout lines
   read `cart_item_details`, so their price matches the summary without a
   client-side sales map.
4. Checkout is one page (items, address, delivery/payment, coupon, note,
   summary) with a sticky Place order bar. Create a coupon, apply it, and
   confirm the per-code rows and total.
5. Coupon minimum order: a below-minimum cart shows the exact required
   minimum and the current subtotal; a valid code shows its name, offer
   rate/amount, minimum (if any) and the cart's discount.
6. Coupon delete: create a throwaway code, delete it (confirmation), and
   confirm it disappears; apply a code to an order, then try deleting it —
   the snackbar must say to deactivate it instead.
7. Coupon archive: create a code with a past end date (or switch a live
   code off) → it leaves the main Coupons section and appears under
   **Archived**; the archive screen has no switch or delete control.
8. Leave a pending QR order untouched: the Orders list shows "Awaiting
   payment". `expire_unpaid_qr_orders()` cancels it after 60 minutes and
   restores stock; a verified QR order is never cancelled.
9. The QR screen offers Save image (Files/Downloads) and Share (native
   share sheet).

## 7. Known gaps / deferred (do not build unasked)

- End-to-end admin sale creation + banner upload is not runtime-verified
  after the null-cast hardening; capture the debug stack before changing
  more code. If the error names a String field, check the installed build
  and the hosted schema before adding more defaults.
- ~~The old fixed-value coupons must be recreated.~~ Corrected in place on
  2026-11-03 (`200`/`200`/`1200`/`5000` minor units).
- Banner behavior was not changed in this pass; only the sale-write
  orphan-image cleanup was added.
- No per-sale reporting; `order_coupons` is write-only bookkeeping.
- Admin product lists show base price only (no effective-price column).
- Multi-code stacking follows the assignment sequence (codes sum, capped
  at the sale-applied subtotal); per-customer redemption limits remain a
  non-goal.
