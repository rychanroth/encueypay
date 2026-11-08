# EncueYPay — Brand System v1

**Status:** v1, authored 2026-11-08 against commit `81dc7a7`
**Owner:** brand-system (design + tech lead)
**Source of truth:** this file + `docs/brand/source/` SVG sources
**Scope:** identity core, iconography, illustration voice, photography rules, trust marks, pipeline

> The app already has a strong *system* (tokens, type, states). It has no *voice*.
> This document supplies the voice, and the minimum assets that carry it.

---

## 1. Positioning

**The exact storefront.**

One trusted seller. Server-priced totals. KHQR-first payment with a real verification state. Honest fulfillment — no invented courier, ETA, or warranty.

**Promise:** the price, the stock, and the status you see are the real ones.

**Audience:** Cambodian shoppers on Android-first devices, sometimes on slow networks, paying by KHQR or cash on delivery.

## 2. Personality

| We are | We are not |
|---|---|
| Trustworthy | Corporate / bank-sterile |
| Precise | Fussy or technical |
| Warm | Cute or playful |
| Calm | Hype-driven |
| Local | Generic global marketplace |

If a design decision is unclear, choose the option that makes the number, the status, or the next step **more legible**.

## 3. Voice

- Plain, specific, short. "Payment received." not "Woohoo! You're all set!"
- Numbers are exact and never rounded in copy.
- Errors say **what happened** and **what to do next**. One sentence each.
- No exclamation marks. No emoji in product UI.
- Khmer and English are peers; never bake copy into images.

## 4. Logo system

### 4.1 The mark — "The Ledger E"

A 64×64 rounded tile (r16) in **Royal `#1E3A8A`**, containing three white bars that form an **E**, with the middle bar shortened and a light-blue dot at its right. The dot is the "entry" — a recorded transaction.

- Reads at 24dp.
- One color family (royal + white + blue-300 accent).
- No gradients, no shadows, no rotation.
- Source: `docs/brand/source/mark.svg`

### 4.2 The wordmark is **type, not an image**

"EncueYPay" set in **Plus Jakarta Sans ExtraBold**, tracking **−3%**, navy `#0F172A`.

This is a deliberate engineering decision: the font is already bundled, so the wordmark stays crisp at every size and costs **zero asset bytes**. Do not ship a PNG wordmark.

### 4.3 Lockups

| Lockup | Construction | Use |
|---|---|---|
| **Primary horizontal** | Mark 64 + 16 gap + wordmark 40 | AppBar-adjacent brand moments, login, About |
| **Stacked** | Mark 72 centered above wordmark 32, 12 gap | Splash, empty states, print |
| **Mark only** | Tile 24–64 | App icon, favicon, avatar, tight chrome |

### 4.4 Clear space and minimums

- Clear space: **0.5 × mark height** on all sides. Nothing enters it — no text, no border, no image edge.
- Minimum sizes: horizontal lockup **96dp** wide; mark **24dp**; below 24dp use the tile without the dot.
- Alignment: mark is optically centered against the wordmark's cap height, not its bounding box.

### 4.5 Logo don'ts

- Don't recolor the mark outside the approved palette.
- Don't stretch, rotate, outline, or add a shadow.
- Don't place the mark on a busy photo without a solid plate.
- Don't recreate the KHQR/Bakong mark in the logo's style.
- Don't use the mark as a generic icon (e.g., a button glyph).

## 5. Color roles

| Role | Token | Rule |
|---|---|---|
| Action | `primaryRoyal` `#1E3A8A` | Primary CTAs, active states, links |
| Ink | `primaryNavy` `#0F172A` | Headlines, body on light |
| Verified / paid | `accentEmerald` `#059669` | Only for confirmed success |
| Pending / warning | `accentAmber` `#D97706` | Only for waiting states |
| Error / cancelled | `accentRose` `#E11D48` | Errors, destructive actions |
| Promotion | `promotionCoral` `#FF5722` | Sales, coupons, flash — **never** chrome |
| KHQR | `khqrRed` `#D32027` | Official KHQR/Bakong chrome only |
| COD | `codAccent` `#0F766E` | Cash-on-delivery accents |

**Rule:** if a color is semantic, it may not be decorative. Promo coral on a normal button is a bug.

## 6. Typography

Unchanged from the app: Plus Jakarta Sans, 400/500/600/700/800, the 13-step scale in `Type/*`.

- Display and headlines: tracking tight (−0.4 to −0.8).
- Prices: `priceHighlight`, tabular figures, integer minor units.
- Never use more than three sizes in one card.
- Never center-align body copy longer than two lines.

## 7. Iconography

- **One family:** Material Symbols in design; Material Icons at runtime (already bundled).
- **Sizes:** 16 / 20 / 24 / 36 / 48. Navigation 24, badges 12–14, hero 56–72.
- **Weight:** outlined by default; filled only for selected/active.
- **Stroke:** follow the family; never mix rounded, outlined, and filled in one view.
- **Labels:** every icon-only action gets a tooltip and a semantics label.
- **Domain icons:** only where Material genuinely lacks one (KHQR, COD). Do not invent duplicates of existing glyphs.

**No new icon package.** Adopting Material Symbols at runtime is a font + pubspec change and needs approval.

## 8. Illustration — "ledger line"

A single, calm line-art voice used for empty, error, and success states.

| Property | Rule |
|---|---|
| Canvas | 160×160 viewBox, rendered 72–120dp |
| Stroke | 4px at 160 (≈2.5dp at 100dp), round caps and joins |
| Fill | none, except one small accent shape |
| Ink | `#0F172A` |
| Accent | one only: royal for neutral, emerald for success, rose for error |
| Background | transparent — must read on `#F8FAFC` and `#090D16` |
| Text | never baked in |
| Faces / people | never |
| Gradients | never |
| Motif | a dashed baseline at y=132 on empty/neutral states |

**Inventory (v1):** empty cart, no orders, empty wishlist, no search results, no notifications, no addresses, no products, offline, error, verified, order placed.

Every illustration ships a **light and dark export**. `AppIllustration.resolve(brightness)` picks the right file at build time; there are no runtime color filters. Source: `docs/brand/source/illustrations/` (with `dark/` mirrors).

## 9. Photography

- Product: square 1200, one consistent background, no collage, no text overlay.
- Banner: 1600×600, text-safe left third.
- Category: 800×600, consistent background.
- Brand: 512×512 on transparent or white.
- Avatar: square, face-safe crop.
- Format: WebP, budgets in `Assets Checklist — EncueYPay`.

**Rule:** the catalog is the product. Bad photos cannot be rescued by good UI.

## 10. Trust marks

- KHQR/Bakong: **official file only**, unchanged. Never redraw, recolor, or restyle.
- PayWay: only if the merchant agreement permits the mark.
- COD: our own teal badge is allowed.
- Verified: emerald check from the illustration set.

## 11. Motion

Code-driven, token-timed (`AppMotion`). No video or Lottie asset for v1. The verified state, add-to-cart, and QR scan are all achievable with Flutter animations.

## 12. Pipeline and governance

```
docs/brand/source/*.svg          ← vector source of truth
        │  export (build step, not runtime)
        ▼
assets/brand/<name>.png          ← 1x
assets/brand/2.0x/<name>.png     ← 2x
assets/brand/3.0x/<name>.png     ← 3x
```

- **No `flutter_svg`** in v1: it is an unapproved dependency. Ship PNG exports for raster surfaces; use `CustomPainter` the first time the mark needs to animate.
- The **wordmark stays `Text`** with the bundled font — no export.
- Naming: `mark.png`, `app_icon.png`, `illustration_empty_cart.png`.
- Every third-party mark gets a license note next to the file.
- Delete orphans; one owner; no duplicate icon families.
- New assets ≤ 2MB total.

## 13. Asset inventory

| Asset | Source | Status |
|---|---|---|
| Mark | `source/mark.svg` | ✅ v1 |
| App icon (full bleed) | `source/app-icon.svg` | ✅ v1 |
| Android adaptive foreground | `source/app-icon-foreground.svg` | ✅ v1 |
| Wordmark | type (Plus Jakarta Sans ExtraBold) | ✅ rule defined |
| Illustrations (9) | `source/illustrations/*.svg` | ✅ v1 |
| KHQR/Bakong mark | official file required | ⛔ blocked on official asset |
| PayWay mark | merchant agreement required | ⛔ blocked |
| Product/banner photography | content pipeline | ⛔ not a design asset |

## 14. Definition of done for an asset

An asset ships only when it has: a vector source, a named export, correct density variants, a light/dark check, a license note, and a place in the UI. Otherwise it is a draft, not an asset.
