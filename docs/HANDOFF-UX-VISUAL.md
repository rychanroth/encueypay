# Handoff — UX / visual direction (read before any UI pass)

> Written 2026-11-02 after an audit-driven UI cleanup went too far toward
> “remove problems” and not far enough toward “make the product feel great.”
> This document is the design brief for the next session. Do not treat the
> previous audit as the design.

## 0. What happened

The last sessions executed a prioritized UX audit. That produced useful
correctness work (friendly errors, mutation-safe state, touch targets,
responsive forms), but two changes overstepped:

1. **Product detail was thinned, not redesigned.**
   `_PurchaseFacts`, `_SpecificationsHighlights`, “450+ sold”, and the VAT
   caption were deleted because they were hardcoded. That removed the
   storefront rhythm and left the page visually poorer.
2. **A `NavigationRail` was added to `AppShell`** for medium/expanded widths
   because an audit item said “the bottom bar stays on tablets.” That is a
   Material checklist decision, not a visual direction for this app.

The lesson: **UX is not the absence of defects.** It is hierarchy, rhythm,
motion, feedback, trust, and composition. Accessibility is the floor.

## 1. Design direction

Working tone:

- **Premium but warm Cambodian commerce.** Confident prices, clean cards,
  generous spacing, a little theatre — not a generic Material admin app.
- **Storefront first on product surfaces.** Image, name, price, variant,
  CTA, then honest trust. The page should feel shoppable before it feels
  informative.
- **Quiet motion.** Motion explains state changes; it does not decorate
  idly. No bouncy novelty on destructive actions.
- **Honest claims only.** Real platform facts or nothing. Never fabricate
  warranty, returns, courier, ETA, or social proof.

Use the existing token system:
`core/presentation/theme/app_colors.dart`, `app_typography.dart`,
`app_dimensions.dart`, `app_theme.dart`, plus shared widgets
(`EncueButton`, `EncueCard`, `PriceText`, `StatusBadge`, `MonogramImage`,
`AsyncValueWidget`, `EmptyStateView`).

## 2. Decisions to make first

### Navigation shell

**Recommendation: revert the rail by default.** Keep the compact bottom
`NavigationBar` as the app’s identity. If we want an expanded shell later,
design it intentionally (rail width, selected indicator, branding, content
gutters, tablet split views) rather than inheriting Material defaults.

Current file: `lib/core/router/presentation/app_shell.dart`.

### Product detail trust block

**Recommendation: restore a smaller, honest “store promises” module.**
Do not restore the deleted fake warranty/logistics/returns copy.

Use only verifiable data:

- Delivery fee from `platform_settings.delivery_fee_minor`.
- Payment methods actually supported: COD + KHQR.
- Real stock from the product/variant.
- Single-seller identity (EncueYPay) — not a fake courier.
- Product description only if present.

No ETA promise, no “7-day returns” (returns were removed), no warranty,
no “450+ sold”, no generic specs unless the backend carries them.

Visual shape: one compact card or a 2–3 row icon list with the same
card radius/outline language as the rest of the app — not a second page of
merchandising.

Current file: `lib/features/catalog/presentation/screens/product_detail_screen.dart`.

## 3. Motion language

Target feel: **fast, soft, deliberate.** One system, reused.

- Durations: 150–180ms for press/selection; 220–280ms for enter/exit;
  350–450ms only for full-screen or hero transitions.
- Easing: `Curves.easeOutCubic` for enter, `easeInCubic` for exit,
  `easeInOutCubic` for layout. Avoid `easeOutBack` except tiny badge pops.
- Always respect `MediaQuery.disableAnimations` / reduced motion.
- Prefer `AnimatedSwitcher`, `AnimatedSize`, `AnimatedContainer`,
  `FadeTransition`, `SlideTransition`, and implicit animations over
  hand-rolled controllers unless a stagger is needed.

High-value moments:

1. **Product grid entrance** — subtle staggered fade/translate as cards
   first appear (one short controller per screen, not per card loop).
2. **Skeleton → content** — skeleton shapes should match the final card
   layout; cross-fade rather than hard swap.
3. **Variant selection** — price/label/CTA cross-fade; selected chip moves
   with a short scale/elevation change.
4. **Add to cart** — button shows a brief pending state, then a
   confirmation; cart badge pops with a scale animation after server
   success. Do not optimistically mutate cart state (PRES-03).
5. **Cart line removal** — animate size/fade out; avoid an abrupt list jump.
6. **Bottom sheets** — soft enter, drag handle, content fade; respect
   reduced motion.
7. **Async states** — `AsyncValueWidget` should cross-fade loading/error/data
   instead of replacing the whole surface when possible.
8. **Order timeline** — current stage already pulses; keep it, but make it
   static under reduced motion and give the stage semantics.

## 4. Component + interaction rules

- 48dp touch targets are the floor; visual size can stay smaller.
- Every icon-only action needs a tooltip and semantics label.
- Errors stay inline or as a snackbar; never replace a form with a raw
  error screen. Mutations preserve entered state.
- Loading keeps the final layout shape (skeleton), not a centered spinner,
  on content screens.
- Empty states use `EmptyStateView` with a forward action where one exists.
- Avoid duplicate primary CTAs in one viewport.
- Use `ContentWidth` for forms/readable content on tablets; do not stretch
  fields edge-to-edge.
- Do not add platform widgets (rail, drawer, etc.) without a visual brief.

## 5. Current state of the worktree (uncommitted)

These slices are implemented but **not committed**:

- Friendly error copy + mutation-safe state (`userMessageFor`,
  `AsyncValueWidget`, checkout placement, order actions, admin stock/image
  save, platform settings).
- Checkout friction: coupon removal/re-validation, inline address route,
  totals preview decoupled from note edits, preview error notice.
- Accessibility/responsive: `ContentWidth`, 48dp targets, semantics,
  reduced-motion timeline, wrapping action/price rows, responsive report
  grid, admin row overflow menu.
- Trust cleanup: mocked product claims/specs removed, fake courier/ETA
  removed, payment labels humanized, proof upload hidden after submission.
- Login: inline error, reset-email flow, password visibility, autofill.
- Admin: inline product-form validation + focus, dialog scroll/blank-name
  validation, status-aware banner actions.
- Address: geo retry, tap-to-adjust map pin, service-vs-permission settings
  action.
- ~~Navigation rail added (see §2 — recommended revert).~~ **Reverted
  2026-11-02:** the compact bottom `NavigationBar` is the shell at every
  width again (`app_shell.dart`).
- ~~Product detail trust/spec blocks removed (see §2 — recommended redesign,
  not restore-as-was).~~ **Restored 2026-11-02:** a compact, honest
  store-promises card (real `platform_settings` delivery fee, COD + KHQR,
  single-seller identity) plus real stock; the fake warranty/returns/ETA/
  sold claims stay removed and the description now renders only when
  present.
- **Motion landed 2026-11-02/03:** shared `AppMotion` tokens; `AsyncValueWidget`
  cross-fades loading/error/data; Home + Discovery grids use one staggered
  entrance controller and a shape-matching skeleton; variant price/CTA
  cross-fade, thumbnail border animates, add-to-cart has a pending state,
  and the cart badge pops after server success. Reduced motion is honored.
  Cart lines now collapse/fade only after the server-confirmed refetch
  (`AnimatedList`); cart quantities/totals cross-fade; the checkout CTA and
  total cross-fade; the order-placed screen cross-fades QR-pending →
  verified (and QR errors) with an animated height; the quick-action sheet
  has a drag handle; timeline stages carry semantics.

Pending DB migrations from earlier slices (run together with the app):
`20261102000005_admin_delete_coupon.sql`,
`20261102000006_admin_delete_coupon_security.sql`,
`20261102000007_variant_placeholder_harmonization.sql`,
`20261102000008_avatar_storage.sql`,
`20261102000009_notification_order_link.sql`.
See `docs/HANDOFF-PROMOTIONS.md` and `docs/HANDOFF-VARIANTS.md`.

## 6. Recommended next session

Do **not** continue with more audit cleanup. Start with design.

1. ~~**Revert the rail** (or explicitly design an expanded shell).~~ Done.
2. ~~**Restore product detail composition** with the honest store-promises
   module; fix hierarchy and spacing.~~ Done (catalog reads
   `platform_settings.delivery_fee_minor` directly — approved ARCH-04-safe
   data read; verify against the hosted DB).
3. ~~**Motion pass**: grid entrance, skeleton cross-fade, variant selection,
   add-to-cart/badge, bottom-sheet enter, cart-line removal, and timing
   polish.~~ Done.
4. ~~**Cart/checkout confirmation motion** and success states.~~ Done
   (checkout CTA/total cross-fade; order-placed state cross-fade + animated
   height).
5. **Device visual QA**: screenshots on compact + expanded, light/dark,
   large text; adjust — not started (no device run in this session).

## 7. Commands

```bash
flutter analyze
flutter test
flutter run --dart-define-from-file=config/.env
```

No commits were made in these sessions. Do not assume the dirty worktree is
reviewed or safe to discard.
