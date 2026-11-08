# Figma resume state

**Blocked:** Figma MCP Starter quota exhausted on 2026-11-08.
`use_figma` returns: *"You've reached the Figma MCP tool call limit on the
Starter plan."* The last write did **not** execute.

## What is already in the file

- 3 pages, foundations, brand board (11 illustrations), Button (16), Card (6).
- 18 Material Symbols SVGs uploaded to page `01 · Foundations & Components`
  as top-level frames named: `search`, `visibility`, `visibility_off`, `close`,
  `arrow_back`, `notifications_none`, `more_vert`, `info`, `error`,
  `check_circle`, `warning`, `refresh`, `chevron_right`, `favorite`,
  `favorite_border`, `shopping_cart`, `arrow_drop_down`, `person`.
- `Input` component set (16 variants) and `AppBar` set (8 variants) exist but
  are **not yet correct**: they contain the wrong font glyphs in the icon
  components, and their frames hug (~135 / content width) instead of 320 / 390.

## The one call to run next

Run `docs/figma/build/p2-icons-fix.js` through `use_figma` on file
`sf2EOTYc8LBadE7LpIu8kR`. It:

1. Replaces the font glyphs inside `Icon/<name>` with the imported vectors
   (bound to `color/on-surface`).
2. Sets Input to a fixed 320×56 and AppBar to 390×56.
3. Re-grids both sets.

Then take one screenshot of each set to verify. Expected: magnifier in the
Search field, eye in Password, chevron in Dropdown, and 4-column grids.

## Why the font approach failed

Figma's "Material Icons" font is a different release than Flutter's bundled
font. `0xE567` is `search` in Flutter but `add_location` in Figma. Do not use
codepoint text for icons. Use the imported SVG vectors.

## After the fix

- Convert the 18 `Icon/*` components into a documented icon section.
- Continue P2 batch 2b: Snackbar, Dialog, BottomSheet.
- Then screens.

## Quota options

- Starter/View is ~20 tool calls per month. Wait for the reset, or
- upgrade to a Full/Dev seat (200/day, 10/min) for the remaining build.
