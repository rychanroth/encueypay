# Figma resume state

**Status:** snapshot complete and verified. One corrected `Audit · screens` run, then
freeze.

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

All seven batches were rebuilt on 2026-11-08 and verified: the three defects the
rebuild exposed (fixed in `92ec37c`, `HANDOFF-FIGMA.md` §4f item 4) are confirmed on
the canvas — `OrderTrackingCard` 1283 → 1017 tall with both `State=Cancelled` rows at
111, everything else unchanged to the pixel.

The audit batch was also rewritten (`c109b14`) after its first run reported
`30 screens · 0 clipped`: it had measured the screen's direct children, which are
always the same 56 + 716 + 72 scaffold, so it could not see overflow inside the
pinned content box (§4f item 7).

Run, once, then paste the log:

```
Audit · screens
```

The corrected batch prints, per screen, the height it actually needs and the frame
that loses the most. Then freeze (`HANDOFF-FIGMA.md` §5 Step 4).

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
