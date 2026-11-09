// ===== EncueYPay Flows — FigJam kit =====
// A board has no pages, no components and no variables, so this plugin shares
// nothing with the design builder except a hex parser. Shapes carry their own
// text; connectors carry their own labels.

const FJ = {
  ink: "#0F172A",
  muted: "#64748B",
  line: "#CBD5E1",
  primary: "#1E3A8A",
  primarySoft: "#EFF6FF",
  panel: "#F8FAFC",
  warnSoft: "#FFFBEB",
  warnInk: "#B45309",
};

const WARNINGS = [];

function warn(message) {
  if (!WARNINGS.includes(message)) WARNINGS.push(message);
}

function hexToRgb(hex) {
  const h = hex.replace("#", "");
  return {
    r: parseInt(h.slice(0, 2), 16) / 255,
    g: parseInt(h.slice(2, 4), 16) / 255,
    b: parseInt(h.slice(4, 6), 16) / 255,
  };
}

let FJ_FONT_READY = false;

async function fjFont() {
  if (FJ_FONT_READY) return;
  await figma.loadFontAsync({ family: "Inter", style: "Regular" });
  FJ_FONT_READY = true;
}

function fjPaint(hex) {
  return { type: "SOLID", color: hexToRgb(hex) };
}

async function fjText(x, y, chars, size, hex, bold) {
  await fjFont();
  const t = figma.createText();
  t.fontName = { family: "Inter", style: "Regular" };
  if (bold) {
    try {
      await figma.loadFontAsync({ family: "Inter", style: "Bold" });
      t.fontName = { family: "Inter", style: "Bold" };
    } catch (e) {}
  }
  t.characters = chars;
  t.fontSize = size || 14;
  t.fills = [fjPaint(hex || FJ.ink)];
  t.x = x;
  t.y = y;
  return t;
}

async function fjShape(x, y, w, h, chars, opts) {
  const o = opts || {};
  await fjFont();
  const n = figma.createShapeWithText();
  try {
    n.shapeType = o.shape || "ROUNDED_RECTANGLE";
  } catch (e) {}
  n.resize(w, h);
  n.x = x;
  n.y = y;
  n.fills = [fjPaint(o.fill || "#FFFFFF")];
  n.strokes = [fjPaint(o.stroke || FJ.line)];
  try {
    n.text.fontName = { family: "Inter", style: "Regular" };
    n.text.characters = chars;
    n.text.fontSize = o.size || 13;
  } catch (e) {
    warn(`shape text failed: ${String(chars).split("\n")[0]}`);
  }
  return n;
}

/** Connector between two shapes. Reports failure rather than throwing. */
function fjConnect(from, to, label) {
  try {
    const c = figma.createConnector();
    c.connectorStart = { endpointNodeId: from.id, magnet: "AUTO" };
    c.connectorEnd = { endpointNodeId: to.id, magnet: "AUTO" };
    c.connectorLineType = "ELBOWED";
    c.strokes = [fjPaint(FJ.line)];
    c.strokeWeight = 2;
    if (label) {
      try {
        c.text.characters = label;
        c.text.fontSize = 11;
      } catch (e) {}
    }
    return c;
  } catch (e) {
    warn(`connector failed: ${(e && e.message) || e}`);
    return null;
  }
}

/** Invisible 1x1 anchor so a connector can span two arbitrary points. */
function fjPoint(x, y) {
  const r = figma.createRectangle();
  r.resize(1, 1);
  r.x = x;
  r.y = y;
  r.fills = [];
  r.strokes = [];
  r.name = "anchor";
  return r;
}

/** Straight arrow between two points (sequence messages). */
function fjArrowBetween(x1, y1, x2, y2, label) {
  const a = fjPoint(x1, y1);
  const b = fjPoint(x2, y2);
  try {
    const c = figma.createConnector();
    c.connectorStart = { endpointNodeId: a.id, magnet: "AUTO" };
    c.connectorEnd = { endpointNodeId: b.id, magnet: "AUTO" };
    c.connectorLineType = "STRAIGHT";
    try {
      c.connectorEndStrokeCap = "ARROW_EQUILATERAL";
    } catch (e) {}
    c.strokes = [fjPaint(FJ.muted)];
    c.strokeWeight = 1.5;
    if (label) {
      try {
        c.text.characters = label;
        c.text.fontSize = 11;
      } catch (e) {}
    }
    return c;
  } catch (e) {
    warn(`arrow failed: ${(e && e.message) || e}`);
    return null;
  }
}

let FJ_BEFORE = null;
let FJ_PANEL = null;

/** Diagram backdrop + title. Records the page so fjEnd() can group what was added. */
async function fjPanel(x, y, width, height, title) {
  FJ_BEFORE = new Set(figma.currentPage.children.map((n) => n.id));
  const bg = figma.createRectangle();
  bg.resize(width, height);
  bg.x = x;
  bg.y = y;
  bg.fills = [fjPaint(FJ.panel)];
  bg.strokes = [fjPaint(FJ.line)];
  bg.cornerRadius = 16;
  bg.name = title;
  await fjText(x + 24, y + 20, title, 20, FJ.ink, true);
  FJ_PANEL = bg;
  return bg;
}

/**
 * Close a diagram: fit the backdrop to what was actually drawn, then group backdrop,
 * title, shapes, lifelines, connectors and anchors into one node named after the
 * diagram. A group is the only FigJam container that carries its children when moved;
 * naming it is also what makes a re-run idempotent (fjClear removes it wholesale).
 */
async function fjEnd(pad) {
  const page = figma.currentPage;
  const bg = FJ_PANEL;
  const added = page.children.filter((n) => !FJ_BEFORE.has(n.id));
  const content = added.filter((n) => n !== bg);
  FJ_PANEL = null;
  FJ_BEFORE = null;
  if (!bg || !content.length) return null;

  let minX = Infinity;
  let minY = Infinity;
  let maxX = -Infinity;
  let maxY = -Infinity;
  content.forEach((n) => {
    minX = Math.min(minX, n.x);
    minY = Math.min(minY, n.y);
    maxX = Math.max(maxX, n.x + n.width);
    maxY = Math.max(maxY, n.y + n.height);
  });
  if (!isFinite(minX)) return null;

  const p = pad || 24;
  bg.x = minX - p;
  bg.y = minY - p;
  bg.resize(maxX - minX + p * 2, maxY - minY + p * 2);

  const name = bg.name;
  let group = null;
  try {
    group = figma.group([bg].concat(content), page);
    group.name = name;
  } catch (e) {
    // Leave it ungrouped rather than lose the drawing; the next run's area sweep
    // still cleans it up, because the backdrop carries the diagram name.
    warn(`could not group "${name}": ${(e && e.message) || e}`);
  }
  const w = Math.round((group || bg).width);
  const h = Math.round((group || bg).height);
  return { name, w, h };
}

/**
 * Remove nodes, tolerating ones already deleted as a side effect. A removed shape
 * takes its connectors with it, so a snapshot of page children goes stale mid-loop.
 */
function fjRemove(nodes) {
  let n = 0;
  (nodes || []).forEach((node) => {
    try {
      if (!node.removed) {
        node.remove();
        n++;
      }
    } catch (e) {
      // already removed with a parent or with a connector endpoint
    }
  });
  return n;
}

/**
 * Remove previously built diagrams by name — grouped (normal) or legacy (a backdrop
 * rectangle plus loose children positioned inside it).
 */
function fjClear(names) {
  const page = figma.currentPage;

  fjRemove(page.children.filter((n) => n.type === "GROUP" && names.includes(n.name)));

  const legacy = page.children.filter((n) => names.includes(n.name));
  const boxes = legacy.map((n) => ({ x: n.x, y: n.y, w: n.width, h: n.height }));
  if (boxes.length) {
    fjRemove(legacy);
    // Legacy children are page-level and unnamed, so sweep by position: anything whose
    // centre sits in a removed backdrop belongs to that diagram.
    fjRemove(
      page.children.filter((n) => {
        const cx = n.x + n.width / 2;
        const cy = n.y + n.height / 2;
        return boxes.some((b) => cx > b.x - 40 && cx < b.x + b.w + 40 && cy > b.y - 40 && cy < b.y + b.h + 40);
      })
    );
  }

  fjRemove(page.children.filter((n) => n.name === "anchor"));
}
