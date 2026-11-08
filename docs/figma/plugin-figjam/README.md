# FigJam flows plugin

A **separate development plugin** for the FigJam board. It shares nothing with
`../plugin/` except a hex parser: a board has no pages, no components and no
variables, while the design builder is entirely about them.

Keeping them apart means:

- the design plugin's manifest stays `editorType: ["figma"]` — it cannot be run
  in a board, and none of its 13 batches can be triggered there by accident;
- this plugin's manifest stays `editorType: ["figjam"]` — it cannot touch
  components or screens;
- neither one's re-import disturbs the other.

## Install (one time)

1. Open the board: https://www.figma.com/board/2O145eRxj0Ta11iwIMwuEH
2. Figma menu → **Plugins → Development → Import plugin from manifest…**
3. Select `docs/figma/plugin-figjam/manifest.json`.
4. Run it from **Plugins → Development → EncueYPay Flows**.

## Build

```bash
node docs/figma/plugin-figjam/build.js   # src/*.js -> code.js
node --check docs/figma/plugin-figjam/code.js
```

| Source | Contents |
|---|---|
| `src/00-kit.js` | palette, font loading, `fjShape`, `fjText`, `fjConnect`, `fjPanel` |
| `src/10-flows-a.js` | navigation map, order lifecycle, payment lifecycle |
| `src/90-runner.js` | `BATCHES`, runner, plugin UI |

## Batches

- **Flows A** — navigation map (customer 5 tabs + admin 4 tabs, children beneath
  each), order lifecycle (7 stages + cancellation routes), payment lifecycle
  (pending → awaiting/verified).

Each diagram is a titled backdrop panel rather than a FigJam section: sections
are a design-file concept and the panel keeps the export self-describing. A
re-run removes and rebuilds only its own panels.

## FigJam API notes

- `figma.createShapeWithText()` shapes own their text; `fjShape` sets it and
  warns if the assignment fails.
- Connectors are `figma.createConnector()` with `connectorStart`/`connectorEnd`
  endpoint ids. Failure is reported, not thrown, so a batch still produces its
  boxes when edges are unsupported.
- `documentAccess: "dynamic-page"` applies here too, so all node mutation stays
  on `currentPage`.
