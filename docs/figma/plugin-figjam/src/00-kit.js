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

/** Diagram backdrop + title (stands in for a FigJam section). */
async function fjPanel(x, y, width, height, title) {
  const bg = figma.createRectangle();
  bg.resize(width, height);
  bg.x = x;
  bg.y = y;
  bg.fills = [fjPaint(FJ.panel)];
  bg.strokes = [fjPaint(FJ.line)];
  bg.cornerRadius = 16;
  bg.name = title;
  await fjText(x + 24, y + 20, title, 20, FJ.ink, true);
  return bg;
}
