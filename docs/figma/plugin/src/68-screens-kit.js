// ===== screens kit =====
// Shared primitives for page 02 (Screens). Frames are 390x844 compact, authored
// light-only for v1 (PLAN §3). Screens are plain frames positioned absolutely;
// content inside them uses auto-layout where it stacks.

const SCREEN_W = 390;
const SCREEN_H = 844;
const APPBAR_H = 56;
const NAVBAR_H = 72;

function findComponent(name) {
  return CTX.page.findAll((n) => n.type === "COMPONENT" && n.name === name)[0] || null;
}

function screenPage() {
  const page = figma.root.children.find((p) => p.name === "02 · Screens");
  if (!page) throw new Error('Page "02 · Screens" not found.');
  return page;
}

async function screenContext() {
  await context();
  await figma.setCurrentPageAsync(screenPage());
  CTX.screens = screenPage();
  return CTX.screens;
}

function screenFrame(name) {
  const f = figma.createFrame();
  f.name = name;
  f.fills = [solid("color/surface")];
  f.clipsContent = true;
  safeResize(f, SCREEN_W, SCREEN_H);
  return f;
}

/** Brand mark, drawn from docs/brand/source/mark.svg (64-unit grid). */
function brandMark(size) {
  const f = figma.createFrame();
  f.fills = [literal("#1E3A8A")];
  f.cornerRadius = size * 0.25;
  f.clipsContent = true;
  safeResize(f, size, size);
  const u = size / 64;
  const bars = [
    [18, 18, 28, 6],
    [18, 29, 20, 6],
    [18, 40, 28, 6],
  ];
  for (const [x, y, w, h] of bars) {
    const b = figma.createRectangle();
    b.resize(w * u, h * u);
    b.cornerRadius = 3 * u;
    b.fills = [literal("#FFFFFF")];
    f.appendChild(b);
    b.x = x * u;
    b.y = y * u;
  }
  const dot = figma.createEllipse();
  dot.resize(6 * u, 6 * u);
  dot.fills = [literal("#93C5FD")];
  f.appendChild(dot);
  dot.x = 42 * u;
  dot.y = 29 * u;
  return f;
}

async function overrideText(node, chars) {
  if (!node) return false;
  try {
    const font = node.fontName;
    if (font !== figma.mixed) await figma.loadFontAsync(font);
    node.characters = chars;
    return true;
  } catch (e) {
    warn(`could not set text "${chars}"`);
    return false;
  }
}

/** AppBar from the component set; falls back to a drawn bar if the variant is missing. */
async function appBar(frame, title, opts) {
  const o = opts || {};
  const leading = o.back ? "Back" : "None";
  let trailing = "None";
  if (o.avatar && o.action) trailing = "ActionAndAvatar";
  else if (o.avatar) trailing = "Avatar";
  else if (o.action) trailing = "Action";

  const comp = findComponent(`Leading=${leading}, Trailing=${trailing}`);
  if (comp) {
    const inst = comp.createInstance();
    frame.appendChild(inst);
    inst.x = 0;
    inst.y = 0;
    const t = inst.findOne((n) => n.type === "TEXT");
    if (t) await overrideText(t, title);
    return inst;
  }

  warn(`AppBar variant "Leading=${leading}, Trailing=${trailing}" missing; drawing one`);
  const bar = figma.createFrame();
  bar.fills = [solid("color/surface")];
  safeResize(bar, SCREEN_W, APPBAR_H);
  frame.appendChild(bar);
  bar.x = 0;
  bar.y = 0;
  const label = await text(title, "titleLarge", "color/on-surface");
  bar.appendChild(label);
  label.x = o.back ? 56 : 16;
  label.y = 15;
  return bar;
}

/** Bottom navigation drawn from icon components (a bar is not a single component). */
async function navBar(frame, role, activeIndex, cartCount) {
  const bar = figma.createFrame();
  bar.name = "NavigationBar";
  bar.fills = [solid("color/surface-container-lowest")];
  bar.clipsContent = false;
  safeResize(bar, SCREEN_W, NAVBAR_H);
  frame.appendChild(bar);
  bar.x = 0;
  bar.y = SCREEN_H - NAVBAR_H;

  const tabs =
    role === "Admin"
      ? [
          ["dashboard", "Dashboard"],
          ["inventory_2", "Products"],
          ["receipt_long", "Orders"],
          ["bar_chart", "Reports"],
        ]
      : [
          ["home", "Home"],
          ["explore", "Discover"],
          ["shopping_cart", "Cart"],
          ["receipt_long", "Orders"],
          ["person", "Profile"],
        ];

  const w = SCREEN_W / tabs.length;
  for (let i = 0; i < tabs.length; i++) {
    const glyph = tabs[i][0];
    const label = tabs[i][1];
    const active = i === activeIndex;
    const tab = figma.createFrame();
    tab.fills = [];
    tab.clipsContent = false;
    safeResize(tab, w, NAVBAR_H);
    bar.appendChild(tab);
    tab.x = i * w;
    tab.y = 0;

    const pill = figma.createFrame();
    pill.fills = active ? [solid("color/primary-container")] : [];
    pill.cornerRadius = 16;
    safeResize(pill, 64, 32);
    tab.appendChild(pill);
    pill.x = (w - 64) / 2;
    pill.y = 8;

    const glyphNode = icon(glyph, active ? "color/on-primary-container" : "color/on-surface-variant");
    if (glyphNode) {
      tab.appendChild(glyphNode);
      glyphNode.x = (w - 24) / 2;
      glyphNode.y = 12;
    }

    if (label === "Cart" && cartCount) {
      const badge = figma.createFrame();
      badge.fills = [solid("color/error")];
      badge.cornerRadius = 8;
      safeResize(badge, 16, 16);
      tab.appendChild(badge);
      badge.x = (w + 24) / 2;
      badge.y = 8;
      const n = await text(String(cartCount), "labelSmall", null);
      n.fontSize = 9;
      n.fills = [literal("#FFFFFF")];
      badge.appendChild(n);
      n.x = 4;
      n.y = 2;
    }
  }

  return bar;
}

/** Add tab labels after icons (needs async text creation). */
async function navBarLabels(bar, role, activeIndex) {
  const tabs =
    role === "Admin"
      ? ["Dashboard", "Products", "Orders", "Reports"]
      : ["Home", "Discover", "Cart", "Orders", "Profile"];
  const w = SCREEN_W / tabs.length;
  for (let i = 0; i < tabs.length; i++) {
    const active = i === activeIndex;
    const label = await text(
      tabs[i],
      "labelMedium",
      active ? "color/on-surface" : "color/on-surface-variant"
    );
    bar.appendChild(label);
    label.x = i * w + w / 2 - label.width / 2;
    label.y = 44;
  }
}

async function asyncNavBar(frame, role, activeIndex, cartCount) {
  const bar = await navBar(frame, role, activeIndex, cartCount);
  await navBarLabels(bar, role, activeIndex);
  return bar;
}

/** Instance a component by exact variant name, sized to width if requested. */
function componentInstance(name, width) {
  const comp = findComponent(name);
  if (!comp) {
    warn(`component "${name}" missing`);
    return null;
  }
  const inst = comp.createInstance();
  if (width) safeResize(inst, width, inst.height);
  return inst;
}
