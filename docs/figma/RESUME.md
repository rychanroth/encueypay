# Figma resume state

**Status:** unblocked — the MCP quota is no longer on the critical path.
**Blocked only by:** a click. The builders now run as a local development plugin.

## What changed (2026-11-08)

`use_figma` is metered against the Figma plan (~20 calls/month on Starter) and the
quota is spent. That meter covers the *transport*, not the capability: the same
Plugin API code runs unmetered as a **local development plugin**.

`docs/figma/plugin/` is that plugin. `figma-linux` supports development-plugin
import (its extension loader), so no Figma desktop licence is needed.

REST API was evaluated and rejected for this job: it is read-only apart from
comments, variables, and dev resources. It cannot create components, variant
sets, or screens.

## The call to make next (manual, ~30s)

1. Open https://www.figma.com/design/sf2EOTYc8LBadE7LpIu8kR in figma-linux.
2. Figma menu → Plugins → Development → **Import plugin from manifest…**
   → select `docs/figma/plugin/manifest.json`.
3. Run **Plugins → Development → EncueYPay Mirror**.

Expected: `P2a fix done — icons 18/18 · Input 1352x296 · AppBar 1632x136`.

Then verify `12:94` and `12:135`: magnifier in Search, eye in Password, chevron in
Dropdown, 4-column grids.

Details and loader constraints: `docs/figma/plugin/README.md`.

## What is already in the file

- 3 pages, foundations, brand board (11 illustrations), Button (16), Card (6).
- 18 Material Symbols SVGs uploaded to page `01 · Foundations & Components`
  as top-level frames named: `search`, `visibility`, `visibility_off`, `close`,
  `arrow_back`, `notifications_none`, `more_vert`, `info`, `error`,
  `check_circle`, `warning`, `refresh`, `chevron_right`, `favorite`,
  `favorite_border`, `shopping_cart`, `arrow_drop_down`, `person`.
- `Input` (16 variants) and `AppBar` (8) exist but are **not yet correct**: wrong
  font glyphs in the icon components, and frames that hug (~135) instead of
  320 / 390. The plugin fixes both and re-grids.

## Why the font approach failed

Figma's "Material Icons" font is a different release than Flutter's bundled font.
`0xE567` is `search` in Flutter but `add_location` in Figma. Never use codepoint
text for icons. Use the imported SVG vectors.

## After the fix

Done: 18 icons replaced, Input 320×56, AppBar 390×56, Snackbar (3), Dialog (2),
BottomSheet (4) — token-bound and text-style linked.

Next: 11 sets remain (ProductCard, StatusBadge, KhqrCard, MonogramImage,
PriceText, AsyncValue, EmptyState, Skeleton, OrderStatusTimeline,
OrderTrackingCard, NavigationBar), then screens, then FigJam, then page 03.

Each batch is a function in the same plugin file; see `plugin/README.md` for the
Plugin API rules that cost a run each.

## Quota facts (updated)

| Action | Metered? |
|---|---|
| `whoami`, `add_code_connect_map`, `create_new_file`, `generate_figma_design` | exempt |
| `use_figma`, `upload_assets`, reads/screenshots | counted, ~20/month on Starter |
| Local development plugin runs | **not metered** |
| REST API with a PAT | rate-limited per minute, not per month; read-only for nodes |

Starter still caps the *file*: 3 pages, 1 variable mode per collection. That is an
authored-work constraint, not a build-path one.
