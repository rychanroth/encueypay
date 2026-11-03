# Handoff — product variants & the single-price placeholder

Read before touching `product_variants`, the admin product form, or catalog
pricing. Decision 2026-11-02: **explicit in the DB, implicit in the UI.**

## Model

- Every product keeps at least one **active variant** so cart/order lines
  (`product_variant_id NOT NULL`) always resolve.
- A null-price variant is the **single-price placeholder**, not a selectable
  option. It tracks `products.base_price_minor`.
- **Single-price product** = exactly one active null-price placeholder.
  Admin sees only an editable Price; customer sees no variant picker.
- **Option-pricing product** = active set contains priced variants. The
  placeholder is hidden from admin and customer, and the base/from price is
  the cheapest priced variant.
- Archived variants stay in the table forever (order history references).

## Server (`20261102000007_variant_placeholder_harmonization.sql`)

- Backfills `Default` only for products with **zero active variants** — never
  onto products that already have real variants.
- Archives duplicate active placeholders, then enforces one with a partial
  unique index (`product_id WHERE status='active' AND price_minor IS NULL`).
- `admin_update_product`:
  - `p_variants = '[]'` → single-price mode: keep/create one placeholder,
    archive every active priced variant.
  - non-empty → every row requires name + price; sync in place; archive rows
    and the placeholder that are absent; derive `base_price_minor` from the
    cheapest payload price.
  - `p_variants = NULL` → untouched (back-compat).
- `seed.sql` now inserts `Default` only after the priced seed variants, and
  only for products still without an active variant.

## Client

- `ProductDtoX` filters archived variants and drops the placeholder when any
  priced variant exists; `fromPriceMinor`/`defaultVariantId` come from that
  visible set. Default = cheapest, id tie-break.
- Catalog list select includes `product_variants.status`; detail returns the
  same visible set; wishlist mirrors the rule in its own mapper
  (`ARCH-04` — no cross-feature import).
- Admin repository exposes only active priced variants (and derives the list
  base price); `variantCount == 0` renders “Single price”.
- Admin form hides the placeholder. No active rows = single-price (editable
  Price). Rows = option pricing (base hidden/derived). Archiving the last
  variant asks to confirm the switch back to single price.

## Remaining steps

1. `supabase db push` (migration `20261102000007`) together with the app
   build. Older builds still send the null-price `Default` row in the
   variant payload; the new RPC rejects that with “Variant price is
   required”, so don't leave the old client pointed at the new function.
2. Verify on the hosted project:
   - Dyson: customer no longer sees a `Default` option; from/default becomes
     the cheapest real variant (45000), not the old base 40000.
   - Editing Dyson hides `Default`; saving archives it.
   - A single-price product shows Price only; adding a variant switches the
     form; archiving the last variant warns and converts back.
   - New product with no variants, and existing products with only a named
     real variant (Nike/Croptop/ghffy) render/form correctly.
3. Carts holding an archived/retired variant are rejected at checkout — this
   is the existing archived-variant rule, not a new failure path.

## Tests

`test/product_variant_visibility_test.dart` pins placeholder-only,
placeholder+real, archived exclusion, real-only, tie-break, and the wishlist
mirror. `flutter analyze` + `flutter test` pass.
