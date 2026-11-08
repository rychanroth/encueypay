# Handoff — Figma mirror & brand system

**Status:** built; **frozen as a snapshot** (see §1). One rebuild pass still pending.
**Updated:** 2026-11-08
**Repo HEAD:** `11adafd` (sizing fix, wire rewrite, page 03 and the audit batch are in it)
**Read first:** `AGENTS.md`, `docs/architecture-contract.md` §12, then this file.

---

## 0. TL;DR

**Goal:** a Figma projection of the Flutter app — tokens → components → 30 screens —
plus a FigJam board for flows/data, driven by a local development plugin instead of
the metered Figma MCP.

**Done:** brand system v1 (in the app); in Figma: 3 pages, foundations, brand board,
**18 component sets**, **30 screens** (15 pixel + 15 wire), **9 FigJam diagrams**,
page 03 motion/contracts. Two local plugins run it all unmetered.

**Pending:** one rebuild pass after two project-wide fixes (see §4a), then the
`audit-screens` report. Nothing else is planned.

**Next action:** run the batches in §5 Step 1, then `Audit · screens`.

---

## 1. Goal and locked decisions

- **Deliverable A:** Figma Design `EncueYPay — Product Spec (as-built)`.
- **Deliverable B:** FigJam `EncueYPay — Flows & Data`.
- **Fidelity:** 15 pixel-near screens, 15 wireframe. **15 / 15 split is fixed.**
- **Theme:** light-first. Dark components/screens deferred; `Color Dark`
  variables exist.
- **Breakpoints:** compact (390×844) only. Medium/expanded deferred.
- **Icons:** Material Symbols SVGs for design; Material Icons font at runtime.
- **Brand:** wordmark is **type** (Plus Jakarta Sans ExtraBold, −3%), never a PNG.
  Mark is the "Ledger E" vector.
- **Assets:** no `flutter_svg` (unapproved). SVG source → PNG at 1x/2x/3x.
- **No new dependencies** without approval (GLOBAL-04).

### Decisions added 2026-11-08 (after the mirror was built)

- **Figma is a snapshot, not a twin.** Code + `docs/architecture-contract.md` are
  authoritative; this file is a projection pinned to a commit. Do not restart a
  standing mirror for future features — add a frame only if someone needs it.
- **No per-state screens.** The canonical `loaded` state exists for all 30; the
  ~90 state variants in `screens.json` are declined as diminishing returns.
- **No Code Connect.** Flutter has no official parser target; the mapping would be
  a node→path record, not a sync.
- **Demo input comes from the app, not from Figma.** Screenshots / recording of the
  running web build are complete by construction and cost nothing to regenerate.
  Remotion consumes those, not the board.
- **Known and accepted defect:** screen content is region-accurate but incomplete
  (missing widgets). See §4b for the cause and the only two remedies.

---

## 2. Where everything lives

| Thing | Location |
|---|---|
| Execution plan | `docs/figma/PLAN.md` |
| Resume note | `docs/figma/RESUME.md` |
| Node/ID registry | `docs/figma/manifest.json` |
| Extracted spec | `docs/figma/spec/{tokens,components,screens,flows}.json` |
| **Design plugin (runnable path)** | `docs/figma/plugin/` — 13 batches |
| **FigJam plugin** | `docs/figma/plugin-figjam/` — 3 batches |
| Original MCP payload (record only) | `docs/figma/build/p2-icons-fix.js` |
| Brand system | `docs/brand/BRAND.md` |
| Brand sources | `docs/brand/source/` (mark, app icon, 11 illustrations, 18 icons) |
| Bundled assets | `assets/brand/`, `assets/illustrations/` (+ `dark/`) |
| Component markdown | `docs/figma/components.md` |
| Workflow/SSOT conclusions | vault: `Agent's responses archive/Design handoff — Figma, MCP, Remotion, and single source of truth.md` |

**Figma:**

- Design file: `sf2EOTYc8LBadE7LpIu8kR`
  → https://www.figma.com/design/sf2EOTYc8LBadE7LpIu8kR
- FigJam: `2O145eRxj0Ta11iwIMwuEH`
  → https://www.figma.com/board/2O145eRxj0Ta11iwIMwuEH
- Plan: `team::1556872439110631612` (Starter, View seat)
- Pages: `01` = `0:1`, `02` = `2:4`, `03` = `2:5`

---

## 3. What is done

### Figma — page 01 (18 sets, all of `components.json`)

Button 16 · Card 6 · Input 16 · AppBar 8 · Snackbar 3 · Dialog 2 · BottomSheet 4 ·
PriceText 6 · StatusBadge 20 · Skeleton 8 · EmptyState 2 · AsyncValue 3 ·
MonogramImage 4 · KhqrCard 3 · OrderStatusTimeline 6 · OrderTrackingCard 6 ·
ProductCard 48 · NavigationBar 8.

24 `Icon/*` components: 18 imported Material Symbols + 6 created in-plugin from
inlined path data (`home`, `explore`, `receipt_long`, `dashboard`, `inventory_2`,
`bar_chart`). Sets live top-level below AppBar; there is no `S · Components`
section, so locate by name.

### Figma — page 02 (30 screens)

- Pixel (15): login, home, productDetail, cart, discovery, notifications, checkout,
  orderPlaced, orders, orderDetail, profile, adminDashboard, adminProducts,
  adminOrders, adminReports.
- Wire (15): reviewCompose, profileEdit, addresses, addressEdit, wishlist, settings,
  notFound, adminProductForm, adminBrands, adminCategories, adminPromotions,
  adminArchivedCoupons, adminAudit, adminSettings, adminOrderDetail.

Sections: `S · Customer`, `S · Admin`. Frame names: `Screen/<route>/<state>`.

### Figma — page 03

Motion tokens (durations, curves, reduced-motion), a 4-step storyboard, and the
cross-cutting contracts.

### FigJam — 9 diagrams

Navigation, order lifecycle, payment lifecycle, auth sequence, checkout sequence,
KHQR sequence, ERD (22 entities / 23 relations), permission matrix, state ownership.
Drawn as titled panels rather than sections, so each exports self-describing.

### Tooling

- `docs/figma/plugin/` — 13 batches, UI, per-variant logging, warnings, rebuild by
  `node docs/figma/plugin/build.js`.
- `docs/figma/plugin-figjam/` — separate plugin (`editorType: ["figjam"]`), 3 batches.
- Both are **development plugins**: unmetered, local, shared by sending the folder.

---

## 4. What is NOT done

### a. One rebuild pass is pending

Two project-wide fixes are written and bundled but **the affected frames have not
been rebuilt yet**, so the file still shows the old geometry:

1. **Auto-layout hug fix.** `autolayout()` now hugs both axes by default. Enabling
   `layoutMode` leaves both axes `FIXED` at the frame's 100×100 birth size, so every
   helper that only set width (`chipRow`, `markRow`, `lineItem`, `feeRow`, `countRow`,
   `headRow`, `heroRow`, `menuRowFilled`, `screenSearchField`, `docCard`, …) rendered
   100 tall. ~82 auto-layout call sites were affected; wireframe bands are pinned
   deliberately and are unaffected.
2. **Wire widgets.** The wire tier now renders by `kind` (field, textarea, picker,
   primary/outline button, toggle, stepper, chips, segmented, stars, list row, media
   grid, notice, summary, FAB) instead of one uniform band.

### b. Known defect: screens are region-accurate, widget-incomplete

The 30 screens were generated from `screens.json`, whose `sections` field is a
**prose summary of regions**, not an inventory. Each entry became one representative
element, and **no `*_screen.dart` was ever read** — so widgets are absent, not
merely misaligned. A screen summarised as 11 sections got 11 elements.

Accepted as a snapshot limitation. Two honest remedies if it ever matters:

- Rebuild the 3–5 screens the demo narrates from their real `.dart` files
  (adds ~1 day of turns plus eyeball verification per batch).
- Or capture the app instead (§7), which is complete by construction.

**Do not** try to polish helpers to fix this — the input was thin, not the renderer.

### c. Deferred by decision

- Per-state screen variants (~90) — declined.
- Code Connect mapping — declined.
- Dark-mode components/screens, medium/expanded breakpoints — deferred.
- `Icon/*` components not grouped into a documented icon section.

### d. App / platform (outside this effort)

- Device QA: empty states in light/dark, splash, adaptive icon.
- Desktop launcher icons (macOS/Windows/Linux) not regenerated.
- Android 12+ splash API not configured.
- iOS storyboard stale `168×185` metadata (harmless).

### e. Human blockers

- Official **KHQR/Bakong** and **PayWay** marks + usage rules.
- **Trademark clearance** and alternative logo explorations.
- **Photography** pipeline enforcement.

### f. Known debris / unverified (2026-11-08, answered from source on disk)

Written after re-reading `docs/figma/plugin/src/` and `plugin-figjam/src/`. Nothing
was rebuilt to produce these answers.

**1. Did any explicit height compensate for a too-short row? — None.**

The only `minHeight` in either plugin is `plugin/src/40-p2b-overlays.js:60`
(`c.minHeight = 56`), added during P2b so the text-only `Tone=Action` snackbar
matched the icon tones. That predates any knowledge of the 100-tall behaviour and is
not a row compensation.

Every other literal height is an element's own size, all set before the bug was
diagnosed: banner 148 (`71:219`), category card 128 (`71:251`), brand rail 108
(`71:260`), promises card 96 (`72:131`), review card 76 (`72:157`), checkout summary
96 (`73:113`), placed summary 76 (`73:195`), KPI 76 (`74:30`), profile menu list 176
(`74:115`), dashboard hero 132 (`74:162`), stock alert 64 (`74:183`), chart card 168
(`74:194`), quick link 56 (`74:250`), page-03 card 200 (`85:26`), storyboard tile 96
(`85:79`). Compensation was impossible in principle: no render was ever inspected
between the bug and the fix.

**2. After the wire-widget rewrite, was any rendered wire screen inspected? — None.**

No screenshot, no eyeball, no run. The rewrite (kinds, `WIRE_H`, the 17 renderers in
`75-screens-wire.js`) exists only as code and has never executed in Figma. Every
claim about how it looks is a description of the code path, not an observation. The
only observed wire tier is the *pre-rewrite* one (uniform bands), and the human
looked at that, not the agent. The rewrite is therefore wholly unverified, including
whether `wireSegmented`/`wireMedia` size correctly and whether `wireStars`' 1.4×
instance rescale distorts.

**3. Batches that threw, and their debris.**

Threw at least once: `p2b-overlays` (unloaded Inter font before `characters`),
`p3-atoms` (`float(undefined)` on `SPACE.xl`), `p4-cards` (three: missing
`RADIUS.r16`, nested `[[]]` fills in `simplifiedTimeline`, invalid
`layoutSizingVertical = "AUTO"`), `s1-auth-home` (two: `layoutSizing* = "FILL"`
before parenting, unknown type `headlineMedium`), `s2-customer-a`
(`appendChild(...).fills` assigned on null).

Debris control, per code: `clearOrphans` (`10-core.js`) sweeps direct children of the
parent whose component name matches
`/^(Tone|Type|Behavior|Mode|Status|Shape|Action|State)=/` and runs at the *start* of
`batchOverlays`, `batchAtoms`, `batchCards`, `batchNavigation`; `clearOld` removes a
previously combined set by name; every screen batch deletes its own `Screen/*` frames
by name before building.

Consequence: each throwing batch was subsequently re-run successfully, and that run
swept its own leftovers — so by code, **no orphan variants and no duplicate
`Screen/*` frames should remain**, with two caveats: this is unverified against the
file (no canvas access), and `clearOrphans` covers only those eight prefixes. The
in-plugin icons (`Icon/home` …) are *not* swept; they are idempotent (skipped when
present), so a failure mid-`p5-nav` would leave extra icons rather than duplicates.
Duplicates that the sweep cannot catch are listed in (4), items 1–2.

**4. Known wrong in the current file, beyond §4c.**

1. **Page 03 duplicates on every re-run.** `85-page03.js:109–110` removes only the
   three named cards; the heading (`85:112`) and subtitle (`85:117`) are top-level
   text nodes named by their characters, so each run appends another pair.
2. **FigJam anchors accumulate.** `00-kit.js:107–118` creates a 1×1 rectangle named
   `anchor` for each arrow endpoint; `20-flows-b.js:144–157` cleans only panel names.
   Re-running Flows B leaves roughly two anchors and their connectors per message
   (~40 per sequence diagram).
3. **ProductCard's unsaved wishlist heart is not recoloured.**
   `60-p4-cards.js:441–444` paints the *instance frame* (`heart.fills`) while
   `icon()` was called with `colorName = null`, so the vectors keep
   `color/on-surface`. The heart renders dark on dark imagery instead of white.
4. **OrderTrackingCard always instances one timeline variant.**
   `60-p4-cards.js:332` looks up `StageState=Current, Terminal=InFlight` for every
   card state, so Delivered and Cancelled cards also show a "Current" step at Packed
   (and Cancelled shows a forward track the app does not render).
5. **The navigation map contradicts `flows.json`.** `10-flows-a.js` `NAV_ADMIN` puts
   `adminArchivedCoupons` beside `adminPromotions` (flows.json nests it underneath)
   and omits `adminSettingsAccount` from the admin-account branch.
6. **The ERD shows 23 of 25 relations.** `30-flows-c.js` omits
   `categories → categories` (self parent) and `products → order_items` (snapshot).
7. **Screen overflow is silent.** `screenFrame` sets `clipsContent = true` and content
   frames are sized to the viewport, so anything beyond 844 is invisible until
   `audit-screens` runs. Unknown today for every screen.
8. **ProductCard leaves ~23 px empty.** Fixed 268 height, image 142, metadata hugging
   ~103 — cosmetic, not a defect in the app.

**5. Manifest freeze intent (not executed).**

Current on disk: `status: "active-local-plugin"`, `sourceCommit: "81dc7a7"`,
`sessionId: 3c99d509-…` (the retired MCP session), 12 history entries, and
`pages[0].nodeIds` still listing only the brand board, Button, Card, Input, AppBar and
`Icon/*` — no new sets, no screens, no page-02/03 nodes.

Intended, and deliberately not done yet:

- `status` → a frozen marker (e.g. `frozen-snapshot`), so no future session reads it
  as an active build.
- **Split the commit field.** `81dc7a7` is the *spec-extraction* commit and must stay
  attached to `spec/*.json`; the mirror's screens were built later, from region
  summaries rather than from the screen sources. One field cannot honestly represent
  both, so the intent was `specCommit: 81dc7a7` plus `builtAtCommit` for the actual
  generation commit, with a note that screen content derives from summaries.
- Append one `frozen` history event recording that decision set, then stop appending
  build events.
- Populate `pages[].nodeIds` with the 18 set names, the 30 frame names and the
  page-02/03 anchors, because `PLAN.md` §6 forbids rediscovering nodes by screenshot.
- Reconcile `counts.components: 19` against `componentsBuilt: 18` — the extra entry is
  the doc-only `filled-button-theme` recipe, not a missing set.

---

## 5. Exact resume procedure

**Step 0 — install both plugins (once).**

- Design file → Plugins → Development → Import from manifest →
  `docs/figma/plugin/manifest.json` (**EncueYPay Mirror**).
- Board → same flow with `docs/figma/plugin-figjam/manifest.json`
  (**EncueYPay Flows**).

Run a dev plugin by clicking its name (or `Ctrl+/`); the three items on the row
(Publish / Remove / Reveal) are management, not execution.

**Step 1 — rebuild in this order** (the fix only affects frames rebuilt after it):

1. `P4 · cards` 2. `S1 · login+home` 3. `S2 · detail+cart` 4. `S3 · checkout+orders`
5. `S4 · profile+admin` 6. `S5 · wire ×15` 7. `P6 · page 03`

P2b / P3 / P5 pin their own axes, so they are unaffected — skip them.

**Step 2 — `Audit · screens`** (read-only). Prints per screen: frame size, content
extent, `fits` or `CLIPPED Npx`, plus a count of oversized row frames. That list is
the real answer to "which screens need more than one viewport", and the input for
any per-screen work.

**Step 3 — fix by screen, never by helper.** If a screen is flagged, adjust that
screen's content or spacing. Do not re-tune shared helpers.

**Step 4 — freeze.** Record the pinned `sourceCommit` in `manifest.json`, note the
decisions in §1, and stop. Future UI belongs in the app and the contract, not here.

**If fidelity work is ever commissioned:** read that screen's `.dart` first, inventory
its widgets, rebuild from the inventory, and name nodes after their Flutter widgets
(`Text/name`, `Row/stepper`) so a machine diff can catch what the eye misses.

---

## 6. Constraints and gotchas (learned the hard way)

| Gotcha | Rule |
|---|---|
| MCP quota | All `use_figma` runs count (~20/month on Starter). Use the local plugins instead — unmetered. |
| REST API | Read-only for nodes; only comments, variables, dev resources are writable. Useless for building components or screens. |
| Editor scope | A dev plugin's `editorType` is fixed at import. Keep design and FigJam plugins separate; changing it forces a re-import. |
| **Auto-layout default** | `layoutMode` leaves BOTH axes `FIXED` at 100×100. Hug explicitly, or the frame renders 100 tall. |
| Sizing API values | `layoutSizing*` takes `FIXED`/`HUG`/`FILL`; `"AUTO"` is only for `primaryAxisSizingMode`/`counterAxisSizingMode`. |
| Parenting order | `layoutSizing* = "FILL"` throws unless the node is already a child of an auto-layout frame. |
| Hug ordering | Set hug **after** children exist; a later `resize()` re-fixes the axis. |
| dynamic-page | `setTextStyleIdAsync` — the sync setter is banned under `documentAccess: "dynamic-page"`. |
| Text creation | Assign `fontName` **before** `characters`; a new text node is born "Inter Regular". |
| Text resize | Set `textAutoResize` before `resize()`, or the resize throws. |
| `combineAsVariants` | Does not lay variants out; they stack at (0,0). Grid them manually, row-aware. |
| Variable binding | Bind **after** setting the literal; assigning a literal to a bound field unlinks it. |
| Font codepoints | Figma's "Material Icons" ≠ Flutter's bundled font. Never use glyph text; use SVG vectors. |
| Orphan variants | A failed run leaves loose `Tone=`/`Type=`/`Shape=` components; sweep before combining. |
| Screens vs source | `screens.json` `sections` is a region summary, not a widget inventory. Read the `.dart` for fidelity work. |
| Raw hex | Allowed only where the app itself hardcodes it: status badge pairs, monogram accents, brand mark, role badges. |

---

## 7. Verification

```bash
node docs/figma/plugin/build.js            # src/*.js -> code.js
node --check docs/figma/plugin/code.js
node docs/figma/plugin-figjam/build.js
node --check docs/figma/plugin-figjam/code.js

flutter analyze
flutter test
python3 -c "import json,glob; [json.load(open(p)) for p in glob.glob('docs/figma/spec/*.json')]"
```

**Capture from the running app** (the demo path, and the honest alternative to a
Figma mirror):

```bash
flutter build web --dart-define-from-file=config/.remote
python3 -m http.server 8080 --directory build/web &
chromium --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
  --window-size=390,844 --virtual-time-budget=12000 \
  --screenshot=/tmp/opencode/login.png http://127.0.0.1:8080/
```

Authenticated screens need a real session; only login is reachable without
credentials.

---

## 8. Commit ledger (this effort)

```
055eb4b feat(figjam): complete the board with ERD, permission matrix and state ownership
702ce21 feat(figjam): add the three sequence diagrams
2310ea5 refactor(figma): split the FigJam builder into its own plugin
31c76b3 feat(figma): build the 15 wireframe screens
653df7b feat(figma): add profile and the four admin pixel screens
ed0eef0 feat(figma): add checkout, orderPlaced, orders and orderDetail screens
2df5d3b feat(figma): add productDetail, cart, discovery and notifications screens
7aad209 feat(figma): add the screens kit and the first two pixel screens
96d038d feat(figma): build the atom components
82137d7 feat(figma): build the card components
ff97b30 feat(figma): build NavigationBar and finish the component sets
4f1daff feat(figma): build Snackbar, Dialog and BottomSheet
0b17f59 refactor(figma): split plugin sources and generate the flat bundle
060ee6d docs(figma): run builds as a local unmetered plugin
1e2115b docs(figma): add resumable handoff and index it
0a8bd1e feat(web): make Google sign-in and the app build work on web   ← external
```

*(The 2026-11-08 sizing fix, wire rewrite, page 03 and audit batch are in `11adafd`.)*

---

## 9. First message for a fresh session

> Read `docs/HANDOFF-FIGMA.md` and `docs/figma/RESUME.md`. The Figma work is a
> finished **snapshot**, not a live mirror. Only §5 Step 1–2 remain: rebuild the
> seven batches, then run `Audit · screens`. Do not start a per-state pass, Code
> Connect, or a new mirroring effort without an explicit decision — and for demo
> visuals, capture the running app instead.
