# Figma mirror — build record & constraints

**Status:** frozen snapshot, 2026-11-08. Nothing to run or rebuild.
**Pinned in:** `manifest.json` — `specCommit 81dc7a7` (spec extraction),
`builtAtCommit 92ec37c` (canvas), page ids, all 18 set ids with variant counts, all 30
`Screen/*` ids, page-03 anchors, measured overflow, one `frozen` history event.
**Authority:** code + `docs/architecture-contract.md` win. Figma is a **projection**
of the app, not a second source of truth. Do not build UI here first.

---

## 1. What exists

**File A — Design `EncueYPay — Product Spec (as-built)`** · `sf2EOTYc8LBadE7LpIu8kR`

| Page | id | Contents |
|---|---|---|
| 01 · Foundations & Components | `0:1` | Brand board, 2 color collections (`Color`, `Color Dark`), 13 text styles, floats, 3 effect styles, **18 component sets** (169 variants), 24 `Icon/*` |
| 02 · Screens | `2:4` | **30 screens**, 15 pixel + 15 wire, in `S · Customer` / `S · Admin` |
| 03 · Motion & Contracts | `2:5` | Motion tokens, 4-step storyboard, cross-cutting contracts |

**File B — FigJam `EncueYPay — Flows & Data`** · `2O145eRxj0Ta11iwIMwuEH`
9 diagrams: navigation, order lifecycle, payment lifecycle, auth / checkout / KHQR
sequences, ERD, permission matrix, state ownership. Each is a **group** named after the
diagram, containing its fitted backdrop, title, shapes and connectors — so dragging the
panel drags its contents, and a re-run removes it wholesale (`fjClear`).

Rebuilt 2026-11-09 after the containers were fixed; fitted sizes (w×h) as the plugin
reports them:

| Diagram | Size |
|---|---|
| Navigation map | 1378×1234 |
| Order lifecycle | 1688×363 |
| Payment lifecycle | 1105×312 |
| Authentication and role routing | 1548×620 |
| Checkout and atomic placement | 1802×843 |
| KHQR payment verification | 1548×843 |
| Data model (ERD) | 1668×603 |
| Permission matrix | 1320×677 |
| State ownership and refresh paths | 1824×557 |

The navigation map was re-laid-out on 2026-11-09 so each shell is its own card with a
header rule and its own nested group; the table entry above is from before that change
and is refreshed by the next `Flows A` run (~1378×1424 expected).

**Tooling** — two local **development plugins**, unmetered: `plugin/` (design, 14
batches incl. `Audit · screens` and `Registry · ids`) and `plugin-figjam/` (4 batches
incl. `Reset · clear board`). Both assemble a flat `code.js` from `src/*.js` via
`build.js`; Figma re-reads it on every run, so new batches appear without re-importing.

**Plan limits (Starter, View seat)** — 3 pages and 1 variable mode per collection,
hence light/dark as two collections with identical names, and sections instead of
pages. 3 collaborative files, hence one board for all diagrams. Do not call
`generate_diagram`; it creates a file per call.

## 2. Fidelity tiers — 15 / 15, fixed

| Tier | Screens |
|---|---|
| **Pixel** | login, home, productDetail, cart, discovery, notifications, checkout, orderPlaced, orders, orderDetail, profile, adminDashboard, adminProducts, adminOrders, adminReports |
| **Wire** | reviewCompose, profileEdit, addresses, addressEdit, wishlist, settings, notFound, adminProductForm, adminBrands, adminCategories, adminPromotions, adminArchivedCoupons, adminAudit, adminSettings, adminOrderDetail |

Wire frames complete the inventory. They are **not** a promise of visual fidelity and
must never be presented as final designs. Dark mode and medium/expanded breakpoints
are not authored at all; the variables exist for a later pass.

## 3. Decisions (frozen 2026-11-08)

- **Snapshot, not twin.** Pinned to a commit; a new feature gets a new frame only if
  someone asks. Do not restart a standing mirror.
- **No per-state screens.** The ~90 variants in `screens.json` are declined; the
  canonical `loaded` state exists for all 30.
- **No Code Connect.** Flutter has no official parser target; a node→path map is a
  record, not a sync.
- **Demo visuals come from the app**, not the board — screenshots/recording of the
  running web build are complete by construction (§7).
- **Brand rules live in `docs/brand/BRAND.md`** — wordmark is type (Plus Jakarta Sans
  ExtraBold, −3%), mark is the Ledger E vector. Not restated here.

## 4. How it was built

1. Extract `spec/{tokens,components,screens,flows}.json` from the code at
   `81dc7a7`; the canvas follows the spec, never the reverse.
2. Run the design plugin batch by batch: foundations → atoms → overlays → cards →
   navigation → screens (S1–S5) → page 03. Rebuild order matters: a fix only reaches
   frames rebuilt after it.
3. Each batch is idempotent **by name**: `clearOld` removes a previous combined set,
   `clearOrphans` sweeps loose `Tone=`/`Type=`/`Shape=` components, screen batches
   delete their own `Screen/*` frames first. `setPluginData` is banned, so names plus
   `manifest.json` are the only identity mechanism.
4. `Registry · ids` dumps page/set/frame ids read-only; re-run it after any rebuild
   before trusting the manifest.

## 5. Accepted defects

**Screens are region-accurate but widget-incomplete.** They were generated from
`screens.json`, whose `sections` field is a prose summary of regions, not an
inventory; each entry became one representative element and **no `*_screen.dart` was
read**. Widgets are absent, not misaligned. Remedies, if it ever matters: rebuild the
3–5 narrated screens from their real `.dart` files, or capture the app (§7). Do not
polish shared helpers to compensate — the input was thin, not the renderer.

**Measured overflow** (audit, nav-bar floor). Content hidden under the opaque nav bar
or cut at the frame edge: `productDetail` 465px, `home` 107, `adminReports` 67,
`discovery` 51, `checkout` 32; the other 25 screens fit. `productDetail` (+274) and
`orderDetail` (+44) are wide because horizontal rails are drawn at natural width and
the app scrolls them — by design. No per-screen fixes are planned.

**Smaller, recorded and accepted:**

- `ProductCard` leaves ~23px empty (fixed 268 height).
- Two card frames are 2px and 12px shorter than their contents.
- `OrderStatusTimeline` pins its `Current` row at "Packed", so **`Delivered` cannot be
  represented**; the Delivered card shows Packed as active. Fixing it needs a
  `Focus=…` dimension over 7 positions — a per-state expansion, declined.
- FigJam: the navigation map flattens `adminArchivedCoupons` and omits
  `adminSettingsAccount`; the ERD carries 23 of 25 relations.
- FigJam containers: until 2026-11-09 each diagram was a plain rectangle backdrop with
  loose neighbours, so it neither hugged its content (sizes were literals) nor carried
  it when moved. Fixed and rebuilt: diagrams are groups with content-fitted backdrops.
  The old literals were wrong by 90–110px on height (navigation 1320 → 1234, order
  lifecycle 420 → 363, payment 420 → 312), which is what the empty band was.

## 6. Constraints and gotchas (learned the hard way)

| Gotcha | Rule |
|---|---|
| MCP quota | Every `use_figma` counts (~20/month on the View seat). Use the local plugins — unmetered. |
| REST API | Read-only for nodes; only comments, variables and dev resources are writable. Useless for building. |
| Editor scope | A dev plugin's `editorType` is fixed at import. Keep design and FigJam plugins separate. |
| **Auto-layout birth size** | `layoutMode` leaves BOTH axes `FIXED` at 100×100, so a frame that only sets width renders 100 tall. Hug explicitly. |
| Sizing API values | `layoutSizing*` takes `FIXED`/`HUG`/`FILL`; `"AUTO"` is only for `primaryAxisSizingMode`/`counterAxisSizingMode`. |
| Parenting order | `layoutSizing* = "FILL"` throws unless the node is already a child of an auto-layout frame. |
| Hug ordering | Set hug **after** children exist; a later `resize()` re-fixes the axis. |
| dynamic-page | Use `setTextStyleIdAsync`; the sync setter is banned under `documentAccess: "dynamic-page"`. |
| Text creation | Assign `fontName` **before** `characters`; a new text node is born "Inter Regular". |
| Text resize | Set `textAutoResize` before `resize()`, or the resize throws. |
| `combineAsVariants` | Does not lay variants out; they stack at (0,0). Grid them manually, row-aware. |
| Variable binding | Bind **after** setting the literal; assigning a literal to a bound field unlinks it. |
| Font codepoints | Figma's "Material Icons" ≠ Flutter's bundled font. Never use glyph text; use SVG vectors. |
| Orphan variants | A failed run leaves loose `Tone=`/`Type=`/`Shape=` components; sweep before combining. |
| `screens.json` | `sections` is a region summary, not a widget inventory. Read the `.dart` for fidelity work. |
| Raw hex | Allowed only where the app itself hardcodes it: status badge pairs, monogram accents, brand mark, role badges. |
| **Pinned boxes hide overflow** | Screen content sits in a content frame pinned to 716 tall at y=56. Anything past it flows under the opaque nav bar (top 772) and is invisible without measuring. |
| **Measuring** | Measure *required* height recursively (auto-layout = padded sum + gaps, absolute = child bottom) and compare against the **nav bar's top edge**, not 844. Measuring direct children always yields 844. |
| **No auto-layout in FigJam** | A rectangle is decoration, not a container: dragging it moves nothing. Group the contents (`figma.group`, name the group) or use a section — that is the only way children follow. |
| FigJam sizing | Panel sizes written as literals never match the drawing. Snapshot `page.children` at panel creation, then fit the backdrop to the bbox of what was added (`fjEnd`). |
| Re-run pollution | Cleanup is by **name**: groups named after the diagram are removed wholesale. Anything outside a named container (a free-standing heading, a loose connector anchor) survives — sweep it explicitly, or group it. |
| Cascading deletes | Removing a shape also removes its connectors, so a snapshot of `page.children` goes stale mid-loop and `remove()` throws `node … does not exist`. Check `node.removed` or sweep in passes. |

## 7. Verification

```bash
node docs/figma/plugin/build.js && node --check docs/figma/plugin/code.js
node docs/figma/plugin-figjam/build.js && node --check docs/figma/plugin-figjam/code.js
python3 -c "import json,glob; [json.load(open(p)) for p in glob.glob('docs/figma/spec/*.json')+['docs/figma/manifest.json']]"
flutter analyze && flutter test
```

**Capture from the running app** — the demo path, and the honest alternative to the
board:

```bash
flutter build web --dart-define-from-file=config/.remote
python3 -m http.server 8080 --directory build/web &
chromium --headless=new --no-sandbox --disable-gpu --hide-scrollbars \
  --window-size=390,844 --virtual-time-budget=12000 \
  --screenshot=/tmp/opencode/login.png http://127.0.0.1:8080/
```

Authenticated screens need a real session; only login is reachable without
credentials.

## 8. If fidelity is ever commissioned

Read that screen's `.dart` first, inventory its widgets, rebuild from the inventory,
and name nodes after their Flutter widgets (`Text/name`, `Row/stepper`) so a machine
diff catches what the eye misses. Verify one batch eyeball-by-eyeball before the next.

## 9. Don't restart

Adding a frame later is fine. Rebuilding the mirror for each feature is not — that is
the maintenance tax recorded in the vault note *Design handoff — Figma, MCP, Remotion,
and single source of truth*. Future UI belongs in the app and the contract.
