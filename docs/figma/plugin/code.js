/**
 * GENERATED FILE — do not edit directly.
 * Sources: docs/figma/plugin/src/*.js (10 files)
 * Rebuild: node docs/figma/plugin/build.js
 */

// ===== 00-header.js =====
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
  labelMedium: { size: 12, weight: 600, lh: 14.4, ls: 0.15 },
  titleSmall: { size: 14, weight: 600, lh: 18.2, ls: -0.1 },
  labelSmall: { size: 11, weight: 600, lh: 13.2, ls: 0.2 },
  priceHighlight: { size: 18, weight: 700, lh: null, ls: -0.4 },
  // Not a style: code does headlineMedium.copyWith(fontSize: 26) for monograms.
  monogram: { size: 26, weight: 700, lh: null, ls: -0.5 },
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
  "color/surface-container": "#F1F5F9",
  "color/surface-container-high": "#F1F5F9",
  "color/error-container": "#FFF1F2",
  "color/on-error-container": "#BE123C",
  "color/tertiary": "#059669",
  "brand/promotion": "#FF5722",
  "brand/khqr-red": "#D32027",
  "brand/khqr-surface": "#FFFFFF",
};

const WEIGHT_STYLE = { 400: "Regular", 500: "Medium", 600: "SemiBold", 700: "Bold", 800: "ExtraBold" };

// ===== 05-extra-icons.js =====
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

// ===== 10-core.js =====
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
  if (!names || !names.length) {
    warn("float() called without candidate names");
    return null;
  }
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
  // colorName may be null when the caller recolours afterwards.
  if (colorName) {
    try {
      inst.findAll((n) => n.type === "VECTOR").forEach((v) => {
        v.fills = [solid(colorName)];
      });
    } catch (e) {
      warn(`could not recolor Icon/${name}`);
    }
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

/** Auto-layout hugs nothing by default: a new component stays 100x100 until the
 *  axes are set. hugBoth() = size to content; fixedWidth() = fixed column width
 *  with height still hugging. Both must be called AFTER children are appended. */
function hugBoth(node) {
  try {
    node.primaryAxisSizingMode = "AUTO";
  } catch (e) {}
  try {
    node.counterAxisSizingMode = "AUTO";
  } catch (e) {}
}

function fixedWidth(node, width) {
  try {
    node.counterAxisSizingMode = "FIXED";
  } catch (e) {}
  safeResize(node, width, node.height);
  try {
    node.primaryAxisSizingMode = "AUTO";
  } catch (e) {}
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
  const variantName = /^(Tone|Type|Behavior|Mode|Status|Shape|Action|State)=/;
  parent.children
    .filter((c) => c.type === "COMPONENT" && variantName.test(c.name))
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

// ===== 20-inspect.js =====
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

// ===== 30-p2a-icons.js =====
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

// ===== 40-p2b-overlays.js =====
// ---------------------------------------------------------------------------
// batch: p2b-overlays
// ---------------------------------------------------------------------------

const RADIUS = {
  r8: ["radius/r8", "radius/8", "Radius/r8", "r8"],
  r12: ["radius/r12", "radius/12", "Radius/r12", "r12"],
  r16: ["radius/r16", "radius/16", "Radius/r16", "r16"],
  r24: ["radius/r24", "radius/24", "Radius/r24", "r24"],
  full: ["radius/full", "Radius/full", "full"],
};
const SPACE = {
  xs: ["space/xs", "spacing/xs", "Space/xs"],
  sm: ["space/sm", "spacing/sm", "Space/sm"],
  md: ["space/md", "spacing/md", "Space/md"],
  lg: ["space/lg", "spacing/lg", "Space/lg"],
  xl: ["space/xl", "spacing/xl", "Space/xl"],
  xxl: ["space/xxl", "spacing/xxl", "Space/xxl"],
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

// ===== 50-p3-atoms.js =====
// ---------------------------------------------------------------------------
// batch: p3-atoms
// ---------------------------------------------------------------------------

/** Literal paint. Badge/monogram palettes are code constants, not ColorScheme slots. */
function literal(hex) {
  return { type: "SOLID", color: hexToRgb(hex) };
}

/** Mirror of statusBadgePalette in lib/core/presentation/theme/app_colors.dart. */
const BADGE_PAIRS = {
  Pending: ["#FFFBEB", "#B45309"],
  Confirmed: ["#EFF6FF", "#1D4ED8"],
  Processing: ["#EEF2FF", "#4338CA"],
  Packed: ["#F0F9FF", "#0369A1"],
  Shipped: ["#ECFEFF", "#0E7490"],
  OutForDelivery: ["#F0FDFA", "#0F766E"],
  Delivered: ["#ECFDF5", "#047857"],
  Cancelled: ["#FFF1F2", "#BE123C"],
  Refunded: ["#F1F5F9", "#334155"],
  Unknown: ["#F1F5F9", "#334155"],
};

/** Mirror of _MonogramFallback._pairs — (bg, fg), picked by code-unit sum. */
const MONO_PAIRS = [
  ["#1E3A8A", "#EFF6FF"],
  ["#059669", "#ECFDF5"],
  ["#0E7490", "#ECFEFF"],
  ["#7E22CE", "#FAF5FF"],
  ["#BE123C", "#FFF1F2"],
  ["#B45309", "#FFFBEB"],
];

function monogramPair(name) {
  const sum = name.split("").reduce((a, ch) => a + ch.charCodeAt(0), 0);
  return MONO_PAIRS[Math.abs(sum) % MONO_PAIRS.length];
}

function monogramInitials(name) {
  const words = name.trim().split(/\s+/).filter((w) => w.length > 0).slice(0, 2);
  const out = words.map((w) => w[0].toUpperCase()).join("");
  return out || "?";
}

/** Instance a Button variant if the set exposes it; otherwise nothing. */
function buttonInstance(name) {
  const comp = CTX.page.findOne((n) => n.type === "COMPONENT" && n.name === name);
  if (!comp) return null;
  try {
    return comp.createInstance();
  } catch (e) {
    return null;
  }
}

function block(width, height, fillName, radius) {
  const r = figma.createRectangle();
  r.resize(width, height);
  r.cornerRadius = radius || 0;
  r.fills = fillName ? [solid(fillName)] : [];
  return r;
}

function logVariant(c, log) {
  log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
}

// -- PriceText: Mode x Emphasis (6) -----------------------------------------

async function buildPriceText(parent, log) {
  const variants = [];
  const modes = [
    { mode: "UsdOnly", usd: "$18.00", khr: null, strike: null },
    { mode: "UsdAndKhr", usd: "$18.00", khr: "≈ 73,800 KHR", strike: null },
    { mode: "Sale", usd: "$18.00", khr: "≈ 73,800 KHR", strike: "$24.00" },
  ];
  const emphases = [
    { emphasis: "Default", ink: "color/on-surface" },
    { emphasis: "Highlight", ink: "color/primary" },
  ];

  for (const m of modes) {
    for (const e of emphases) {
      const c = figma.createComponent();
      c.name = `Mode=${m.mode}, Emphasis=${e.emphasis}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: 1 });
      c.fills = [];

      if (m.strike) {
        const old = await text(m.strike, "priceHighlight", "color/on-surface-variant");
        old.textDecoration = "STRIKETHROUGH";
        c.appendChild(old);
      }
      c.appendChild(await text(m.usd, "priceHighlight", e.ink));
      if (m.khr) {
        c.appendChild(await text(m.khr, "bodySmall", "color/on-surface-variant"));
      }
      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "PriceText";
  grid(set, variants, 2, 32, 32);
  log(`PriceText: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- StatusBadge: Status x Density (20) -------------------------------------

async function buildStatusBadge(parent, log) {
  const variants = [];
  const statuses = Object.keys(BADGE_PAIRS);
  const densities = [
    { density: "Default", pad: [4, 8, 4, 8] },
    { density: "Dense", pad: [2, 6, 2, 6] },
  ];

  for (const status of statuses) {
    for (const d of densities) {
      const c = figma.createComponent();
      c.name = `Status=${status}, Density=${d.density}`;
      parent.appendChild(c);

      autolayout(c, { dir: "HORIZONTAL", gap: 4, pad: d.pad, cross: "CENTER" });
      c.cornerRadius = 8;
      bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r8));
      c.fills = [literal(BADGE_PAIRS[status][0])];

      const label = await text(status === "OutForDelivery" ? "Out for delivery" : status, "labelSmall", null);
      label.fills = [literal(BADGE_PAIRS[status][1])];
      c.appendChild(label);

      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "StatusBadge";
  grid(set, variants, 5, 16, 16);
  log(`StatusBadge: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: badge colors are code constants (not ColorScheme slots); dark pairs are computed in code and deferred");
  return set;
}

// -- Skeleton: Shape x Density (8) -----------------------------------------

async function buildSkeleton(parent, log) {
  const variants = [];
  const shapes = ["Block", "Line", "ListView", "Grid"];
  const densities = [
    { density: "Compact", gap: 8, block: [120, 96], line: 120, cell: [100, 80] },
    { density: "Regular", gap: 16, block: [160, 128], line: 220, cell: [140, 100] },
  ];

  for (const shape of shapes) {
    for (const d of densities) {
      const c = figma.createComponent();
      c.name = `Shape=${shape}, Density=${d.density}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: d.gap });
      c.fills = [];
      bindGap(c, d.gap === 8 ? SPACE.sm : SPACE.md);

      if (shape === "Block") {
        c.appendChild(block(d.block[0], d.block[1], "color/surface-container-high", 12));
      } else if (shape === "Line") {
        c.appendChild(block(d.line, 14, "color/surface-container-high", 12));
      } else if (shape === "ListView") {
        c.appendChild(block(d.line, 14, "color/surface-container-high", 12));
        c.appendChild(block(Math.round(d.line * 0.8), 14, "color/surface-container-high", 12));
        c.appendChild(block(Math.round(d.line * 0.6), 14, "color/surface-container-high", 12));
      } else {
        const rowA = figma.createFrame();
        rowA.fills = [];
        autolayout(rowA, { dir: "HORIZONTAL", gap: d.gap });
        rowA.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        rowA.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        const rowB = figma.createFrame();
        rowB.fills = [];
        autolayout(rowB, { dir: "HORIZONTAL", gap: d.gap });
        rowB.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        rowB.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        c.appendChild(rowA);
        c.appendChild(rowB);
        hugBoth(rowA);
        hugBoth(rowB);
      }

      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "Skeleton";
  grid(set, variants, 4, 32, 32);
  log(`Skeleton: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- EmptyState: Action (2) ------------------------------------------------

function iconPlate(size, plateColorName, iconName) {
  const plate = figma.createFrame();
  plate.fills = [solid(plateColorName)];
  plate.cornerRadius = size / 2;
  autolayout(plate, { dir: "VERTICAL", cross: "CENTER" });
  plate.primaryAxisAlignItems = "CENTER";
  plate.counterAxisAlignItems = "CENTER";
  plate.primaryAxisSizingMode = "FIXED";
  plate.counterAxisSizingMode = "FIXED";
  safeResize(plate, size, size);
  const glyph = icon(iconName, "color/on-surface-variant");
  if (glyph) plate.appendChild(glyph);
  return plate;
}

async function buildEmptyState(parent, log) {
  const variants = [];
  const actions = [
    { action: "None", label: null },
    { action: "Primary", label: "Start shopping" },
  ];

  for (const a of actions) {
    const c = figma.createComponent();
    c.name = `Action=${a.action}`;
    parent.appendChild(c);

    autolayout(c, { dir: "VERTICAL", gap: 24, pad: [32, 32, 32, 32], cross: "CENTER" });
    bindSpace(c, ["top", "right", "bottom", "left"], SPACE.xl);
    bindGap(c, SPACE.lg);
    c.fills = [];

    c.appendChild(iconPlate(72, "color/surface-container", "shopping_cart"));

    const copy = figma.createFrame();
    copy.fills = [];
    autolayout(copy, { dir: "VERTICAL", gap: 8, cross: "CENTER" });
    fixedWidth(copy, 262);
    copy.counterAxisAlignItems = "CENTER";
    const title = await text("Your cart is empty", "titleMedium", "color/on-surface");
    title.textAlignHorizontal = "CENTER";
    copy.appendChild(title);

    const body = await text("Items you add will show up here.", "bodySmall", "color/on-surface-variant");
    body.textAutoResize = "HEIGHT";
    safeResize(body, 262, body.height);
    body.textAlignHorizontal = "CENTER";
    copy.appendChild(body);

    c.appendChild(copy);

    if (a.label) {
      const btn = buttonInstance("Variant=Secondary, State=Default");
      if (btn) {
        c.appendChild(btn);
      } else {
        warn("Button variant Secondary/Default not found; using a text label");
        c.appendChild(await text(a.label, "labelLarge", "color/primary"));
      }
    }

    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "EmptyState";
  grid(set, variants, 2, 32, 32);
  log(`EmptyState: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- AsyncValue: State (3) -------------------------------------------------

async function buildAsyncValue(parent, log) {
  const variants = [];

  // Loading
  {
    const c = figma.createComponent();
    c.name = "State=Loading";
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 8, pad: [16, 16, 16, 16] });
    c.fills = [];
    c.appendChild(block(294, 140, "color/surface-container-high", 12));
    c.appendChild(block(180, 14, "color/surface-container-high", 12));
    c.appendChild(block(120, 14, "color/surface-container-high", 12));
    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
  }

  // Error
  {
    const c = figma.createComponent();
    c.name = "State=Error";
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 16, pad: [32, 32, 32, 32], cross: "CENTER" });
    c.fills = [];

    const art = block(80, 80, "color/surface-container", 16);
    c.appendChild(art);

    const msg = await text("We couldn't load this right now.", "bodyMedium", "color/on-surface");
    msg.textAutoResize = "HEIGHT";
    safeResize(msg, 262, msg.height);
    msg.textAlignHorizontal = "CENTER";
    c.appendChild(msg);

    const retry = buttonInstance("Variant=Secondary, State=Default");
    if (retry) c.appendChild(retry);
    else c.appendChild(await text("Retry", "labelLarge", "color/primary"));

    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
    log("note: error art is a placeholder plate; the app uses AppIllustrations.error");
  }

  // Data
  {
    const c = figma.createComponent();
    c.name = "State=Data";
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 8, pad: [16, 16, 16, 16] });
    c.fills = [];
    c.appendChild(block(294, 160, "color/surface-container-high", 12));
    c.appendChild(block(220, 14, "color/surface-container-high", 12));
    c.appendChild(block(140, 14, "color/surface-container-high", 12));
    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "AsyncValue";
  grid(set, variants, 3, 32, 32);
  log(`AsyncValue: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- MonogramImage: State (4) ----------------------------------------------

async function buildMonogramImage(parent, log) {
  const variants = [];
  const states = [
    { state: "Loading", name: "Kirirom Coffee" },
    { state: "Loaded", name: "Kirirom Coffee" },
    { state: "Error", name: "Angkor Mart" },
    { state: "Empty", name: "" },
  ];

  for (const s of states) {
    const c = figma.createComponent();
    c.name = `State=${s.state}`;
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", cross: "CENTER" });
    c.primaryAxisAlignItems = "CENTER";
    c.counterAxisSizingMode = "FIXED";
    c.primaryAxisSizingMode = "FIXED";
    safeResize(c, 96, 96);

    if (s.state === "Loading") {
      c.fills = [solid("color/surface-container-high")];
    } else if (s.state === "Loaded") {
      c.fills = [solid("color/surface-container")];
      const label = await text("image", "bodySmall", "color/on-surface-variant");
      c.appendChild(label);
    } else {
      const [bg, fg] = monogramPair(s.name);
      c.fills = [literal(bg)];
      const initials = await text(monogramInitials(s.name), "monogram", null);
      initials.fills = [literal(fg)];
      c.appendChild(initials);
    }

    logVariant(c, log);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "MonogramImage";
  grid(set, variants, 4, 24, 24);
  log(`MonogramImage: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: accent pairs are code constants; Error and Empty render identically (both fall back to the monogram)");
  return set;
}

async function batchAtoms(log) {
  const parent = parentFor();
  const built = [];

  clearOrphans(parent);
  for (const [name, fn] of [
    ["PriceText", buildPriceText],
    ["StatusBadge", buildStatusBadge],
    ["Skeleton", buildSkeleton],
    ["EmptyState", buildEmptyState],
    ["AsyncValue", buildAsyncValue],
    ["MonogramImage", buildMonogramImage],
  ]) {
    clearOld(parent, name);
    const set = await fn(parent, log);
    placeBelow(parent, set);
    parent.appendChild(set);
    built.push(set);
  }
  return `P3 atoms — ${built.length} sets`;
}

// ===== 60-p4-cards.js =====
// ---------------------------------------------------------------------------
// batch: p4-cards
// ---------------------------------------------------------------------------

/** Small rounded label chip (product pills, availability). */
async function pill(label, bgName, fgPaint, iconName) {
  const chip = figma.createFrame();
  autolayout(chip, { dir: "HORIZONTAL", gap: 4, pad: [3, 8, 3, 8], cross: "CENTER" });
  chip.cornerRadius = 8;
  chip.fills = bgName ? [solid(bgName)] : [];

  if (iconName) {
    const g = icon(iconName, null);
    if (g) {
      g.findAll((n) => n.type === "VECTOR").forEach((v) => (v.fills = [fgPaint]));
      chip.appendChild(g);
    }
  }
  const t = await text(label, "labelSmall", null);
  t.fills = [fgPaint];
  chip.appendChild(t);

  hugBoth(chip);
  return chip;
}

// -- KhqrCard: State (3) ---------------------------------------------------

async function buildKhqrCard(parent, log) {
  const variants = [];
  const states = [
    { state: "PendingPayload", note: "Waiting for payment details", verified: false },
    { state: "Ready", note: "Scan with any KHQR-supported banking app", verified: false },
    { state: "Verified", note: "Scan with any KHQR-supported banking app", verified: true },
  ];

  for (const s of states) {
    const c = figma.createComponent();
    c.name = `State=${s.state}`;
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 0 });
    c.cornerRadius = 16;
    bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r16));
    c.fills = [solid("brand/khqr-surface")];
    c.clipsContent = true;

    // header
    const header = figma.createFrame();
    header.fills = [solid("brand/khqr-red")];
    autolayout(header, { dir: "HORIZONTAL", pad: [10, 16, 10, 16], cross: "CENTER" });
    header.primaryAxisAlignItems = "SPACE_BETWEEN";
    c.appendChild(header);
    header.layoutSizingHorizontal = "FILL";
    header.layoutSizingVertical = "HUG";

    const word = await text("KHQR", "titleLarge", null);
    word.fills = [literal("#FFFFFF")];
    word.letterSpacing = { unit: "PIXELS", value: 1.5 };
    header.appendChild(word);

    const bakong = await text("BAKONG", "labelMedium", null);
    bakong.fills = [literal("#FFFFFF")];
    bakong.letterSpacing = { unit: "PIXELS", value: 2 };
    header.appendChild(bakong);

    // body
    const body = figma.createFrame();
    body.fills = [];
    autolayout(body, { dir: "VERTICAL", gap: 4, pad: [24, 24, 24, 24], cross: "CENTER" });
    c.appendChild(body);
    body.layoutSizingHorizontal = "FILL";
    body.layoutSizingVertical = "HUG";

    body.appendChild(await text("EncueYPay Prototype", "titleMedium", "color/on-surface"));
    body.appendChild(await text("$18.00", "priceHighlight", "color/on-surface"));
    body.appendChild(await text("≈ 73,800 KHR", "bodySmall", "color/on-surface-variant"));

    const qrFrame = figma.createFrame();
    qrFrame.fills = [];
    autolayout(qrFrame, { dir: "VERTICAL", pad: [8, 8, 8, 8] });
    qrFrame.cornerRadius = 8;
    qrFrame.strokes = [solid("color/outline")];
    qrFrame.strokeWeight = 1;
    qrFrame.primaryAxisSizingMode = "AUTO";
    qrFrame.counterAxisSizingMode = "AUTO";
    body.appendChild(qrFrame);

    const qr = figma.createFrame();
    qr.resize(220, 220);
    qr.fills = [solid("color/surface-container")];
    autolayout(qr, { dir: "VERTICAL", cross: "CENTER" });
    qr.primaryAxisAlignItems = "CENTER";
    qr.counterAxisAlignItems = "CENTER";
    qr.counterAxisSizingMode = "FIXED";
    qr.primaryAxisSizingMode = "FIXED";
    safeResize(qr, 220, 220);
    qrFrame.appendChild(qr);
    qr.appendChild(
      await text(s.state === "PendingPayload" ? "no payload" : "QR payload", "bodySmall", "color/on-surface-variant")
    );

    if (s.verified) {
      const row = figma.createFrame();
      row.fills = [];
      autolayout(row, { dir: "HORIZONTAL", gap: 4, cross: "CENTER" });
      body.appendChild(row);
      const check = icon("check_circle", "color/tertiary");
      if (check) row.appendChild(check);
      row.appendChild(await text("Payment verified", "labelSmall", "color/tertiary"));
    }

    body.appendChild(await text(s.note, "labelSmall", "color/on-surface-variant"));

    fixedWidth(c, 342);
    logVariant(c, log);
    variants.push(c);
    log("note: QR is a placeholder plate — the payload is server-resolved and must not be faked");
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "KhqrCard";
  grid(set, variants, 3, 32, 32);
  log(`KhqrCard: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- OrderStatusTimeline: StageState x Terminal (6) ------------------------

const TIMELINE_STAGES = [
  "Pending", "Confirmed", "Processing", "Packed", "Shipped", "Out for Delivery", "Delivered",
];

function nodeDot(state, colorName) {
  const dot = figma.createFrame();
  dot.fills = state === "Upcoming" ? [solid("color/surface-container-lowest")] : [solid(colorName)];
  dot.cornerRadius = 11;
  dot.strokes = [solid(colorName)];
  dot.strokeWeight = 2;
  autolayout(dot, { dir: "VERTICAL", cross: "CENTER" });
  dot.primaryAxisAlignItems = "CENTER";
  dot.counterAxisAlignItems = "CENTER";
  dot.primaryAxisSizingMode = "FIXED";
  dot.counterAxisSizingMode = "FIXED";
  safeResize(dot, 22, 22);
  if (state === "Done") {
    const mark = figma.createFrame();
    mark.fills = [literal("#FFFFFF")];
    mark.cornerRadius = 5;
    safeResize(mark, 10, 10);
    dot.appendChild(mark);
  } else if (state === "Current") {
    const core = figma.createFrame();
    core.fills = [literal("#FFFFFF")];
    core.cornerRadius = 8;
    safeResize(core, 8, 8);
    dot.appendChild(core);
  }
  return dot;
}

async function buildOrderStatusTimeline(parent, log) {
  const variants = [];
  const stageStates = ["Done", "Current", "Upcoming"];
  const terminals = ["InFlight", "Cancelled"];
  const focus = 3; // the row whose state the axis controls

  for (const terminal of terminals) {
    for (const stageState of stageStates) {
      const c = figma.createComponent();
      c.name = `StageState=${stageState}, Terminal=${terminal}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: 0 });
      c.fills = [];

      if (terminal === "Cancelled") {
        const banner = figma.createFrame();
        banner.fills = [solid("color/error-container")];
        banner.cornerRadius = 12;
        autolayout(banner, { dir: "HORIZONTAL", gap: 8, pad: [16, 16, 16, 16], cross: "CENTER" });
        c.appendChild(banner);
        // Horizontal frame: width is the primary axis, so FILL it from the
        // component (fixedWidth only works on vertical layouts).
        banner.layoutSizingHorizontal = "FILL";
        banner.layoutSizingVertical = "HUG";

        const glyph = icon("error", "color/on-error-container");
        if (glyph) banner.appendChild(glyph);
        banner.appendChild(
          await text("This order was cancelled.", "bodyMedium", "color/on-error-container")
        );
        fixedWidth(c, 326);
        logVariant(c, log);
        variants.push(c);
        continue;
      }

      for (let i = 0; i < TIMELINE_STAGES.length; i++) {
        const state =
          i < focus ? "Done" : i === focus ? stageState : "Upcoming";
        const colorName =
          state === "Done" ? "color/tertiary" : state === "Current" ? "color/primary" : "color/on-surface-variant";

        const row = figma.createFrame();
        row.fills = [];
        autolayout(row, { dir: "HORIZONTAL", gap: 10, cross: "CENTER" });
        row.primaryAxisSizingMode = "AUTO";
        row.counterAxisSizingMode = "AUTO";
        c.appendChild(row);

        const track = figma.createFrame();
        track.fills = [];
        autolayout(track, { dir: "VERTICAL", gap: 0, cross: "CENTER" });
        row.appendChild(track);

        const lineColor = state === "Done" ? colorName : "color/outline-variant";
        if (i > 0) track.appendChild(rect(2, 14, lineColor, 0));
        track.appendChild(nodeDot(state, colorName));
        if (i < TIMELINE_STAGES.length - 1) track.appendChild(rect(2, 14, lineColor, 0));

        row.appendChild(
          await text(TIMELINE_STAGES[i], "labelLarge", state === "Upcoming" ? "color/on-surface-variant" : "color/on-surface")
        );
      }

      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "OrderStatusTimeline";
  grid(set, variants, 3, 40, 40);
  log(`OrderStatusTimeline: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- OrderTrackingCard: State x Detail (6) --------------------------------

async function simplifiedTimeline(labels, currentIndex) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 0, cross: "MIN" });
  for (let i = 0; i < labels.length; i++) {
    const col = figma.createFrame();
    col.fills = [];
    autolayout(col, { dir: "VERTICAL", gap: 4, cross: "CENTER" });
    col.layoutGrow = 1;
    row.appendChild(col);

    const track = figma.createFrame();
    track.fills = [];
    autolayout(track, { dir: "HORIZONTAL", cross: "CENTER" });
    col.appendChild(track);
    track.layoutAlign = "STRETCH";

    if (i > 0) {
      const seg = rect(10, 2, i <= currentIndex ? "color/tertiary" : "color/outline-variant", 0);
      seg.layoutGrow = 1;
      track.appendChild(seg);
    }
    const done = i < currentIndex;
    const current = i === currentIndex;
    const dotColor = done ? "color/tertiary" : current ? "color/primary" : "color/on-surface-variant";
    const dot = figma.createFrame();
    dot.fills = done
      ? [solid("color/tertiary")]
      : current
        ? [solid("color/primary")]
        : [];
    dot.cornerRadius = 8;
    dot.strokes = [solid(dotColor)];
    dot.strokeWeight = 2;
    dot.primaryAxisSizingMode = "FIXED";
    dot.counterAxisSizingMode = "FIXED";
    safeResize(dot, 16, 16);
    track.appendChild(dot);
    if (i < labels.length - 1) {
      const seg = rect(10, 2, i < currentIndex ? "color/tertiary" : "color/outline-variant", 0);
      seg.layoutGrow = 1;
      track.appendChild(seg);
    }

    const label = await text(labels[i], "bodySmall", i <= currentIndex ? "color/on-surface" : "color/on-surface-variant");
    label.textAutoResize = "NONE";
    safeResize(label, 70, 17);
    label.textAlignHorizontal = "CENTER";
    col.appendChild(label);
  }
  return row;
}

async function buildOrderTrackingCard(parent, log) {
  const variants = [];
  const states = ["InFlight", "Delivered", "Cancelled"];
  const details = ["Simplified", "ExactStatus"];
  const headlines = {
    InFlight: "Packed and ready to ship",
    Delivered: null,
    Cancelled: null,
  };

  for (const state of states) {
    for (const detail of details) {
      const c = figma.createComponent();
      c.name = `State=${state}, Detail=${detail}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: 4, pad: [16, 16, 16, 16] });
      c.cornerRadius = 16;
      c.strokes = [solid("color/outline-variant")];
      c.strokeWeight = 1;
      c.fills = [solid("color/surface-container-lowest")];

      if (headlines[state]) {
        c.appendChild(await text(headlines[state], "titleMedium", "color/on-surface"));
      }
      c.appendChild(await text("Order #4F2A9C81", "bodySmall", "color/on-surface-variant"));

      if (state === "InFlight") {
        const tl = await simplifiedTimeline(["Placed", "Preparing", "On its way", "Delivered"], 2);
        c.appendChild(tl);
      }

      const showExact = detail === "ExactStatus" || state !== "InFlight";
      if (showExact) {
        const exact = figma.createFrame();
        exact.fills = [];
        autolayout(exact, { dir: "VERTICAL", gap: 0 });
        c.appendChild(exact);
        // Reuse the timeline component instance.
        const tlComp = CTX.page.findOne(
          (n) => n.type === "COMPONENT" && n.name === "StageState=Current, Terminal=InFlight"
        );
        if (tlComp) {
          const inst = tlComp.createInstance();
          exact.appendChild(inst);
        } else {
          warn("OrderStatusTimeline instance not found; card renders without the exact track");
        }
      }

      if (state === "InFlight") {
        c.appendChild(await text("Show exact status", "labelLarge", "color/primary"));
      }

      fixedWidth(c, 342);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "OrderTrackingCard";
  grid(set, variants, 2, 32, 32);
  log(`OrderTrackingCard: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- ProductCard: Availability x Promo x Wishlisted x Loading (48) --------

const AVAILABILITY = {
  InStock: null,
  LowStock: "Only 3 left",
  OutOfStock: "Out of stock",
  Archived: "Archived",
};

async function buildProductCard(parent, log) {
  const variants = [];
  const W = 171;
  const H = 268;
  const IMAGE_H = 142;
  const productName = "Kirirom Coffee";
  const [monoBg, monoFg] = monogramPair(productName);

  for (const availability of Object.keys(AVAILABILITY)) {
    for (const promo of ["None", "Sale", "New"]) {
      for (const wishlisted of ["No", "Yes"]) {
        for (const loading of ["No", "Yes"]) {
          const c = figma.createComponent();
          c.name = `Availability=${availability}, Promo=${promo}, Wishlisted=${wishlisted}, Loading=${loading}`;
          parent.appendChild(c);
          autolayout(c, { dir: "VERTICAL", gap: 0 });
          c.cornerRadius = 16;
          c.fills = [solid("color/surface-container-lowest")];
          c.clipsContent = true;

          // ---- image area (fixed height so chip offsets stay deterministic) ----
          const image = figma.createFrame();
          image.fills = [];
          image.clipsContent = true;
          c.appendChild(image);
          safeResize(image, W, IMAGE_H);

          if (loading === "Yes") {
            const sk = figma.createRectangle();
            sk.resize(W, IMAGE_H);
            sk.fills = [solid("color/surface-container-high")];
            image.appendChild(sk);
            sk.x = 0;
            sk.y = 0;
          } else {
            const bg = figma.createRectangle();
            bg.resize(W, IMAGE_H);
            bg.fills = [literal(monoBg)];
            image.appendChild(bg);
            bg.x = 0;
            bg.y = 0;

            const initials = await text(monogramInitials(productName), "monogram", null);
            initials.fills = [literal(monoFg)];
            image.appendChild(initials);
            initials.x = W / 2 - initials.width / 2;
            initials.y = 60;

            if (promo === "New") {
              const chip = await pill("NEW", "brand/promotion", literal("#FFFFFF"), null);
              image.appendChild(chip);
              chip.x = 8;
              chip.y = 8;
            }
            if (promo === "Sale") {
              const chip = await pill("SALE", "brand/promotion", literal("#FFFFFF"), null);
              image.appendChild(chip);
              chip.x = 8;
              chip.y = 8;
            }
            if (AVAILABILITY[availability]) {
              const chip = await pill(
                AVAILABILITY[availability],
                "color/error-container",
                solid("color/on-error-container"),
                "error"
              );
              image.appendChild(chip);
              chip.x = W / 2 - chip.width / 2;
              chip.y = IMAGE_H - chip.height - 8;
            }
          }

          const heart = icon(wishlisted === "Yes" ? "favorite" : "favorite_border", wishlisted === "Yes" ? "color/error" : null);
          if (heart) {
            image.appendChild(heart);
            if (wishlisted !== "Yes") heart.fills = [literal("#FFFFFF")];
            heart.x = W - 32;
            heart.y = 8;
          }

          // ---- metadata ----
          const meta = figma.createFrame();
          meta.fills = [];
          autolayout(meta, { dir: "VERTICAL", gap: 2, pad: [10, 10, 10, 10] });
          c.appendChild(meta);
          meta.layoutSizingHorizontal = "FILL";

          if (loading === "Yes") {
            meta.appendChild(rect(90, 10, "color/surface-container-high", 6));
            meta.appendChild(rect(130, 12, "color/surface-container-high", 6));
            meta.appendChild(rect(60, 12, "color/surface-container-high", 6));
          } else {
            meta.appendChild(await text("Kirirom", "labelSmall", "color/on-surface-variant"));
            meta.appendChild(await text(productName, "titleSmall", "color/on-surface"));

            const rating = await text("★ 4.6 (24)", "labelSmall", "color/on-surface-variant");
            meta.appendChild(rating);

            if (promo === "Sale") {
              const priceRow = figma.createFrame();
              priceRow.fills = [];
              autolayout(priceRow, { dir: "HORIZONTAL", gap: 4, cross: "CENTER" });
              meta.appendChild(priceRow);
              const now = await text("$18.00", "titleSmall", "color/on-surface");
              now.fontSize = 15;
              priceRow.appendChild(now);
              const was = await text("$24.00", "labelSmall", "color/on-surface-variant");
              was.textDecoration = "STRIKETHROUGH";
              priceRow.appendChild(was);
            } else {
              const now = await text("$18.00", "titleSmall", "color/on-surface");
              now.fontSize = 15;
              meta.appendChild(now);
            }
            meta.appendChild(await text("≈ 73,800 KHR", "labelSmall", "color/on-surface-variant"));
          }

          c.counterAxisSizingMode = "FIXED";
          c.primaryAxisSizingMode = "FIXED";
          safeResize(c, W, H);
          variants.push(c);
        }
      }
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "ProductCard";
  grid(set, variants, 6, 24, 24);
  log(`ProductCard: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: disabled cards stay tappable in the app; Loading replaces image and metadata with skeletons");
  return set;
}

async function batchCards(log) {
  const parent = parentFor();
  const built = [];
  clearOrphans(parent);
  for (const [name, fn] of [
    ["KhqrCard", buildKhqrCard],
    ["OrderStatusTimeline", buildOrderStatusTimeline],
    ["OrderTrackingCard", buildOrderTrackingCard],
    ["ProductCard", buildProductCard],
  ]) {
    clearOld(parent, name);
    const set = await fn(parent, log);
    placeBelow(parent, set);
    parent.appendChild(set);
    built.push(set);
  }
  return `P4 cards — ${built.length} sets`;
}

// ===== 65-p5-navigation.js =====
// ===== batch: p5-nav =====
// NavigationBar as tab items (Role x State x CartBadge = 8), not whole bars:
// "State" and "CartBadge" are per-tab properties, so a bar is composed from
// item instances in the screen builders. Widths follow the tab counts —
// 390/5 = 78 (customer) and 390/4 = 97 (admin).

async function buildNavigationBar(parent, log) {
  await ensureExtraIcons(log);

  const variants = [];
  const roles = [
    { role: "Customer", glyph: "shopping_cart", label: "Cart", width: 78 },
    { role: "Admin", glyph: "receipt_long", label: "Orders", width: 97 },
  ];
  const states = ["Selected", "Unselected"];
  const badges = ["None", "Count"];
  const GW = 64;
  const GH = 32;

  for (const r of roles) {
    for (const state of states) {
      for (const badge of badges) {
        const c = figma.createComponent();
        c.name = `Role=${r.role}, State=${state}, CartBadge=${badge}`;
        parent.appendChild(c);
        autolayout(c, { dir: "VERTICAL", gap: 4, pad: [8, 0, 0, 0], cross: "CENTER" });
        c.fills = [];

        // indicator pill
        const pill = figma.createFrame();
        pill.fills = state === "Selected" ? [solid("color/primary-container")] : [];
        pill.cornerRadius = 16;
        pill.clipsContent = false;
        safeResize(pill, GW, GH);
        c.appendChild(pill);

        const glyph = icon(
          r.glyph,
          state === "Selected" ? "color/on-primary-container" : "color/on-surface-variant"
        );
        if (glyph) {
          pill.appendChild(glyph);
          glyph.x = (GW - 24) / 2;
          glyph.y = (GH - 24) / 2;
        }

        if (badge === "Count") {
          const b = figma.createFrame();
          b.fills = [solid("color/error")];
          b.cornerRadius = 8;
          b.clipsContent = false;
          autolayout(b, { dir: "VERTICAL", cross: "CENTER" });
          b.primaryAxisAlignItems = "CENTER";
          b.counterAxisAlignItems = "CENTER";
          b.primaryAxisSizingMode = "FIXED";
          b.counterAxisSizingMode = "FIXED";
          safeResize(b, 16, 16);
          pill.appendChild(b);
          b.x = GW - 22;
          b.y = -4;

          const count = await text("3", "labelSmall", null);
          count.fontSize = 9;
          count.fills = [literal("#FFFFFF")];
          b.appendChild(count);
        }

        c.appendChild(
          await text(
            r.label,
            "labelMedium",
            state === "Selected" ? "color/on-surface" : "color/on-surface-variant"
          )
        );

        c.counterAxisSizingMode = "FIXED";
        c.primaryAxisSizingMode = "FIXED";
        safeResize(c, r.width, 72);
        logVariant(c, log);
        variants.push(c);
      }
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "NavigationBar";
  grid(set, variants, 4, 24, 24);
  log(`NavigationBar: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: tab items, not whole bars — compose a bar from instances and pick State=Selected for the active tab");
  return set;
}

async function batchNavigation(log) {
  const parent = parentFor();
  clearOrphans(parent);
  clearOld(parent, "NavigationBar");
  const set = await buildNavigationBar(parent, log);
  placeBelow(parent, set);
  parent.appendChild(set);
  return "P5 nav — 1 set";
}

// ===== 70-runner-ui.js =====
// ---------------------------------------------------------------------------
// runner
// ---------------------------------------------------------------------------

const BATCHES = {
  inspect: batchInspect,
  "p2a-fix": batchIconFix,
  "p2b-overlays": batchOverlays,
  "p3-atoms": batchAtoms,
  "p4-cards": batchCards,
  "p5-nav": batchNavigation,
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
    <button data-batch="p3-atoms">P3 · atoms</button>
    <button data-batch="p4-cards">P4 · cards</button>
    <button data-batch="p5-nav">P5 · nav</button>
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
