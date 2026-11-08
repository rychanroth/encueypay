# Figma resume state

**Status:** snapshot complete. Final `P4` + `P6` re-run pending; nothing else planned.

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

All seven batches were rebuilt on 2026-11-08 (`done:` for each, no warnings). The
rebuild exposed three defects that every run re-applies, fixed in `92ec37c`
(`HANDOFF-FIGMA.md` §4f item 4):

1. **Cancelled tracking card** instanced the in-flight timeline, so a cancelled order
   showed a forward track instead of the app's terminal callout.
2. **ProductCard's unsaved heart** painted the instance, not the vector, so it stayed
   dark on dark imagery.
3. **Page 03** appended a second heading and subtitle on every run.

Run, in this order:

```
P4 · cards → P6 · page 03 → Audit · screens
```

then paste the audit log. §4a lists the geometry the final P4 run must print — the
two `State=Cancelled` rows shrink, everything else stays identical.

P2b / P3 / P5 pin their own axes and are unaffected. FigJam is not re-run: its
anchor accumulation (§4f item 2) and the nav-map / ERD gaps (items 5–6) are recorded
as accepted snapshot defects.

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
