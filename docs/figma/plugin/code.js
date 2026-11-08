/**
 * EncueYPay — Figma mirror builder (local development plugin).
 *
 * Runs the mirror builders through the Plugin API with no MCP metering.
 * Each batch is a function in BATCHES. The plugin shows a tiny UI so several
 * batches can run in one session without re-importing.
 *
 * Batches
 *   inspect      — dump variables, text styles, fonts and page inventory
 *   p2a-fix      — replace font-glyph icons with imported vectors; fix widths
 *   p2b-overlays — Snackbar (3), Dialog (2), BottomSheet (4)
 *
 * Idempotency: a batch deletes the sets it owns before rebuilding them.
 * Source of truth: docs/figma/spec/{tokens,components}.json.
 */

const PAGE_NAME = "01 · Foundations & Components";
const FAMILY = "Plus Jakarta Sans";

/** Typography, copied from docs/figma/spec/tokens.json (figmaName is Type/<name>). */
const TYPE = {
  titleLarge: { size: 20, weight: 600, lh: 26, ls: -0.3 },
  titleMedium: { size: 16, weight: 600, lh: 21.6, ls: -0.2 },
  bodyMedium: { size: 14, weight: 400, lh: 20.3, ls: 0 },
  bodySmall: { size: 12, weight: 400, lh: 16.8, ls: 0 },
  labelLarge: { size: 14, weight: 600, lh: 16.8, ls: 0.1 },
};

/** Last-resort colors, used only when a variable cannot be resolved. */
const FALLBACK = {
  "color/inverse-surface": "#0F172A",
  "color/on-inverse-surface": "#FFFFFF",
  "color/inverse-primary": "#93C5FD",
  "color/surface-container-lowest": "#FFFFFF",
  "color/on-surface": "#0F172A",
  "color/on-surface-variant": "#64748B",
  "color/primary": "#1E3A8A",
  "color/error": "#E11D48",
  "color/outline-variant": "#E2E8F0",
};

const WEIGHT_STYLE = { 400: "Regular", 500: "Medium", 600: "SemiBold", 700: "Bold", 800: "ExtraBold" };

// ---------------------------------------------------------------------------
// context
// ---------------------------------------------------------------------------

let CTX = null;

async function context() {
  if (CTX) return CTX;
  await figma.loadAllPagesAsync();

  const page = figma.root.children.find((p) => p.name === PAGE_NAME);
  if (!page) throw new Error(`Page "${PAGE_NAME}" not found.`);
  await figma.setCurrentPageAsync(page);

  const collections = await figma.variables.getLocalVariableCollectionsAsync();
  const light = collections.find((c) => c.name === "Color");
  const vars = await figma.variables.getLocalVariablesAsync();

  // Colors: light collection only (dark lives in "Color Dark" with same names).
  // Floats: every collection — spacing/radius tokens are not in "Color".
  const colors = new Map();
  const floats = new Map();
  const collectionName = new Map(collections.map((c) => [c.id, c.name]));
  for (const v of vars) {
    if (v.resolvedType === "COLOR" && light && v.variableCollectionId === light.id) {
      colors.set(v.name, v);
    }
    if (v.resolvedType === "FLOAT") floats.set(v.name, v);
  }

  const styles = new Map();
  (await figma.getLocalTextStylesAsync()).forEach((s) => styles.set(s.name, s));

  const available = await figma.listAvailableFontsAsync();
  const faces = available
    .filter((f) => f.fontName.family === FAMILY)
    .map((f) => f.fontName);

  const loaded = new Set();
  // A new text node is born as Inter Regular; preload it so nothing throws.
  try {
    await figma.loadFontAsync({ family: "Inter", style: "Regular" });
    loaded.add("Inter|Regular");
  } catch (e) {}

  CTX = {
    page, collections, colors, floats, styles, faces, loaded,
    collectionName, warnings: [], resolved: [],
  };
  return CTX;
}

function warn(message) {
  if (CTX && !CTX.warnings.includes(message)) CTX.warnings.push(message);
}

// ---------------------------------------------------------------------------
// primitives
// ---------------------------------------------------------------------------

function solid(name) {
  const c = CTX.colors.get(name);
  if (!c) {
    warn(`variable ${name} missing`);
    return { type: "SOLID", color: hexToRgb(FALLBACK[name] || "#FF00FF") };
  }
  return figma.variables.setBoundVariableForPaint(
    { type: "SOLID", color: { r: 0, g: 0, b: 0 } },
    "color",
    c
  );
}

function hexToRgb(hex) {
  const h = hex.replace("#", "");
  return {
    r: parseInt(h.slice(0, 2), 16) / 255,
    g: parseInt(h.slice(2, 4), 16) / 255,
    b: parseInt(h.slice(4, 6), 16) / 255,
  };
}

/** Resolve a FLOAT variable by exact name, then by a de-prefixed fuzzy match. */
function normName(s) {
  return String(s).toLowerCase().replace(/[^a-z0-9]/g, "");
}

const GENERIC = ["space", "spacing", "radius", "size", "dimension", "dimen", "token", "tokens", "scale", "corner"];

function float(names) {
  for (const n of names) {
    const v = CTX.floats.get(n);
    if (v) return v;
  }
  const parts = normName(names[0]).match(/[a-z]+|\d+/g) || [];
  const core = parts.filter((p) => !GENERIC.includes(p));
  if (core.length) {
    const hits = [...CTX.floats.entries()].filter(([key]) => {
      const nk = normName(key);
      return core.every((p) => nk.includes(p));
    });
    if (hits.length === 1) {
      CTX.resolved.push(`${names[0]} -> ${hits[0][0]}`);
      return hits[0][1];
    }
    if (hits.length > 1) {
      warn(`float ${names[0]}: ${hits.length} candidates (${hits.map((h) => h[0]).join(", ")})`);
      return null;
    }
  }
  warn(`float ${names[0]} unresolved`);
  return null;
}

function bindFloat(node, fields, variable) {
  if (!variable) return;
  for (const field of fields) {
    try {
      node.setBoundVariable(field, variable);
    } catch (e) {
      warn(`cannot bind ${field} on ${node.type}: ${(e && e.message) || e}`);
    }
  }
}

const PAD_FIELD = {
  top: "paddingTop",
  right: "paddingRight",
  bottom: "paddingBottom",
  left: "paddingLeft",
};

function bindSpace(node, sides, token) {
  bindFloat(node, sides.map((s) => PAD_FIELD[s]), float(token));
}

function bindGap(node, token) {
  bindFloat(node, ["itemSpacing"], float(token));
}

function faceFor(weight) {
  const want = WEIGHT_STYLE[weight] || "Regular";
  const norm = (s) => s.toLowerCase().replace(/[^a-z]/g, "");
  const exact = CTX.faces.find((f) => f.style === want);
  if (exact) return exact;
  const loose = CTX.faces.find((f) => norm(f.style) === norm(want));
  if (loose) return loose;
  warn(`font style "${want}" not found; using ${CTX.faces[0] ? CTX.faces[0].style : "default"}`);
  return CTX.faces[0] || { family: FAMILY, style: "Regular" };
}

async function loadFace(weight) {
  const face = faceFor(weight);
  const key = `${face.family}|${face.style}`;
  if (!CTX.loaded.has(key)) {
    await figma.loadFontAsync(face);
    CTX.loaded.add(key);
  }
  return face;
}

/** Create a text node bound to a Type/* text style when that style exists. */
async function text(chars, typeName, colorName) {
  const spec = TYPE[typeName];
  if (!spec) throw new Error(`unknown type ${typeName}`);

  const node = figma.createText();
  const face = await loadFace(spec.weight);

  // Order matters: the node is born as "Inter Regular", so load/assign the real
  // face BEFORE writing characters, or Figma rejects the write on an unloaded font.
  node.fontName = face;
  node.characters = chars;
  node.fontSize = spec.size;
  node.letterSpacing = { unit: "PIXELS", value: spec.ls };
  if (spec.lh) node.lineHeight = { unit: "PIXELS", value: spec.lh };
  node.textAutoResize = "WIDTH_AND_HEIGHT";

  const style = CTX.styles.get("Type/" + typeName);
  if (style) {
    try {
      // dynamic-page manifests must use the async setter.
      await node.setTextStyleIdAsync(style.id);
    } catch (e) {
      warn(`could not apply Type/${typeName}: ${(e && e.message) || e}`);
    }
  }

  if (colorName) node.fills = [solid(colorName)];
  return node;
}

/** resize() throws on some hug-sized nodes; fall back to unconstrained. */
function safeResize(node, width, height) {
  try {
    node.resize(width, height);
    return true;
  } catch (e) {}
  try {
    node.resizeWithoutConstraints(width, height);
    return true;
  } catch (e) {
    warn(`resize failed on ${node.name || node.type}`);
    return false;
  }
}

function rect(width, height, colorName, radius) {  const r = figma.createRectangle();
  r.resize(width, height);
  if (radius) r.cornerRadius = radius;
  r.fills = [solid(colorName)];
  return r;
}

/** Instance Icon/<name> at 24dp, recolored through the vector override. */
function icon(name, colorName) {
  const comp = CTX.page.findOne(
    (n) => n.type === "COMPONENT" && n.name === "Icon/" + name
  );
  if (!comp) {
    warn(`icon Icon/${name} missing`);
    return null;
  }
  const inst = comp.createInstance();
  inst.resize(24, 24);
  try {
    inst.findAll((n) => n.type === "VECTOR").forEach((v) => {
      v.fills = [solid(colorName)];
    });
  } catch (e) {
    warn(`could not recolor Icon/${name}`);
  }
  return inst;
}

function autolayout(node, opts) {
  node.layoutMode = opts.dir || "VERTICAL";
  if (opts.gap != null) node.itemSpacing = opts.gap;
  if (opts.pad) {
    node.paddingTop = opts.pad[0];
    node.paddingRight = opts.pad[1];
    node.paddingBottom = opts.pad[2];
    node.paddingLeft = opts.pad[3];
  }
  node.primaryAxisAlignItems = opts.main || "MIN";
  node.counterAxisAlignItems = opts.cross || "MIN";
  if (opts.cross === "CENTER") {
    node.counterAxisAlignItems = "CENTER";
  }
}

/** Lay variants out on a grid sized by the tallest cell in each row / column. */
function grid(set, variants, cols, gapX, gapY) {
  const rows = Math.ceil(variants.length / cols);
  const rowH = new Array(rows).fill(0);
  const colW = new Array(cols).fill(0);

  variants.forEach((c, i) => {
    const r = Math.floor(i / cols);
    const k = i % cols;
    rowH[r] = Math.max(rowH[r], c.height);
    colW[k] = Math.max(colW[k], c.width);
  });

  const yOff = [];
  let y = 0;
  for (let r = 0; r < rows; r++) {
    yOff[r] = y;
    y += rowH[r] + gapY;
  }
  const xOff = [];
  let x = 0;
  for (let k = 0; k < cols; k++) {
    xOff[k] = x;
    x += colW[k] + gapX;
  }

  variants.forEach((c, i) => {
    c.x = xOff[i % cols];
    c.y = yOff[Math.floor(i / cols)];
  });

  try {
    set.resizeWithoutConstraints(x - gapX, y - gapY);
  } catch (e) {}
}

function parentFor(cls) {
  const section = CTX.page.findOne(
    (n) => n.type === "SECTION" && /component/i.test(n.name)
  );
  return section || CTX.page;
}

/** Rebuild in place: drop a previous generation of this set, then place it. */
function clearOld(parent, name) {
  const old = parent.findOne((n) => n.type === "COMPONENT_SET" && n.name === name);
  if (old) old.remove();
}

/** A failed run can leave loose variants behind; they would block the next combine. */
function clearOrphans(parent) {
  const prefixes = ["Tone=", "Type=", "Behavior="];
  parent.children
    .filter((c) => c.type === "COMPONENT" && prefixes.some((p) => c.name.startsWith(p)))
    .forEach((c) => c.remove());
}

function placeBelow(parent, set) {
  let maxY = 0;
  let minX = Infinity;
  parent.children.forEach((c) => {
    if (c === set) return;
    maxY = Math.max(maxY, c.y + c.height);
    minX = Math.min(minX, c.x);
  });
  if (!isFinite(minX)) minX = 0;
  if (parent !== CTX.page) {
    set.x = 64;
    set.y = Math.max(0, maxY + 120);
  } else {
    set.x = minX;
    set.y = maxY + 160;
  }
}

// ---------------------------------------------------------------------------
// batch: inspect
// ---------------------------------------------------------------------------

async function batchInspect(log) {
  log(`page: ${CTX.page.name}`);
  log(`-- color variables (${CTX.colors.size}) --`);
  log([...CTX.colors.keys()].sort().join("\n"));

  log(`-- float variables (${CTX.floats.size}) --`);
  if (!CTX.floats.size) {
    log("(none — spacing/radius are literals in this file)");
  } else {
    [...CTX.floats.entries()]
      .sort((a, b) => a[0].localeCompare(b[0]))
      .forEach(([name, v]) => {
        const values = Object.values(v.valuesByMode || {}).join(",");
        const coll = CTX.collectionName.get(v.variableCollectionId) || "?";
        log(`${name}\t${values}\t[${coll}]`);
      });
  }

  log(`-- resolutions P2b needs --`);
  const probes = [
    ...Object.values(RADIUS).map((c) => c[0]),
    ...Object.values(SPACE).map((c) => c[0]),
  ];
  probes.forEach((p) => {
    const hit = float([p]);
    log(`${p}\t${hit ? "FOUND" : "missing"}`);
  });
  if (CTX.resolved.length) log("fuzzy: " + CTX.resolved.join(" | "));

  log(`-- text styles (${CTX.styles.size}) --`);
  log([...CTX.styles.keys()].sort().join("\n"));

  log(`-- ${FAMILY} faces (${CTX.faces.length}) --`);
  log(CTX.faces.map((f) => f.style).sort().join(", ") || "(family not installed)");

  log(`-- top-level nodes on ${PAGE_NAME} --`);
  CTX.page.children.forEach((c) =>
    log(`${c.type}\t${c.name}\t${Math.round(c.x)},${Math.round(c.y)}\t${Math.round(c.width)}x${Math.round(c.height)}`)
  );

  log(`-- component sets --`);
  CTX.page.findAll((n) => n.type === "COMPONENT_SET").forEach((s) => {
    const props = s.variantGroupProperties
      ? Object.keys(s.variantGroupProperties).join(", ")
      : "";
    log(`${s.name}\t${s.children.length} variants\t[${props}]`);
  });

  return "inspect done — copy this log back";
}

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

// ---------------------------------------------------------------------------
// batch: p2b-overlays
// ---------------------------------------------------------------------------

const RADIUS = {
  r12: ["radius/r12", "radius/12", "Radius/r12", "r12"],
  r24: ["radius/r24", "radius/24", "Radius/r24", "r24"],
  full: ["radius/full", "Radius/full", "full"],
};
const SPACE = {
  xs: ["space/xs", "spacing/xs", "Space/xs"],
  sm: ["space/sm", "spacing/sm", "Space/sm"],
  md: ["space/md", "spacing/md", "Space/md"],
  lg: ["space/lg", "spacing/lg", "Space/lg"],
};

async function buildSnackbar(parent, log) {
  const variants = [];
  const tones = [
    { tone: "Info", copy: "Changes saved", iconName: "check_circle", action: null },
    { tone: "Error", copy: "Could not reach the server", iconName: "error", action: null },
    { tone: "Action", copy: "Item removed from cart", iconName: null, action: "Undo" },
  ];

  for (const t of tones) {
    const c = figma.createComponent();
    c.name = "Tone=" + t.tone;
    parent.appendChild(c);

    autolayout(c, { dir: "HORIZONTAL", gap: 12, pad: [16, 16, 16, 16], cross: "CENTER" });
    bindSpace(c, ["top", "right", "bottom", "left"], SPACE.md);
    c.primaryAxisAlignItems = "SPACE_BETWEEN";
    c.cornerRadius = 12;
    bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r12));
    c.fills = [solid("color/inverse-surface")];

    if (t.iconName) {
      const i = icon(t.iconName, "color/on-inverse-surface");
      if (i) c.appendChild(i);
    }

    const label = await text(t.copy, "bodyMedium", "color/on-inverse-surface");
    c.appendChild(label);
    try {
      label.layoutGrow = 1;
    } catch (e) {}

    if (t.action) {
      const a = await text(t.action, "labelLarge", "color/inverse-primary");
      c.appendChild(a);
    }

    c.primaryAxisSizingMode = "FIXED";
    safeResize(c, 358, c.height);
    c.counterAxisSizingMode = "AUTO";
    c.minHeight = 56; // text-only tones must match icon tones
    log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "Snackbar";
  grid(set, variants, 3, 24, 24);
  log(`Snackbar: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

async function buildDialog(parent, log) {
  const variants = [];
  const kinds = [
    {
      type: "Default",
      title: "Discard changes?",
      body: "Your edits have not been saved.",
      confirm: "Discard",
      confirmColor: "color/primary",
    },
    {
      type: "DestructiveConfirm",
      title: "Delete this product?",
      body: "Products with orders are archived instead of deleted.",
      confirm: "Delete",
      confirmColor: "color/error",
    },
  ];

  for (const k of kinds) {
    const c = figma.createComponent();
    c.name = "Type=" + k.type;
    parent.appendChild(c);

    autolayout(c, { dir: "VERTICAL", gap: 16, pad: [24, 24, 24, 24] });
    bindSpace(c, ["top", "right", "bottom", "left"], SPACE.lg);
    bindGap(c, SPACE.md);
    c.cornerRadius = 24;
    bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r24));
    c.fills = [solid("color/surface-container-lowest")];

    const title = await text(k.title, "titleLarge", "color/on-surface");
    c.appendChild(title);

    const body = await text(k.body, "bodyMedium", "color/on-surface-variant");
    body.textAutoResize = "HEIGHT";
    safeResize(body, 352, body.height);
    c.appendChild(body);

    const actions = figma.createFrame();
    actions.name = "Actions";
    actions.fills = [];
    autolayout(actions, { dir: "HORIZONTAL", gap: 8, cross: "CENTER" });
    bindGap(actions, SPACE.sm);
    actions.primaryAxisAlignItems = "MAX";
    actions.primaryAxisSizingMode = "FIXED";
    actions.counterAxisSizingMode = "AUTO";
    safeResize(actions, 352, 48);
    c.appendChild(actions);

    const cancel = await text("Cancel", "labelLarge", "color/on-surface-variant");
    actions.appendChild(cancel);

    const confirm = await text(k.confirm, "labelLarge", k.confirmColor);
    actions.appendChild(confirm);

    c.counterAxisSizingMode = "FIXED";
    safeResize(c, 400, c.height);
    c.primaryAxisSizingMode = "AUTO";
    log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "Dialog";
  grid(set, variants, 2, 24, 24);
  log(`Dialog: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

async function buildBottomSheet(parent, log) {
  const variants = [];
  const combos = [
    { behavior: "Default", header: "Text" },
    { behavior: "Default", header: "TextAndHandle" },
    { behavior: "ScrollControlled", header: "Text" },
    { behavior: "ScrollControlled", header: "TextAndHandle" },
  ];

  for (const combo of combos) {
    const c = figma.createComponent();
    c.name = `Behavior=${combo.behavior}, Header=${combo.header}`;
    parent.appendChild(c);

    autolayout(c, { dir: "VERTICAL", gap: 16, pad: [24, 16, 24, 16] });
    bindSpace(c, ["top", "bottom"], SPACE.lg);
    bindSpace(c, ["left", "right"], SPACE.md);
    bindGap(c, SPACE.md);
    c.cornerRadius = 24;
    c.topLeftRadius = 24;
    c.topRightRadius = 24;
    c.bottomLeftRadius = 0;
    c.bottomRightRadius = 0;
    bindFloat(c, ["topLeftRadius", "topRightRadius"], float(RADIUS.r24));
    c.fills = [solid("color/surface-container-lowest")];

    if (combo.header === "TextAndHandle") {
      const handle = rect(32, 4, "color/outline-variant", 2);
      bindFloat(handle, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.full));
      c.appendChild(handle);
    }

    const title = await text("Choose a delivery address", "titleLarge", "color/on-surface");
    c.appendChild(title);

    const body = await text(
      "Saved addresses and a new-address option would be listed here.",
      "bodyMedium",
      "color/on-surface-variant"
    );
    body.textAutoResize = "HEIGHT";
    safeResize(body, 342, body.height);
    c.appendChild(body);

    c.counterAxisSizingMode = "FIXED";
    safeResize(c, 390, c.height);
    if (combo.behavior === "Default") {
      c.primaryAxisSizingMode = "AUTO";
    } else {
      c.primaryAxisSizingMode = "FIXED";
      safeResize(c, 390, 480);
      c.clipsContent = true;
    }
    log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "BottomSheet";
  grid(set, variants, 2, 32, 32);
  log(`BottomSheet: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

async function batchOverlays(log) {
  const parent = parentFor();
  const built = [];

  clearOrphans(parent);

  for (const [name, fn] of [
    ["Snackbar", buildSnackbar],
    ["Dialog", buildDialog],
    ["BottomSheet", buildBottomSheet],
  ]) {
    clearOld(parent, name);
    const set = await fn(parent, log);
    placeBelow(parent, set);
    built.push(set);
    // keep a readable column: each new set sits under the previous one
    parent.appendChild(set);
  }

  return `P2b overlays — ${built.length} sets`;
}

// ---------------------------------------------------------------------------
// runner
// ---------------------------------------------------------------------------

const BATCHES = {
  inspect: batchInspect,
  "p2a-fix": batchIconFix,
  "p2b-overlays": batchOverlays,
};

async function run(batch) {
  const fn = BATCHES[batch];
  const log = (s) => figma.ui.postMessage({ type: "log", text: String(s) });
  if (!fn) {
    log(`unknown batch: ${batch}`);
    return;
  }
  log(`=== ${batch} ===`);
  figma.ui.postMessage({ type: "start", batch });
  try {
    await context();
    const summary = await fn(log);
    if (CTX.warnings.length) {
      log(`warnings (${CTX.warnings.length}):`);
      CTX.warnings.forEach((w) => log("  ! " + w));
    }
    log(`done: ${summary}`);
    figma.notify(summary, { timeout: 8000 });
  } catch (err) {
    const message = (err && err.message) || String(err);
    log(`FAILED: ${message}`);
    if (err && err.stack) log(err.stack);
    figma.notify(`Build failed: ${message}`, { error: true, timeout: 15000 });
  }
  figma.ui.postMessage({ type: "done" });
}

// ---------------------------------------------------------------------------
// ui
// ---------------------------------------------------------------------------

const HTML = `
<!doctype html>
<html>
<head>
<style>
  body { margin: 0; font: 11px/1.5 -apple-system, "Segoe UI", system-ui, sans-serif;
         background: #1e1e1e; color: #e6e6e6; }
  .bar { display: flex; flex-wrap: wrap; gap: 6px; padding: 10px; background: #2c2c2c;
         border-bottom: 1px solid #3d3d3d; position: sticky; top: 0; }
  button { font: inherit; padding: 5px 9px; border-radius: 6px; cursor: pointer;
           border: 1px solid #4a4a4a; background: #383838; color: #e6e6e6; }
  button:hover:not(:disabled) { background: #454545; }
  button:disabled { opacity: .45; cursor: default; }
  textarea { width: 100%; height: 300px; box-sizing: border-box; border: 0;
             background: #1e1e1e; color: #cfd8e3; font: 11px/1.45 ui-monospace, Menlo, monospace;
             padding: 10px; resize: none; outline: none; }
</style>
</head>
<body>
  <div class="bar">
    <button data-batch="inspect">Inspect</button>
    <button data-batch="p2a-fix">P2a · icons</button>
    <button data-batch="p2b-overlays">P2b · overlays</button>
    <button id="copy">Copy log</button>
  </div>
  <textarea id="log" readonly placeholder="Run a batch to see its report."></textarea>
<script>
  var logEl = document.getElementById("log");
  var buttons = Array.prototype.slice.call(document.querySelectorAll("button"));

  function setBusy(busy) {
    buttons.forEach(function (b) { b.disabled = busy; });
  }

  buttons.forEach(function (b) {
    b.onclick = function () {
      var batch = b.getAttribute("data-batch");
      if (!batch) return;
      setBusy(true);
      parent.postMessage({ pluginMessage: { type: "run", batch: batch } }, "*");
    };
  });

  document.getElementById("copy").onclick = function () {
    logEl.select();
    try { document.execCommand("copy"); } catch (e) {}
    if (navigator.clipboard) navigator.clipboard.writeText(logEl.value);
  };

  window.onmessage = function (event) {
    var m = event.data && event.data.pluginMessage;
    if (!m) return;
    if (m.type === "log") {
      logEl.value += m.text + "\\n";
      logEl.scrollTop = logEl.scrollHeight;
    }
    if (m.type === "start") {
      if (logEl.value) logEl.value += "\\n";
    }
    if (m.type === "done") setBusy(false);
  };
</script>
</body>
</html>
`;

figma.showUI(HTML, { width: 520, height: 420, themeColors: true });

figma.ui.onmessage = async (msg) => {
  if (msg && msg.type === "run") await run(msg.batch);
};
