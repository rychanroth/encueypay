/**
 * EncueYPay — Figma mirror builder (local development plugin).
 *
 * Batch: P2a-fix
 *   Replaces the wrong Material Icons font glyphs inside `Icon/<name>` with the
 *   imported Material Symbols vectors (bound to color/on-surface), then sets
 *   Input to 320x56 and AppBar to 390x56 and re-grids both sets.
 *
 * Why a plugin instead of the MCP: `use_figma` is metered by the Figma plan
 * (~20 calls/month on Starter). A development plugin runs the same Plugin API
 * code with no metering. This file is the runnable form of
 * docs/figma/build/p2-icons-fix.js.
 *
 * Run: Plugins -> Development -> EncueYPay Mirror
 * Idempotent: safe to re-run. A second run reports 0 icons replaced.
 */

(async () => {
  const PAGE_NAME = "01 · Foundations & Components";
  const ICON_NAMES = [
    "search", "visibility", "visibility_off", "close", "arrow_back",
    "notifications_none", "more_vert", "info", "error", "check_circle",
    "warning", "refresh", "chevron_right", "favorite", "favorite_border",
    "shopping_cart", "arrow_drop_down", "person",
  ];

  try {
    await figma.loadAllPagesAsync();

    const page = figma.root.children.find((p) => p.name === PAGE_NAME);
    if (!page) {
      throw new Error(`Page "${PAGE_NAME}" not found.`);
    }
    await figma.setCurrentPageAsync(page);

    // --- token: color/on-surface from the light collection --------------------
    const collections = await figma.variables.getLocalVariableCollectionsAsync();
    const light = collections.find((c) => c.name === "Color");
    if (!light) throw new Error('Variable collection "Color" not found.');

    const all = await figma.variables.getLocalVariablesAsync();
    const onSurface = all.find(
      (x) => x.name === "color/on-surface" && x.variableCollectionId === light.id
    );
    if (!onSurface) throw new Error('Variable "color/on-surface" not found.');

    const iconFill = figma.variables.setBoundVariableForPaint(
      { type: "SOLID", color: { r: 0, g: 0, b: 0 } },
      "color",
      onSurface
    );

    // --- locate the imported SVG frames (top-level, named like the icon) ------
    const imported = {};
    for (const node of page.children) {
      if (node.type === "FRAME" && ICON_NAMES.includes(node.name)) {
        imported[node.name] = node;
      }
    }

    let replaced = 0;
    const skipped = [];

    for (const name of ICON_NAMES) {
      const comp = page.findOne(
        (n) => n.type === "COMPONENT" && n.name === "Icon/" + name
      );
      const art = imported[name];

      if (!comp && !art) {
        skipped.push(`${name} (already fixed)`);
        continue;
      }
      if (!comp) {
        skipped.push(`${name} (no Icon/ component)`);
        continue;
      }
      if (!art) {
        skipped.push(`${name} (no imported vector)`);
        continue;
      }

      // Drop the wrong font glyph (and any stray text) from the component.
      comp.children.filter((c) => c.type === "TEXT").forEach((c) => c.remove());

      if (Math.abs(art.width - 24) > 0.5 || Math.abs(art.height - 24) > 0.5) {
        try {
          art.rescale(24 / art.width);
        } catch (e) {
          // keep going; size is cosmetic at this point
        }
      }

      art.fills = [];
      try {
        art.clipsContent = false;
      } catch (e) {}

      art.findAll((n) => n.type === "VECTOR").forEach((vec) => {
        vec.fills = [iconFill];
      });

      comp.appendChild(art);
      replaced++;
    }

    // --- fixed widths + manual grid ------------------------------------------
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
      try {
        set.resizeWithoutConstraints(maxX, maxY);
      } catch (e) {}
    }

    const inputSet = page.findOne(
      (n) => n.type === "COMPONENT_SET" && n.name === "Input"
    );
    const appBarSet = page.findOne(
      (n) => n.type === "COMPONENT_SET" && n.name === "AppBar"
    );
    if (!inputSet) throw new Error('Component set "Input" not found.');
    if (!appBarSet) throw new Error('Component set "AppBar" not found.');

    inputSet.children.forEach((c) => {
      try {
        c.layoutSizingHorizontal = "FIXED";
      } catch (e) {}
      c.resize(320, 56);
    });
    grid(inputSet, 4, 24, 24);

    appBarSet.children.forEach((c) => {
      try {
        c.layoutSizingHorizontal = "FIXED";
      } catch (e) {}
      c.resize(390, 56);
    });
    grid(appBarSet, 4, 24, 24);

    // --- report --------------------------------------------------------------
    const summary = [
      `icons ${replaced}/${ICON_NAMES.length}`,
      `Input ${Math.round(inputSet.width)}x${Math.round(inputSet.height)}`,
      `AppBar ${Math.round(appBarSet.width)}x${Math.round(appBarSet.height)}`,
    ].join(" · ");

    const detail = skipped.length ? ` · skipped: ${skipped.join(", ")}` : "";
    figma.notify(`P2a fix done — ${summary}${detail}`, { timeout: 12000 });
    figma.closePlugin(`P2a fix done — ${summary}`);
  } catch (err) {
    const message = (err && err.message) || String(err);
    figma.notify(`P2a fix FAILED — ${message}`, {
      error: true,
      timeout: 20000,
    });
    figma.closePlugin(`P2a fix FAILED — ${message}`);
  }
})();
