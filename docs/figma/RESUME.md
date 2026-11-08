# Figma resume state

**Status:** snapshot complete. One rebuild pass pending; nothing else planned.

## What changed on 2026-11-08 (late)

The mirror is finished and **frozen**:

- 18 component sets, 30 screens (15 pixel + 15 wire), 9 FigJam diagrams, page 03.
- Two local development plugins replaced the metered MCP:
  `docs/figma/plugin/` (design, 13 batches) and `docs/figma/plugin-figjam/`
  (board, 3 batches).
- Decisions recorded in `docs/HANDOFF-FIGMA.md` §1: Figma is a **snapshot**, not a
  twin; no per-state screens; no Code Connect; demo visuals come from capturing the
  running app.

## The only work left

Two project-wide fixes are written and bundled but the frames have not been rebuilt:

1. **Auto-layout hug.** `autolayout()` now hugs both axes. Before this, any frame
   that only set its width stayed 100 tall (chip rows, "Mark all read", checkout
   line items, dashboard rows, page-03 cards…). Wireframe bands stay fixed on
   purpose.
2. **Wire widgets.** The wire tier now draws by `kind` — field, textarea, picker,
   buttons, toggle, stepper, chips, segmented, stars, list row, media, notice,
   summary, FAB — instead of one uniform band.

Run, in this order:

```
P4 · cards → S1 → S2 → S3 → S4 → S5 · wire ×15 → P6 · page 03
```

then `Audit · screens` and paste its log. P2b / P3 / P5 pin their own axes and are
unaffected.

## Known limitation (accepted)

Screens are accurate at **region** level and incomplete below it: they were built
from `screens.json`'s region summaries, and no `*_screen.dart` was read, so widgets
are **absent**, not misaligned.

If fidelity is ever commissioned, do not polish helpers — read that screen's Dart,
inventory its widgets, rebuild from the inventory, and name nodes after their
Flutter widgets so a diff can verify completeness. For demo visuals, capture the
app instead (recipe in `HANDOFF-FIGMA.md` §7).

## Quota facts

| Action | Metered? |
|---|---|
| Local development plugin runs | **no** |
| `use_figma`, `upload_assets`, MCP reads | yes — ~20/month on Starter |
| REST API with a PAT | rate-limited per minute; read-only for nodes |

Starter still caps the file at 3 pages and 1 variable mode per collection. That is
an authored-work constraint, not a build-path one.

## Don't restart

Adding a frame later is fine. Rebuilding the mirror for each feature is not — that
is the maintenance tax documented in the vault note
`Design handoff — Figma, MCP, Remotion, and single source of truth.md`.
