# Figma Mirror — Plan (Phase 0–1)

**Status:** plan + extracted spec, **nothing written to Figma yet**
**Source commit:** `81dc7a7`
**Owner decision:** Design file + separate FigJam board; tiered fidelity (15 pixel-near, rest wireframe)

> This file is the execution contract for the Figma work. The markdown handoff stays
> the source of truth; Figma is a **projection** of it. If the two disagree, code wins,
> then the handoff, then this plan.

---

## 1. Why this shape

Three facts drive the design:

1. **There is no "import markdown" tool.** `use_figma` executes JavaScript against the
   Figma Plugin API. "Write the doc into Figma" is really a compilation step:
   prose → normalized spec JSON → canvas primitives.
2. **Artifacts are a DAG.** Variables → text/effect styles → components → screen
   instances → flows. Building screens before components guarantees rework.
3. **Reads are scarce.** The authenticated account is a **View seat on Starter**
   (`team::1556872439110631612`): 20 *read* tool calls/month. Writes are largely
   exempt. The plan must batch writes and verify sparingly.

## 2. Targets

### File A — Figma Design: `EncueYPay — Product Spec (as-built)`

**Starter caps this file at 3 pages and 1 variable mode per collection.** The original
8-page layout was collapsed to 3 pages plus internal sections; light/dark is two
collections instead of two modes.

| # | Page | Contents |
|---|---|---|
| 01 | Foundations & Components | Cover/index block, color variables (`Color` = Light, `Color Dark` = Dark), 13 text styles, spacing/radius numbers, 3 effect styles, then 19 component sets in sections |
| 02 | Screens | Customer (11 pixel + 6 wire) and Admin (4 pixel + 8 wire) in labeled sections; states live beside their screen |
| 03 | Motion & Contracts | Motion storyboard frames, cross-cutting states, invariants/API notes |

Page IDs are recorded in `manifest.json`. Sections are named `S · Customer`,
`S · Admin`, `S · Components`, `S · Foundations` so any frame can be located by name.

### File B — FigJam: `EncueYPay — Flows & Data`

Sections: Navigation map · Order lifecycle · Payment lifecycle · Auth sequence ·
Checkout sequence · KHQR verification · ERD · Permission matrix · State ownership.

**Why two files:** two is inside the Starter budget (3 collaborative files), and
diagrams in FigJam stay editable without polluting the design canvas. **Do not** use
`generate_diagram` — it creates a new file per call, which would blow the budget.

## 3. Fidelity tiers

| Tier | Screens | Rules |
|---|---|---|
| **Pixel** (15) | login, home, discovery, productDetail, notifications, cart, checkout, orderPlaced, orders, orderDetail, profile, adminDashboard, adminProducts, adminOrders, adminReports | Component instances only; real copy/prices from the app; light **and** dark; compact + one expanded variant for home/productDetail/checkout/adminDashboard |
| **Wire** (14 + notFound) | reviewCompose, profileEdit, addresses, addressEdit, wishlist, settings, adminProductForm, adminBrands, adminCategories, adminPromotions, adminArchivedCoupons, adminAudit, adminSettings, adminOrderDetail, notFound | Auto-layout blocks + labels + nav; light only; no detached components |

Wire screens exist to complete the inventory. They are **not** a promise of visual
fidelity and must not be presented as final designs.

## 4. Source-of-truth rules

- Tokens are extracted from `lib/core/presentation/theme/*.dart` and
  `motion.dart`, not from the handoff prose tables. `tokens.json` records the mapping.
- Screen structure comes from the handoff §4, cross-checked against
  `lib/core/router` and the 29 `*_screen.dart` files.
- **Known drift to respect:** `docs/DESIGN.md` describes a retired multi-step
  checkout; §4.2.7 and the code are correct. `DEVELOPER-HANDOFF.md` itself claims
  snapshot `6aaaa70` while HEAD is `81dc7a7` (wishlist optimistic toggles landed
  after). Neither is a reason to invent: flag and ask.

## 5. Build phases

Each phase ends with a commit of the spec/scripts/manifest — not of `lib/`.

| Phase | Work | Tool calls | Done when |
|---|---|---:|---|
| **P0 Preflight** | `whoami`, `create_new_file` ×2, `create_session` | 3 writes | ✅ Files created; keys in `manifest.json` |
| **P1 Foundations** | Pages, `Color`/`Color Dark` collections, floats, text styles, effect styles | 1 `use_figma` | ✅ 36×2 colors, 13 floats, 13 text styles, 3 effects; fonts confirmed |
| **P2 Components** | 19 sets in 3 batches, page 01 section `S · Components` | 3 `use_figma` | Every axis combination exists; `Card/Elevated` swaps to `Card/Flat` without detaching |
| **P3 Customer pixel** | 11 screens, 3–4 per call, page 02 section `S · Customer` | 5 `use_figma` | Instances only; frame names match `screens.json`; loading/empty/error variants exist |
| **P4 Admin pixel + wire** | 4 admin pixel then 8 wire, page 02 section `S · Admin` | 4 `use_figma` | Same checks; admin tab order matches `NavigationBar` |
| **P5 Customer wire** | 6 wire customer screens + notFound, page 02 | 2 `use_figma` | Inventory complete; every `screens.json` id has a frame |
| **P6 FigJam** | 9 diagrams on the FigJam board | 2 `use_figma` | Node/edge counts match `flows.json`; each section captioned with the source section |
| **P7 Annotation + sync** | Cross-cutting matrix + motion storyboard on page 03; Code Connect best-effort | 2 `use_figma` + 1 `add_code_connect_map` | Page 03 complete; mapping recorded or marked unsupported |
| **P8 QA** | One `get_metadata` per page, one screenshot | ≤4 reads | No raw hex; no duplicate frames on re-run; manifest updated |

**Budget:** ~19–22 write calls, ≤6 read calls, 2 files. Comfortably inside the
View-seat read quota **only if** verification is batched.

### Starter constraints (discovered at P0/P1)

| Limit | Impact | Workaround |
|---|---|---|
| 1 variable mode per collection | No Light/Dark modes in one collection | `Color` (Light) + `Color Dark` collections with identical names; frames bind to the right set |
| 3 pages per file | Cannot use the original 8-page map | 3 pages with named sections inside |
| 3 collaborative files | Budget for Design + FigJam only | Diagrams drawn on the single FigJam board, never `generate_diagram` |
| 20 read calls/month (View seat) | No iterative screenshot loop | Batch writes; verify with write-return evidence |

## 6. Non-negotiable agent protocol

Before **any** Figma write:

1. Read `docs/architecture-contract.md` for the relevant layer, then the matching
   handoff section. Do not touch `lib/` for this work.
2. Load the required skill: `/figma-use` before `use_figma`,
   `/figma-create-new-file` before `create_new_file`,
   `/figma-generate-diagram` only if diagrams move off FigJam.
3. Update `PLAN.md` / spec JSON **first**; the canvas follows the spec, never the reverse.
4. Run one page per `use_figma` call. Store the script at
   `docs/figma/build/<page>.js` (same text that was sent) so the run is reproducible.
5. Record returned node IDs in `manifest.json`. Never re-discover nodes by screenshot.
6. On any conflict or gap: **stop and ask** (GLOBAL-01). Do not silently invent a
   screen, a state, or a token.
7. Commit `docs/figma/` after each phase (repo pre-authorizes commits).

**Idempotency:** pages created by the builder are generation-owned. Re-running a page
deletes its own top-level frames and rebuilds them; components and variables are
looked up by name and updated in place. `setPluginData` is banned, so names +
`manifest.json` are the identity mechanism.

## 7. Landmines

| Risk | Mitigation |
|---|---|
| **Read quota (20/month)** | No per-frame screenshot loops. One `get_metadata` per page. Rely on write-call return values. |
| **Starter file cap** | Two files total. Confirm the cap at P0 before creating the FigJam board. |
| **Font unavailable** | Check `figma.listAvailableFontsAsync()` once at P1. Plus Jakarta Sans is a Google Font, so it is normally present. Record any fallback in the manifest. Weights are `Semi Bold`, not `SemiBold`. |
| **Generate payload too large** | 3–5 frames per call, not a whole page. Split screen batches as listed. |
| **Raw hex creeping in** | Bind every fill/stroke to a variable. Audit with a script that walks `fills`/`strokes` for `{r,g,b}` literals. |
| **Detached instances** | Wire screens must still use instances. Detaching to "fix" a layout is a defect. |
| **Doc drift** | Manifest pins the source commit; regenerate the spec on each doc change and diff. |
| **Scope creep** | Backend/API content gets diagrams and notes only. No attempt to model the DB as frames. |
| **Code Connect / Flutter** | Code Connect's official template parsers do not cover Flutter. Treat `add_code_connect_map` as a best-effort node→path map; do not promise a code↔design sync. |

## 8. Definition of done (Figma mirror)

- Every `screens.json` id has a frame on the right page, with every listed state or an
  explicit deferral recorded in the manifest.
- Every `components.json` id exists with all axes; no detached copies on screen pages.
- Color variable count equals `tokens.json`; light/dark mode switching is live.
- No literal hex in any created node (audited).
- Re-running one page's builder produces no duplicates (idempotency smoke test).
- `manifest.json` records file keys, page IDs, node IDs, source commit, and any
  substitutions (font, icons).
- `flutter analyze` / `flutter test` remain unaffected (no `lib/` changes).

## 9. Open decisions

1. **Icon source** — the repo bundles no SVGs. Options: import Material Symbols
   (Apache-2.0) as components, or render text glyphs. Needs approval before download.
2. **Expanded variants** — proposed only for home, productDetail, checkout,
   adminDashboard. Confirm or drop.
3. **Dark mode for wire screens** — currently light-only. Confirm.

**Resolved:** file placement — both files were created in the account's drafts
(`sf2EOTYc8LBadE7LpIu8kR`, `2O145eRxj0Ta11iwIMwuEH`).
