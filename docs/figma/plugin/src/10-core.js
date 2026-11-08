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
  // Enabling layoutMode leaves both axes FIXED at the frame's birth size
  // (100x100), so every frame that does not explicitly pin an axis renders
  // 100 tall. Hug by default; callers pin afterwards when a size is intended.
  hugBoth(node);
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

