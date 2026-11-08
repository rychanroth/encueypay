# Components — Figma build spec

> Generated from `docs/figma/spec/components.json` at commit `81dc7a7`. Edit the JSON, then regenerate this file; do not hand-edit the markdown.

**Figma page:** `02 · Components` · **Components:** 19

## Build rules

- **buildOrder:** Foundations → this page → screens. Screens may only contain instances, never detached copies.
- **naming:** Component names are exact strings from this file. Variant property names are Title Case.
- **tokensOnly:** Every fill, stroke, radius, padding and text style binds to a variable/style from tokens.json.
- **stateCoverage:** A component is done when every axis combination listed here exists and is named.

## Index

| # | Component | Kind | Variant axes | Code |
|---:|---|---|---|---|
| 1 | `Button` | COMPONENT_SET | Variant × State | `lib/core/presentation/widgets/encue_button.dart` |
| 2 | `Button/Filled (theme recipe)` | THEME_RECIPE | State | `lib/core/presentation/theme/app_theme.dart` |
| 3 | `Card` | COMPONENT_SET | Elevation × Interaction | `lib/core/presentation/widgets/encue_card.dart` |
| 4 | `ProductCard` | COMPONENT_SET | Availability × Promo × Wishlisted × Loading | `lib/features/catalog/presentation/widgets/product_card.dart` |
| 5 | `StatusBadge` | COMPONENT_SET | Status × Density | `lib/core/presentation/widgets/status_badge.dart` |
| 6 | `KhqrCard` | COMPONENT_SET | State | `lib/core/presentation/widgets/khqr_card.dart` |
| 7 | `MonogramImage` | COMPONENT_SET | State | `lib/core/presentation/widgets/monogram_image.dart` |
| 8 | `PriceText` | COMPONENT_SET | Mode × Emphasis | `lib/core/presentation/widgets/price_text.dart` |
| 9 | `AsyncValue` | COMPONENT_SET | State | `lib/core/presentation/widgets/async_value_widget.dart` |
| 10 | `EmptyState` | COMPONENT_SET | Action | `lib/core/presentation/widgets/async_value_widget.dart` |
| 11 | `Skeleton` | COMPONENT_SET | Shape × Density | `lib/core/presentation/widgets/async_value_widget.dart` |
| 12 | `OrderStatusTimeline` | COMPONENT_SET | StageState × Terminal | `lib/features/orders/presentation/widgets/order_status_timeline.dart` |
| 13 | `OrderTrackingCard` | COMPONENT_SET | State × Detail | `lib/features/orders/presentation/widgets/order_tracking_card.dart` |
| 14 | `NavigationBar` | COMPONENT_SET | Role × State × CartBadge | `lib/core/router/branches/` |
| 15 | `AppBar` | COMPONENT_SET | Leading × Trailing | `lib/core/presentation/theme/app_theme.dart` |
| 16 | `Input` | COMPONENT_SET | Type × State | `lib/core/presentation/theme/app_theme.dart` |
| 17 | `Dialog` | COMPONENT_SET | Type | `lib/core/presentation/theme/app_theme.dart` |
| 18 | `BottomSheet` | COMPONENT_SET | Behavior × Header | `lib/core/presentation/theme/app_theme.dart` |
| 19 | `Snackbar` | COMPONENT_SET | Tone | `lib/core/presentation/theme/app_theme.dart` |

## 1. Button

- **Id:** `encue-button`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/encue_button.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Variant | Primary, Secondary, Outline, Destructive |
| State | Default, Pressed, Focused, Disabled |

**Spec**

| Key | Value |
|---|---|
| `minHeight` | 48 |
| `minWidth` | 64 |
| `radius` | r8 |
| `paddingX` | lg |
| `typography` | labelLarge |
| `iconSize` | 18 |
| `expandDefault` | yes |
| `loading` | caller-supplied spinner in place of label |

**Notes:** Primary uses color/primary + color/on-primary; destructive uses color/error. Outline uses 1dp color/outline-variant.

## 2. Button/Filled (theme recipe)

- **Id:** `filled-button-theme`
- **Kind:** `THEME_RECIPE`
- **Code:** `lib/core/presentation/theme/app_theme.dart`

**Variant axes**

| Axis | Values |
|---|---|
| State | Default, Pressed, Focused, Disabled |

**Spec**

| Key | Value |
|---|---|
| `minSize` | 64, 48 |
| `paddingX` | 24 |
| `radius` | r8 |
| `typography` | labelLarge |

**Notes:** Not a separate component: the global FilledButtonTheme equals Button/Primary. Documented so reviewers do not expect a second button family.

## 3. Card

- **Id:** `encue-card`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/encue_card.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Elevation | Flat, Elevated |
| Interaction | Static, Tappable, LongPressable |

**Spec**

| Key | Value |
|---|---|
| `radius` | r16 |
| `border` | 1dp color/outline-variant |
| `padding` | md |
| `elevatedShadow` | level1 |

**Notes:** Dark mode stays flat even for Elevated (shadow reads as mud on obsidian).

## 4. ProductCard

- **Id:** `product-card`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/features/catalog/presentation/widgets/product_card.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Availability | InStock, LowStock, OutOfStock, Archived |
| Promo | None, Sale, New |
| Wishlisted | No, Yes |
| Loading | No, Yes |

**Spec**

| Key | Value |
|---|---|
| `radius` | r16 |
| `imageRatio` | 0.62 |
| `imageFill` | flex remaining height |
| `pills` | NEW, brand, availability |
| `titleStyle` | titleSmall |
| `priceStyle` | priceHighlight |
| `ratingIconSize` | 18 |
| `disabledBehavior` | remains tappable to explain unavailability |

**Notes:** Wishlist heart is a 48dp target overlaid top-right. Skeleton variant mirrors the final geometry.

## 5. StatusBadge

- **Id:** `status-badge`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/status_badge.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Status | Pending, Confirmed, Processing, Packed, Shipped, OutForDelivery, Delivered, Cancelled, Refunded, Unknown |
| Density | Default, Dense |

**Spec**

| Key | Value |
|---|---|
| `radius` | r8 |
| `typography` | labelSmall |
| `iconSize` | 12 |
| `paddingDefault` | 8, 4 |
| `paddingDense` | 6, 2 |

**Notes:** Light uses the pair verbatim. Dark derives: alphaBlend(fg @18%, surface-container-lowest) + lerp(fg, white, 0.45). The dark variants must be computed by the builder, not hand-picked.

## 6. KhqrCard

- **Id:** `khqr-card`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/khqr_card.dart`

**Variant axes**

| Axis | Values |
|---|---|
| State | PendingPayload, Ready, Verified |

**Spec**

| Key | Value |
|---|---|
| `radius` | r16 |
| `shadow` | level3 |
| `headerHeight` | 56 |
| `headerFill` | brand/khqr-red |
| `bodyFill` | brand/khqr-surface |
| `qrSize` | 220 |
| `priceStyle` | priceHighlight |
| `captionStyle` | bodySmall |

**Notes:** Red 'KHQR / BAKONG' header, merchant name, USD + KHR, 220dp QR. Payload resolves server-side; never render a fake QR.

## 7. MonogramImage

- **Id:** `monogram-image`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/monogram_image.dart`

**Variant axes**

| Axis | Values |
|---|---|
| State | Loading, Loaded, Error, Empty |

**Spec**

| Key | Value |
|---|---|
| `deterministicAccentPair` | derived from entity name hash |
| `initials` | first letters of name |
| `fadeMs` | 180 |

**Notes:** Represents the fallback only; Loaded is a placeholder frame where a network image would sit.

## 8. PriceText

- **Id:** `price-text`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/price_text.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Mode | UsdOnly, UsdAndKhr, Sale |
| Emphasis | Default, Highlight |

**Spec**

| Key | Value |
|---|---|
| `usdStyle` | priceHighlight |
| `khrStyle` | bodySmall |
| `khrPrefix` | ≈ |
| `peg` | 4100 KHR/USD |
| `tabularFigures` | yes |

**Notes:** Sale shows original struck through plus discounted price. Integer minor units only; never imply float math.

## 9. AsyncValue

- **Id:** `async-value`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/async_value_widget.dart`

**Variant axes**

| Axis | Values |
|---|---|
| State | Loading, Error, Data |

**Spec**

| Key | Value |
|---|---|
| `transition` | 240ms in / 200ms out cross-fade |
| `keepPriorData` | yes |
| `errorAction` | Retry |

**Notes:** Error state must preserve the page chrome (AppBar, dock); only the content slot swaps.

## 10. EmptyState

- **Id:** `empty-state`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/async_value_widget.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Action | None, Primary |

**Spec**

| Key | Value |
|---|---|
| `iconCircle` | 72 |
| `titleStyle` | titleMedium |
| `bodyStyle` | bodyMedium |
| `gap` | sm |

**Notes:** Copy comes from the screen spec; the component only owns geometry.

## 11. Skeleton

- **Id:** `skeleton`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/widgets/async_value_widget.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Shape | Block, Line, ListView, Grid |
| Density | Compact, Regular |

**Spec**

| Key | Value |
|---|---|
| `pulse` | opacity 0.45 <-> 1.0, 1200ms reverse, easeInOut |
| `radius` | r12 for blocks; matches final content shape |

**Notes:** Known gap: skeletons ignore reduced motion.

## 12. OrderStatusTimeline

- **Id:** `order-status-timeline`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/features/orders/presentation/widgets/order_status_timeline.dart`

**Variant axes**

| Axis | Values |
|---|---|
| StageState | Done, Current, Upcoming |
| Terminal | InFlight, Cancelled |

**Spec**

| Key | Value |
|---|---|
| `stages` | 7 |
| `connector` | 1dp vertical line, done segments primary |
| `currentPulse` | opacity 0.55<->1.0 + scale 0.9<->1.0, 1400ms reverse |
| `reducedMotion` | freeze at full opacity |

**Notes:** Stages: pending, confirmed, processing, packed, shipped, out_for_delivery, delivered.

## 13. OrderTrackingCard

- **Id:** `order-tracking-card`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/features/orders/presentation/widgets/order_tracking_card.dart`

**Variant axes**

| Axis | Values |
|---|---|
| State | InFlight, Delivered, Cancelled |
| Detail | Simplified, ExactStatus |

**Spec**

| Key | Value |
|---|---|
| `simplifiedStages` | Placed, Preparing, OnItsWay, Delivered |
| `toggleLabel` | exact status |

**Notes:** No courier, ETA, or fabricated tracking data anywhere in this component.

## 14. NavigationBar

- **Id:** `navigation-bar`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/router/branches/`

**Variant axes**

| Axis | Values |
|---|---|
| Role | Customer, Admin |
| State | Selected, Unselected |
| CartBadge | None, Count |

**Spec**

| Key | Value |
|---|---|
| `height` | 72 |
| `iconSize` | 24 |
| `labelStyle` | labelMedium |
| `indicator` | color/primary-container |
| `customerOrder` | Home, Discover, Cart, Orders, Profile |
| `adminOrder` | Dashboard, Products, Orders, Reports |

**Notes:** Tab order here is normative: branch order in core/router must match.

## 15. AppBar

- **Id:** `app-bar`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/theme/app_theme.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Leading | None, Back |
| Trailing | None, Action, Avatar, ActionAndAvatar |

**Spec**

| Key | Value |
|---|---|
| `height` | 56 |
| `elevation` | 0 |
| `surfaceTint` | transparent |
| `centerTitle` | no |
| `titleStyle` | titleLarge |
| `paddingX` | md |

**Notes:** Flat surface background; no tint or scroll-under elevation.

## 16. Input

- **Id:** `inputs`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/theme/app_theme.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Type | Text, Password, Search, Dropdown |
| State | Enabled, Focused, Error, Disabled |

**Spec**

| Key | Value |
|---|---|
| `radius` | r12 |
| `fill` | color/surface-container-lowest |
| `border` | 1dp color/on-surface-variant |
| `focusedBorder` | 1.6dp color/primary |
| `errorBorder` | 1.6dp color/error |
| `padding` | 16, 14 |
| `hintStyle` | bodyMedium |

**Notes:** Password includes a visibility toggle; Search includes a leading search icon and clear affordance.

## 17. Dialog

- **Id:** `dialogs`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/theme/app_theme.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Type | Default, DestructiveConfirm |

**Spec**

| Key | Value |
|---|---|
| `radius` | r24 |
| `fill` | color/surface-container-lowest |
| `barrier` | overlay/dialog-barrier |
| `titleStyle` | titleLarge |
| `bodyStyle` | bodyMedium |
| `maxWidth` | 400 |

**Notes:** Destructive confirm places the error-colored action on the right.

## 18. BottomSheet

- **Id:** `bottom-sheets`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/theme/app_theme.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Behavior | Default, ScrollControlled |
| Header | Text, TextAndHandle |

**Spec**

| Key | Value |
|---|---|
| `radiusTop` | r24 |
| `fill` | color/surface-container-lowest |
| `dragHandle` | yes |
| `safeAreaBottom` | yes |

**Notes:** Drag handle is always on. Content padding follows md; primary action sits above safe area.

## 19. Snackbar

- **Id:** `snackbar`
- **Kind:** `COMPONENT_SET`
- **Code:** `lib/core/presentation/theme/app_theme.dart`

**Variant axes**

| Axis | Values |
|---|---|
| Tone | Info, Error, Action |

**Spec**

| Key | Value |
|---|---|
| `radius` | r12 |
| `behavior` | floating |
| `fill` | color/inverse-surface in light; surface-container-dark in dark |
| `textStyle` | bodyMedium |
| `durationMs` | 6000 |

**Notes:** 6000ms matters for the foreground-push fallback; do not shorten it.

## Deferred

- **icon-set** — No SVG icon set is bundled; the app uses Material Icons. Import Material Symbols (Apache-2.0) as a separate icon component set, or render text glyphs. Do not invent custom icons.
- **charts** — Admin dashboard bars and reports use ad-hoc painted widgets, not a shared component. Model as a screen-local frame until a component exists in code.
