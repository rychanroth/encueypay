# Handoff — explicit product variants

Read before touching `product_variants`, the admin product form, or catalog
pricing. Decision 2026-11-03: **explicit variants only — no silent Default
logic.**

## Model

- Every product has at least **one explicit variant**. A variant has a name
  and a real price (`price_minor NOT NULL`).
- A variant named `Default` is just a normal, business-authored row. The app
  never creates, hides, or archives it implicitly; the business can name one
  `Default` if it wants.
- Archived variants stay in the table forever for order history; the client
  never shows them.
- `products.base_price_minor` is a **server-derived cache** of
  `min(active variant price)`. It exists only for server-side price sorting
  and admin analytics. It is never an admin input and never a pricing
  fallback.
- Cart/checkout/order pricing uses `product_variants.price_minor` directly.

## Server (`20261103000001_explicit_variants.sql`)

- Backfills legacy null prices from `products.base_price_minor`, then makes
  `price_minor NOT NULL`.
- Drops the null-price placeholder index.
- `admin_create_product`: requires a non-empty variant list; inserts every
  authored variant; derives the cached base from the cheapest row; no
  implicit Default.
- `admin_update_product`: a supplied variant list must be non-empty; syncs
  rows in place, inserts new rows, archives active rows absent from the
  payload, and recomputes the cached base. No placeholder creation/archiving.
  `p_variants = NULL` leaves variants and the cache untouched.
- `cart_item_details`, `validate_coupon`, `preview_order_totals`, and
  `create_order_from_cart` no longer coalesce variant price with the base.
- The admin RPC signatures no longer take `p_base_price_minor`.

## Client

- Admin form: no separate Price field and no single-price mode. A new
  product starts with one blank variant row; saving requires at least one
  complete variant. Existing active rows (including an explicit `Default`)
  are shown and editable.
- Admin repository/draft: no base-price input; summaries derive the from
  price from the cheapest active variant.
- Catalog/wishlist: active variants only; `fromPriceMinor` is the cheapest
  active price; `defaultVariantId` is the cheapest active variant.
- `ProductVariant.priceMinor` is non-null; the old placeholder filtering and
  base fallbacks are gone.

## State (2026-11-03)

- Local **and hosted** databases were reset to replay all migrations + seed.
- Hosted has 8 seed products, 10 explicit variants, zero null prices, and
  zero products without an active variant; every cached base equals its
  cheapest active variant.
- Hosted auth users were wiped by the reset. The demo admin was recreated:
  `admin@demo.local` / `Admin123!` (change the password).
- Coupons, sales, banners, orders, and carts were wiped; re-author them in
  the admin UI.
- Platform settings were re-applied (`delivery_fee_minor = 250`,
  `payment_account = demo-payment-desk`).

## Remaining

1. Device/UI smoke: admin create/edit with one variant, adding a second,
   archiving it, and confirming the `Default` row stays manageable.
2. Recreate sales/coupons/banners and run the promotions verification pass.

## Tests

`test/product_variant_visibility_test.dart` now pins active-only visibility,
cheapest selection, archived exclusion, tie-break, and the wishlist mirror.
