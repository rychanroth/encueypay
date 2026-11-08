// ---------------------------------------------------------------------------
// batch: p2a-fix
// ---------------------------------------------------------------------------

const ICON_NAMES = [
  "search", "visibility", "visibility_off", "close", "arrow_back",
  "notifications_none", "more_vert", "info", "error", "check_circle",
  "warning", "refresh", "chevron_right", "favorite", "favorite_border",
  "shopping_cart", "arrow_drop_down", "person",
];

async function batchIconFix(log) {
  const page = CTX.page;
  const onSurface = solid("color/on-surface");

  const imported = {};
  page.children.forEach((n) => {
    if (n.type === "FRAME" && ICON_NAMES.includes(n.name)) imported[n.name] = n;
  });

  let replaced = 0;
  for (const name of ICON_NAMES) {
    const comp = page.findOne((n) => n.type === "COMPONENT" && n.name === "Icon/" + name);
    const art = imported[name];
    if (!comp) {
      log(`skip ${name}: no Icon/ component`);
      continue;
    }
    if (!art) {
      log(`skip ${name}: already fixed (no imported vector)`);
      continue;
    }
    comp.children.filter((c) => c.type === "TEXT").forEach((c) => c.remove());
    if (Math.abs(art.width - 24) > 0.5 || Math.abs(art.height - 24) > 0.5) {
      try {
        art.rescale(24 / art.width);
      } catch (e) {}
    }
    art.fills = [];
    try {
      art.clipsContent = false;
    } catch (e) {}
    art.findAll((n) => n.type === "VECTOR").forEach((v) => (v.fills = [onSurface]));
    comp.appendChild(art);
    replaced++;
  }

  const inputSet = page.findOne((n) => n.type === "COMPONENT_SET" && n.name === "Input");
  const appBarSet = page.findOne((n) => n.type === "COMPONENT_SET" && n.name === "AppBar");
  if (!inputSet) throw new Error('Component set "Input" not found.');
  if (!appBarSet) throw new Error('Component set "AppBar" not found.');

  inputSet.children.forEach((c) => {
    try {
      c.layoutSizingHorizontal = "FIXED";
    } catch (e) {}
    c.resize(320, 56);
  });
  grid(inputSet, inputSet.children.slice(), 4, 24, 24);

  appBarSet.children.forEach((c) => {
    try {
      c.layoutSizingHorizontal = "FIXED";
    } catch (e) {}
    c.resize(390, 56);
  });
  grid(appBarSet, appBarSet.children.slice(), 4, 24, 24);

  log(`icons replaced: ${replaced}/${ICON_NAMES.length}`);
  log(`Input ${Math.round(inputSet.width)}x${Math.round(inputSet.height)}`);
  log(`AppBar ${Math.round(appBarSet.width)}x${Math.round(appBarSet.height)}`);
  return `P2a fix — icons ${replaced}/${ICON_NAMES.length}`;
}

