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

## Adding batches

Keep one flat `code.js`. When more batches land, add a `ui.html` selector in this
same folder (flat, no subdirectories) and dispatch by command name. Do not ship a
bundler — figma-linux's loader is the fragile part, and a single unbundled file
avoids it entirely.

## Relationship to the other files

- `docs/figma/build/p2-icons-fix.js` — the original MCP payload, kept as the
  record of what was designed for `use_figma`. `code.js` is its runnable twin.
- `docs/figma/manifest.json` — node IDs and build history.
- `docs/figma/PLAN.md` §6 — the protocol this folder follows (one page per run,
  scripts kept in-repo so every run is reproducible).
