// ===== extra icons (Material Symbols, Apache-2.0) =====
// The first 18 icons were imported through the MCP before the quota ran out.
// These five are needed by NavigationBar; their path data is inlined here so the
// plugin can build the components itself (figma.createNodeFromSvg) with no
// upload call. Source: github.com/google/material-design-icons, symbols/web.

const EXTRA_ICONS = {
  home: "M240-200h120v-240h240v240h120v-360L480-740 240-560v360Zm-80 80v-480l320-240 320 240v480H520v-240h-80v240H160Zm320-350Z",
  explore:
    "m260-260 300-140 140-300-300 140-140 300Zm220-180q-17 0-28.5-11.5T440-480q0-17 11.5-28.5T480-520q17 0 28.5 11.5T520-480q0 17-11.5 28.5T480-440Zm0 360q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Zm0-320Z",
  receipt_long:
    "M240-80q-50 0-85-35t-35-85v-120h120v-560l60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60 60 60 60-60v680q0 50-35 85t-85 35H240Zm480-80q17 0 28.5-11.5T760-200v-560H320v440h360v120q0 17 11.5 28.5T720-160ZM360-600v-80h240v80H360Zm0 120v-80h240v80H360Zm320-120q-17 0-28.5-11.5T640-640q0-17 11.5-28.5T680-680q17 0 28.5 11.5T720-640q0 17-11.5 28.5T680-600Zm0 120q-17 0-28.5-11.5T640-520q0-17 11.5-28.5T680-560q17 0 28.5 11.5T720-520q0 17-11.5 28.5T680-480ZM240-160h360v-80H200v40q0 17 11.5 28.5T240-160Zm-40 0v-80 80Z",
  dashboard:
    "M520-600v-240h320v240H520ZM120-440v-400h320v400H120Zm400 320v-400h320v400H520Zm-400 0v-240h320v240H120Zm80-400h160v-240H200v240Zm400 320h160v-240H600v240Zm0-480h160v-80H600v80ZM200-200h160v-80H200v80Zm160-320Zm240-160Zm0 240ZM360-280Z",
  inventory_2:
    "M200-80q-33 0-56.5-23.5T120-160v-451q-18-11-29-28.5T80-680v-120q0-33 23.5-56.5T160-880h640q33 0 56.5 23.5T880-800v120q0 23-11 40.5T840-611v451q0 33-23.5 56.5T760-80H200Zm0-520v440h560v-440H200Zm-40-80h640v-120H160v120Zm200 280h240v-80H360v80Zm120 20Z",
  bar_chart: "M640-160v-280h160v280H640Zm-240 0v-640h160v640H400Zm-240 0v-440h160v440H160Z",
};

function svgFor(d) {
  return (
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 -960 960 960">' +
    '<path d="' + d + '"/></svg>'
  );
}

/** Create any missing Icon/<name> components from inlined Material Symbols. */
async function ensureExtraIcons(log) {
  const page = CTX.page;
  const onSurface = solid("color/on-surface");
  const names = Object.keys(EXTRA_ICONS);
  let created = 0;
  let col = 0;

  for (const name of names) {
    const existing = page.findOne((n) => n.type === "COMPONENT" && n.name === "Icon/" + name);
    if (existing) continue;

    const comp = figma.createComponent();
    comp.name = "Icon/" + name;
    comp.fills = [];
    comp.clipsContent = false;
    safeResize(comp, 24, 24);

    const art = figma.createNodeFromSvg(svgFor(EXTRA_ICONS[name]));
    if (Math.abs(art.width - 24) > 0.5) {
      try {
        art.rescale(24 / art.width);
      } catch (e) {}
    }
    art.fills = [];
    art.findAll((n) => n.type === "VECTOR").forEach((v) => (v.fills = [onSurface]));
    comp.appendChild(art);
    art.x = 0;
    art.y = 0;

    // Park it beside the imported icon grid (they end at y≈2136).
    comp.x = 80 + col * 56;
    comp.y = 2180;
    col = (col + 1) % 6;
    created++;
  }

  log(`extra icons created: ${created}/${names.length} (${names.join(", ")})`);
}
