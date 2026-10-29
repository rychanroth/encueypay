# HANDOFF — Promotions, Coupons & Banners (campaign system)

> Session of 2026-10-28, branch `impl/mvp`. Written for the next agent/session:
> read this before touching `promotions`, `coupons`, or `banners`.
> Kept as a permanent doc next to `docs/HANDOFF-KHQR.md`; when the feature is
> fully verified and done, promote its durable lessons into the contract and
> delete this file (per AGENTS.md Feature State Index).

## 0. State right now (start here)

- **Code**: everything below is committed through `ba87104`; `flutter analyze`
  is clean; local stack verified via SQL smoke tests.
- **Pending user action**: `supabase db push` — THREE migrations are unpushed:
  `20261028000003_variant_flow.sql` (variants),
  `20261028000004_campaign_banners.sql` (this feature), and
  `20261029000001_drop_stale_rpc_overloads.sql` (drops the pre-variant
  `admin_update_product` and the 6-target-arg `admin_create_banner`
  overloads — CREATE OR REPLACE with a different signature added them
  instead of replacing, and PostgREST then failed every
  `admin_create_banner` call with "Could not choose the best candidate
  function"). All three are
  CREATE-OR-REPLACE/ADD-COLUMN safe; re-running push is harmless. The user
  already pushed `20261028000001` (users backfill) and `20261028000002`
  (dashboard/report visuals) — their push output shows a scary but harmless
  `pg-delta` catalog-cache warning after "Applying migration …"; it does not
  roll anything back.
- **Uncommitted in the tree**: `supabase/snippets/Untitled query 163.sql` is
  the USER'S own edit — leave it alone.
- Related fixes from the same session (not promotions, but done alongside):
  review route shadowing (`d6be6f5`), reviewed-state on order detail
  (`9f67f79`), product-detail decluttering, one-tap location + verification
  map (`f27f9af`, `4a08b62`, `8e65198`), variant flow (`90c53dc`).

## 1. The model (what a "campaign" is)

Option A, user decision 2026-10-28. Three rows that now form one story:

- **`promotions`** — the rule: `scope` (`'platform' | 'brand'`), `brand_id`,
  `discount_type` (`'fixed' | 'percent'`), `discount_value`, `active` (kill
  switch). Windows live ONLY on coupons (the promotions table has no window
  columns). Legacy `banner_image_path`/`banner_status` columns **dropped**.
- **`coupons`** — the instrument: `code`, window, `min_order_amount_minor`,
  `active`, and the new **`auto_apply boolean`** (campaign coupons true;
  code-only coupons from `create_platform_promotion` stay false — those are
  for out-of-band code distribution).
- **`banners`** — the advertisement: `promotion_id` (set for campaigns;
  NULL = inert display-only banner), image in the `promo_assets` bucket
  (full public URL stored, passthrough convention). `target_kind/target_id/
  target_name` **dropped** — the Discovery target is DERIVED at read time
  from the bound promotion's scope.

Deep-link contract: brand scope → Discovery filtered to that brand;
platform scope → the full Discovery feed (nothing to filter — documented
caveat: the feed is unfiltered, the discount still applies cart-wide).

**Stacking rule** (user decision): at placement, the single best eligible
`auto_apply` coupon is added automatically; manually entered codes stack on
top; everything sums and caps at the subtotal.

## 2. Server surface (migration `20261028000004_campaign_banners.sql`)

- `admin_create_campaign(p_name, p_description, p_image_path, p_discount_type,
  p_discount_value, p_min_order_amount_minor, p_starts_at, p_ends_at,
  p_brand_id) RETURNS jsonb` — one atomic call: promotion + `auto_apply`
  coupon (code generated `CAMP-XXXXXXXX`) + banner (`status='approved'`,
  single-admin so campaigns go live immediately; `moderate_banner` still
  exists for reject/disable later). Validates brand existence, positive
  discount, percent ≤ 100. Returns `{promotion_id, coupon_id, coupon_code,
  banner_id, scope}`.
- `create_order_from_cart` **restated**: after the user-code loop, an
  auto-apply block picks the best eligible `auto_apply` coupon (excludes
  codes already redeemed manually) into `_coupon_discounts` with `auto=true`;
  `order_coupons.auto_applied` records attribution. Temp-table drops are
  **`pg_temp`-qualified** — the function's `search_path = public` made an
  unqualified `drop table if exists` miss the temp table on a second
  same-transaction call (pre-existing latent bug, fixed here).
- `preview_cart_discounts(p_codes text[])` — same selection as placement
  (must never drift): returns `{manual: [{code, discount_minor}],
  auto: {code, name, scope, discount_minor} | null, total_discount_minor}`.
  STABLE, SECURITY DEFINER.
- `admin_set_promotion_active(p_promotion_id, p_active)` — the promotion
  kill switch (only the per-coupon toggle existed before).
- `admin_create_banner` restated → display-only (no target parameters).
- **RLS fix**: `promotions` had NO public SELECT (admin/creator only) —
  every customer-side promotion query returned empty while the SECURITY
  DEFINER discount RPCs kept working. `promotions_public_read … USING
  (true)` added; writes stay admin/creator-only. This is what unblocked the
  product-card discount chips and coupon visibility for customers.

## 3. Client surface (files)

- `features/promotions/presentation/screens/admin_promotions_screen.dart`:
  "New campaign" dialog (image, scope → conditional brand picker, discount,
  min order, window) + promotion kill-switch Switch on each coupon card +
  "New display banner" (inert). Both dialogs **await
  `ref.read(provider.future)` BEFORE `showDialog`** — see bug §4.3.
- `features/promotions/data/repository/promotions_repository_impl.dart` +
  interface + `admin_promotions_controller.dart`: `createCampaign` (uploads
  the image to `promo_assets`, passes the public URL as `p_image_path`,
  returns the generated coupon code), `setPromotionActive`, display-only
  `createBanner` (no target params).
- `features/catalog/data/repository/catalog_repository_impl.dart`
  (`fetchApprovedBanners`): embeds `promotions(scope, brand_id,
  brands(name))` and derives `CatalogBannerTarget` — `brand` (targetId =
  brand_id, targetName = brands.name), new `platform` value (full feed), or
  `none` for display-only rows.
- `features/catalog/presentation/screens/home_screen.dart`: banner onTap
  switch gains the platform case → plain Discovery deep-link (name/image
  query params only, so the context banner still shows).
- `features/checkout/`: `DiscountPreview` entity (new),
  `previewCartDiscounts` (repo + interface),
  `discount_preview_provider.dart` (watches the checkout controller's valid
  codes → calls the preview RPC — it watches the WHOLE controller, so it
  refetches on any checkout emit; acceptable, RPC is cheap), and the summary
  rows in `checkout_screen.dart` (Auto-applied row + manual-codes row +
  preview-based total). `CouponPreview` gained `scope` — the applied-coupon
  tile's badge now reads "Brand" / "Platform-wide" instead of the dead
  `'Scope'` stub.

## 4. Bugs found & fixed this session (root causes — don't rediscover)

1. **Promotions RLS gap** (§2 last bullet): customers saw zero promotions —
   the chips, banner derivation, and coupon discovery were all dead while
   the discount math worked (SECURITY DEFINER bypasses RLS). If promo data
   ever looks empty for customers again, check `pg_policies` on
   `promotions` first.
2. **Buffering dialog pickers**: `ref.read(asyncProvider)` captured before
   `showDialog` freezes an `AsyncLoading` snapshot — autoDispose providers
   with no listener never update the dialog. Pattern fix: await
   `ref.read(provider.future)` BEFORE the dialog, pass plain lists. Applied
   to the coupon scope dropdown + banner/campaign destination pickers. Do
   not reintroduce `ref.read` snapshots in dialogs.
3. **`pg_temp` drop-guard** (§2): qualify temp-table drops inside SECURITY
   DEFINER functions whose search_path replaces the implicit temp-first
   lookup.
4. **seed.sql vs migrations drift**: the seed referenced the dropped
   `product_variants.attributes` column and broke `db reset`. Seed and
   migrations must move together — when a migration drops a column, patch
   the seed in the same slice.

## 5. Design decisions (settled — do not re-litigate without the user)

- **Hybrid variant pricing** (variants slice): authored variants require
  name + price + image; the auto-'Default' variant keeps a NULL price that
  tracks the product base price permanently.
- **Option A campaigns**: banners are promotion-bound; scope-derived
  targets; campaign coupons auto-apply.
- **Stacking**: best auto + manual codes, sum capped at subtotal.
- **Banners live immediately** on campaign creation (single-admin;
  moderation actions remain for reject/disable — a rejected banner never
  affects its coupon: advertising and validity are independent).
- `promotions_public_read` USING(true) is intentional (all promotion data
  is customer-facing); writes stay gated.

## 6. Verification checklist (user, after `supabase db push`)

1. Admin → Promotions → "New campaign" (campaign icon in the app bar):
   image + name + scope (+brand) + discount → creates promotion, coupon,
   approved banner; snackbar shows the generated `CAMP-…` code.
2. Home strip shows the banner → tap → brand-filtered feed (or full feed
   for platform scope) with "10% OFF"-style chips on in-scope cards.
3. Checkout summary shows "Auto-applied (<campaign>) — −$X" with no code
   entry; entering the campaign's own code manually must not double-apply.
4. The promotion Switch on each coupon card kills the chip + auto-apply.
5. Display-only banner: Home renders it inert.

## 7. Known gaps / deferred (do not build unasked)

- No per-customer redemption limits; `order_coupons` has no code column
  (only coupon_id + discount + auto_applied).
- Platform-scope banners deep-link to the unfiltered feed (documented
  caveat); a curated category target for platform campaigns would be a
  one-field addition.
- Cart screen does not preview coupon discounts (checkout step 5 + summary
  do; cart has an explicit comment deferring to checkout).
- Multi-code-per-promotion remains a recorded non-goal (spec B.5).
- `promotions.active` toggling is wired (admin_set_promotion_active); the
  promo chip + auto-apply respect it. Banner moderation (approve/reject/
  disable) applies only to the banner strip.
