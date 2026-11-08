# Local Figma build plugin

Runs the mirror builders through the **Figma Plugin API locally**, with no MCP
tool-call metering. Same code the MCP would have executed.

## Why this exists

`use_figma` (Figma MCP) is metered against the Figma plan: ~20 calls/month on
Starter, and every execution counts. A development plugin executes the identical
Plugin API code with your own editor permissions and **no monthly cap**. The MCP
blocked P2a-fix; this file performs it instead.

## Install (one time, ~30 seconds)

1. Open the design file in the Figma desktop app or **figma-linux**:
   https://www.figma.com/design/sf2EOTYc8LBadE7LpIu8kR
2. Figma menu (top-left) → **Plugins** → **Development** →
   **Import plugin from manifest…**
3. Select `docs/figma/plugin/manifest.json`.

It now appears under **Plugins → Development → EncueYPay Mirror**.

## Run

Open the file, then **Plugins → Development → EncueYPay Mirror**.

Expected toast:

```
P2a fix done — icons 18/18 · Input 1352x296 · AppBar 1632x136
```

Those sizes follow from the grid maths: 4 columns of 320 + 3×24 gutters = 1352;
16 variants over 4 columns = 4 rows of 56 + 3×24 = 296. AppBar is 4×390 + 72 =
1632 wide, 2 rows = 136 tall.

Then check `Input` (node `12:94`) and `AppBar` (`12:135`): a magnifier in
Search, an eye in Password, a chevron in Dropdown, 4-column grids.

## Constraints baked into this folder

All learned from figma-linux's extension loader:

| Constraint | Reason |
|---|---|
| `main` is a flat filename (`code.js`) | figma-linux rejected subfolder paths (`dist/code.js`) before 0.11.3 |
| Filename has no dashes | older loader regex accepted only `[\w/]` |
| No `ui.html`, no build step | UI-in-subfolder was a separate known break; nothing here needs a UI |
| `networkAccess.allowedDomains: ["none"]` | the build is fully offline |

If the manifest file picker filters `.json` oddly (older builds did), switch the
dialog's file-type filter to *All files*.

## File layout

`code.js` is **generated** — never edit it. Edit `src/` and rebuild:

```bash
node docs/figma/plugin/build.js      # concatenates src/*.js -> code.js
node --check docs/figma/plugin/code.js
```

| Source | Contents |
|---|---|
| `src/00-header.js` | doc comment, typography table, colour fallbacks |
| `src/10-core.js` | file context, tokens, text/rect/icon primitives, layout + grid helpers |
| `src/20-inspect.js` | `inspect` batch |
| `src/30-p2a-icons.js` | icon fix + Input/AppBar sizing |
| `src/40-p2b-overlays.js` | Snackbar, Dialog, BottomSheet; **RADIUS/SPACE maps live here** |
| `src/50-p3-atoms.js` | PriceText, StatusBadge, Skeleton, EmptyState, AsyncValue, MonogramImage |
| `src/60-p4-cards.js` | KhqrCard, OrderStatusTimeline, OrderTrackingCard, ProductCard |
| `src/70-runner-ui.js` | `BATCHES` registry, runner, plugin UI |

Why split sources but ship one file: the Figma runtime cannot `import`, and
figma-linux's loader rejects subfolder paths (`dist/code.js`) and dashes in
filenames. Concatenation keeps both sides happy — no bundler, no transpile, and
`code.js` stays a single flat script.

## Adding batches

Add a `src/NN-*.js` with `batchXxx(log)`, register it in `BATCHES`
(`src/70-runner-ui.js`), add a `<button data-batch="xxx">`, rebuild.

Rules learned the hard way:

| Rule | Why |
|---|---|
| `await node.setTextStyleIdAsync(id)` | `documentAccess: "dynamic-page"` bans the sync `textStyleId` setter |
| Assign `fontName` **before** `characters` | a new text node is born "Inter Regular"; writing characters first fails with "unloaded font" |
| Set `textAutoResize` **before** `resize()` | resizing a `WIDTH_AND_HEIGHT` text node throws |
| Set hug sizing (`primaryAxisSizingMode = "AUTO"`) **last** | a `resize()` after it re-fixes the axis |
| Size grid rows by the tallest cell in the row | stepping by each variant's own height drifts rows apart |
| Bind variables **after** setting the literal | assigning a literal to a bound field unlinks the variable |
| Sweep orphan variants before `combineAsVariants` | a failed run leaves loose `Tone=`/`Type=` components that break the next combine |

Judgement calls made in P2b (confirm or correct):

- Snackbar tones differ by leading icon (`check_circle` / `error`) and, for
  `Action`, by a trailing `labelLarge` action; `components.json` does not specify
  a per-tone fill.
- Dialog copy is placeholder ("Discard changes?", "Delete this product?").
- `components.json` says the drag handle is always on, but the axis is
  `Header=[Text, TextAndHandle]`; `Text` therefore renders without the handle.

## Relationship to the other files

- `docs/figma/build/p2-icons-fix.js` — the original MCP payload, kept as the
  record of what was designed for `use_figma`. `code.js` is its runnable twin.
- `docs/figma/manifest.json` — node IDs and build history.
- `docs/figma/PLAN.md` §6 — the protocol this folder follows (one page per run,
  scripts kept in-repo so every run is reproducible).
