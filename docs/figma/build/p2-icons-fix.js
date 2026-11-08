/**
 * P2 icon fix — run with use_figma after the MCP quota resets/upgrades.
 *
 * Precondition: 18 Material Symbols SVGs were uploaded to page 01 and exist as
 * top-level FRAME nodes named: search, visibility, visibility_off, close,
 * arrow_back, notifications_none, more_vert, info, error, check_circle,
 * warning, refresh, chevron_right, favorite, favorite_border, shopping_cart,
 * arrow_drop_down, person.
 *
 * It does three things:
 *   1. Replaces the wrong font glyphs inside the `Icon/<name>` components with
 *      the imported vectors and binds them to color/on-surface.
 *   2. Fixes the Input set to a fixed 320x56 (it hugged to ~135).
 *   3. Fixes the AppBar set to a fixed 390x56 and re-grids both sets.
 *
 * Verify with one screenshot of each set afterwards.
 */
const page = figma.root.children.find((p) => p.name === "01 · Foundations & Components");
await figma.setCurrentPageAsync(page);

const cols = await figma.variables.getLocalVariableCollectionsAsync();
const lightCol = cols.find((c) => c.name === "Color");
const vars = await figma.variables.getLocalVariablesAsync();
const v = vars.find(
  (x) => x.name === "color/on-surface" && x.variableCollectionId === lightCol.id
);
const fill = figma.variables.setBoundVariableForPaint(
  { type: "SOLID", color: { r: 0, g: 0, b: 0 } },
  "color",
  v
);

const names = [
  "search", "visibility", "visibility_off", "close", "arrow_back",
  "notifications_none", "more_vert", "info", "error", "check_circle",
  "warning", "refresh", "chevron_right", "favorite", "favorite_border",
  "shopping_cart", "arrow_drop_down", "person",
];

const imported = {};
for (const n of page.children) {
  if (n.type === "FRAME" && names.includes(n.name)) imported[n.name] = n;
}

let replaced = 0;
for (const name of names) {
  const comp = page.findOne((x) => x.type === "COMPONENT" && x.name === "Icon/" + name);
  const art = imported[name];
  if (!comp || !art) continue;
  comp.children.filter((c) => c.type === "TEXT").forEach((c) => c.remove());
  if (Math.abs(art.width - 24) > 0.5 || Math.abs(art.height - 24) > 0.5) {
    try { art.rescale(24 / art.width); } catch (e) {}
  }
  art.fills = [];
  try { art.clipsContent = false; } catch (e) {}
  art.findAll((n) => n.type === "VECTOR").forEach((vec) => { vec.fills = [fill]; });
  comp.appendChild(art);
  replaced++;
}

function grid(set, cols, gapX, gapY) {
  const kids = set.children.slice();
  let maxX = 0;
  let maxY = 0;
  kids.forEach((c, i) => {
    const col = i % cols;
    const row = Math.floor(i / cols);
    c.x = col * (c.width + gapX);
    c.y = row * (c.height + gapY);
    maxX = Math.max(maxX, c.x + c.width);
    maxY = Math.max(maxY, c.y + c.height);
  });
  try { set.resizeWithoutConstraints(maxX, maxY); } catch (e) {}
}

const inputSet = page.findOne((n) => n.type === "COMPONENT_SET" && n.name === "Input");
inputSet.children.forEach((c) => {
  try { c.layoutSizingHorizontal = "FIXED"; } catch (e) {}
  c.resize(320, 56);
});
grid(inputSet, 4, 24, 24);

const appBarSet = page.findOne((n) => n.type === "COMPONENT_SET" && n.name === "AppBar");
appBarSet.children.forEach((c) => {
  try { c.layoutSizingHorizontal = "FIXED"; } catch (e) {}
  c.resize(390, 56);
});
grid(appBarSet, 4, 24, 24);

return {
  replaced,
  input: { w: inputSet.width, h: inputSet.height, variants: inputSet.children.length },
  appBar: { w: appBarSet.width, h: appBarSet.height, variants: appBarSet.children.length },
};
