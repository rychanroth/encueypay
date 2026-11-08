# Handoff — Figma mirror & brand system

**Status:** paused on an external quota; resumable
**Updated:** 2026-11-08
**Repo HEAD:** `0a8bd1e`
**Read first:** `AGENTS.md`, `docs/architecture-contract.md` §12, then this file.

---

## 0. TL;DR

**Goal:** a native Figma mirror of the Flutter app — tokens → components → 30
screens — plus a separate FigJam board for flows/data, and a brand/asset system
that is now applied in the running app.

**Done:** brand system v1, 11 illustrations (light + dark), platform icons and
splash, login lockup, empty-state wiring; in Figma: 3 pages, foundations,
brand board, Button, Card.

**Broken/paused:** `Input` and `AppBar` exist in Figma but contain wrong icon
glyphs and hug their content. The MCP fix was blocked by the Figma MCP Starter
quota before it ran.

**Next action:** install `docs/figma/plugin/` as a development plugin and run it —
it performs the same fix with **no MCP metering**. See §5.

---

## 1. Goal and locked decisions

- **Deliverable A:** Figma Design `EncueYPay — Product Spec (as-built)`.
- **Deliverable B:** FigJam `EncueYPay — Flows & Data`.
- **Fidelity:** 15 pixel-near screens, 15 wireframe. **15 / 15 split is fixed.**
- **Theme:** light-first. Dark components/screens deferred; `Color Dark`
  variables already exist.
- **Breakpoints:** compact (390×844) only. Medium/expanded deferred.
- **Icons:** Material Symbols SVGs for design; Material Icons font at runtime.
- **Brand:** wordmark is **type** (Plus Jakarta Sans ExtraBold, −3%), never a
  PNG. Mark is the "Ledger E" vector.
- **Assets:** no `flutter_svg` (unapproved). SVG source → PNG at 1x/2x/3x.
- **No new dependencies** without approval (GLOBAL-04).

---

## 2. Where everything lives

| Thing | Location |
|---|---|
| Execution plan | `docs/figma/PLAN.md` |
| Resume note | `docs/figma/RESUME.md` |
| Node/ID registry | `docs/figma/manifest.json` |
| Extracted spec | `docs/figma/spec/{tokens,components,screens,flows}.json` |
| Fix script (MCP payload, kept as record) | `docs/figma/build/p2-icons-fix.js` |
| **Local build plugin (the runnable path)** | `docs/figma/plugin/` |
| Brand system | `docs/brand/BRAND.md` |
| Brand sources | `docs/brand/source/` (mark, app icon, 11 illustrations, 18 icons) |
| Bundled assets | `assets/brand/`, `assets/illustrations/` (+ `dark/`) |
| Component markdown | `docs/figma/components.md` |
| Vault archive | `.../Agent's responses archive/` |

**Figma:**

- Design file: `sf2EOTYc8LBadE7LpIu8kR`
  → https://www.figma.com/design/sf2EOTYc8LBadE7LpIu8kR
- FigJam: `2O145eRxj0Ta11iwIMwuEH`
  → https://www.figma.com/board/2O145eRxj0Ta11iwIMwuEH
- Plan: `team::1556872439110631612` (Starter, View seat)
- Session: `3c99d509-1931-4c41-9308-5a8c0f15db0f`
- Pages: `01` = `0:1`, `02` = `2:4`, `03` = `2:5`
- Brand board: `8:82` · Button `4:34` · Card `4:53` · Input `12:94` · AppBar `12:135`

---

## 3. What is done

### App / brand

| Commit | What |
|---|---|
| `dcd9c2c` | Brand v1: mark, app icon, adaptive foreground, 9 illustrations |
| `dd33325` | Bundled assets + Android/iOS/web platform icons |
| `0c0dd49` | `EmptyStateView` illustration support; cart/orders/wishlist/notifications/discovery |
| `66ac3c7` | +`no-addresses`, `order-placed`; home/addresses/admin/error/order-placed; Android adaptive icon + splash; iOS LaunchImage |
| `3ee7b01` | `BrandLockup` + login screen |
| `0a8bd1e` | **Web support** (landed outside this session): OAuth redirect, PickedFile, conditional dart:io, local web origin. The web QA loop depends on it. |

Empty states wired: cart, orders, wishlist, notifications, discovery, home,
addresses, admin products, admin orders, `AsyncErrorView`, order placed
(QR verified + COD). All have light and dark exports.

### Figma

- 3 pages, 36+36 color variables, 13 floats, 13 text styles, 3 effect styles.
- Brand board with 11 illustrations.
- Button (16 variants), Card (6).
- 18 Material Symbols SVGs imported as vectors into `Icon/*` components.
- Input (16) at 320×56 and AppBar (8) at 390×56 — fixed and re-gridded.
- Snackbar (3), Dialog (2), BottomSheet (4) — built from `components.json`,
  token-bound, text styles linked.
- PriceText (6), StatusBadge (20), Skeleton (8), EmptyState (2), AsyncValue (3),
  MonogramImage (4) — atoms built from the Dart sources.
- KhqrCard (3), OrderStatusTimeline (6), OrderTrackingCard (6), ProductCard (48).
- NavigationBar (8, tab items) — the last set. 6 extra Material Symbols
  (`home`, `explore`, `receipt_long`, `dashboard`, `inventory_2`, `bar_chart`)
  were created in-plugin from inlined path data.

---

## 4. What is NOT done

### Figma — immediate

1. **Components complete:** 18 real sets built (plus the `filled-button-theme`
   doc-only recipe). Nothing is on the screens page yet.
2. **Screens: 0 of 30** (15 pixel, 15 wire). Page 02.
3. **FigJam: 0 of 9 diagrams** (navigation, order/payment lifecycles, auth,
   checkout, KHQR, sequences, ERD, permissions, state ownership).
4. **Material Symbols:** 24 `Icon/*` components exist (18 imported + 6 created
   in-plugin); still not grouped into a documented icon section.
5. **Code Connect** mapping — best-effort; Flutter is not an official template
   target.
6. **Motion storyboard + contracts** on page 03.

### App / platform

- Device QA: empty states in light/dark, splash, adaptive icon (can't run a
  device here).
- Desktop launcher icons (macOS/Windows/Linux) not regenerated.
- Android 12+ splash API not explicitly configured.
- iOS storyboard still has stale `168×185` metadata (harmless).

### Human blockers

- Official **KHQR/Bakong** and **PayWay** marks + usage rules.
- **Trademark clearance** and alternative logo explorations.
- **Photography** pipeline enforcement.

---

## 5. Exact resume procedure

**Step 0 — use the local plugin, not the MCP.** `use_figma` is metered against
the Figma plan (~20 calls/month on Starter) and that quota is spent. The same
Plugin API code runs unmetered as a development plugin.

Install once: open the design file in the Figma desktop app or `figma-linux`,
then **Plugins → Development → Import plugin from manifest…** →
`docs/figma/plugin/manifest.json`. Run it from **Plugins → Development →
EncueYPay Mirror**.

Loader constraints (figma-linux): flat `main` filename, no dashes, no `ui.html`,
no bundler. Already satisfied — do not regress them.

Expected toast: `P2a fix done — icons 18/18 · Input 1352x296 · AppBar 1632x136`.

**Step 1 — verify.** Screenshot `12:94` and `12:135`; expect a magnifier in
Search, an eye in Password, a chevron in Dropdown, 4-column grids.

**Step 2 — batch 2b.** Build Snackbar (3), Dialog (2), BottomSheet (4) using
`docs/figma/spec/components.json` as the source, added as a new command in the
same flat `code.js`. Same pattern: components → `combineAsVariants` → **manual
grid layout** → verify.

`build/p2-icons-fix.js` is kept as the record of the original MCP payload;
`plugin/code.js` is its runnable twin. Keep them in step, or delete the former if
it stops earning its keep.

**Step 3 — screens.** Start with the 15 pixel screens on page 02, in this order:
login, home, productDetail, cart, checkout, orderPlaced, orders, orderDetail,
profile, discovery, notifications, adminDashboard, adminProducts, adminOrders,
adminReports. Wire screens after.

**Step 4 — FigJam.** One board, 9 sections, `use_figma` only. **Do not** use
`generate_diagram` — it creates a new file per call.

**Step 5 — QA.** One screenshot per set/screen; no per-frame loops (read quota).

---

## 6. Constraints and gotchas (learned the hard way)

| Gotcha | Rule |
|---|---|
| Starter quota | All `use_figma` runs count (~20/month); only `add_code_connect_map`, `create_new_file`, `generate_figma_design`, `whoami` are exempt. **Use the local plugin** (`docs/figma/plugin/`) for building — it is not metered. |
| REST API (PAT) | Read-only for nodes — comments, variables and dev resources are the only writes. Good for inspection/exports, useless for building components or screens. |
| 1 variable mode | Light/dark is two collections (`Color`, `Color Dark`), same names. |
| 3 pages | 3 pages + sections/frames inside. |
| Font codepoints | Figma's "Material Icons" ≠ Flutter's bundled font. `0xE567` is `search` in Flutter, `add_location` in Figma. **Never use glyph text**; use SVG symbols. |
| `combineAsVariants` | Does not lay out variants; they stack at (0,0). Grid them manually. |
| Auto-layout sizing | Enabling `layoutMode` makes the frame HUG. Set `layoutSizingHorizontal = "FIXED"` and `resize()` after building children. |
| Page context | Resets to page 1 each `use_figma` call; call `figma.setCurrentPageAsync` once. |
| `setPluginData` | Banned by the tool contract. Use names + `manifest.json`. |
| `generate_figma_design` | Quota-exempt but has no URL param; needs a capture script/browser integration we don't have here. |
| `generate_diagram` | Creates a new file per call — unusable under the 3-file cap. |
| No `flutter_svg` | Ship PNG density variants; wordmark stays `Text`; mark can become a `CustomPainter`. |
| Dark mode | v1 is light-first, but the app has a dark toggle; illustrations ship dark variants. |

---

## 7. Verification commands

```bash
flutter analyze
flutter test                     # 49 tests
python3 -c "import json,glob; [json.load(open(p)) for p in glob.glob('docs/figma/spec/*.json')]"
```

**Visual QA without a device** (works because of `0a8bd1e`):

```bash
flutter build web --dart-define-from-file=config/.remote
python3 -m http.server 8080 --directory build/web &
chromium --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
  --window-size=390,844 --virtual-time-budget=12000 \
  --screenshot=/tmp/opencode/login.png http://127.0.0.1:8080/
```

Authenticated screens still need a real session; only login is reachable
without credentials.

---

## 8. Commit ledger (this effort)

```
0a8bd1e feat(web): make Google sign-in and the app build work on web   ← external
5139062 docs(figma): record P2a partial build and MCP quota block
3ee7b01 feat(auth): apply the brand lockup on login
66ac3c7 feat(ui): complete illustration coverage and platform icons
0c0dd49 feat(ui): use ledger-line illustrations in empty states
dd33325 feat(brand): bundle identity assets and regenerate platform icons
dcd9c2c feat(brand): add identity v1 and import assets into Figma
5d27f9a docs(figma): lock v1 decisions and log component pilot
84c5183 docs(figma): record P0/P1 and Starter plan constraints
2fe313e docs(figma): add markdown rendering of the component spec
278e1cd docs(figma): extract design spec and phased Figma plan
```

---

## 9. First message for a fresh session

> Read `docs/HANDOFF-FIGMA.md` and `docs/figma/RESUME.md`. Resume at §5 Step 0.
> The Figma file is mid-operation: run the local plugin in `docs/figma/plugin/`
> (Plugins → Development → EncueYPay Mirror) before building anything else. Do not
> use font glyphs for icons, and do not route builds through the metered MCP.
