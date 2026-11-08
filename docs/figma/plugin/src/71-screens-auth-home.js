// ===== batch: s1-auth-home =====
// First pixel screens: login (outside the shell) and home (customer tab 1).

function sectionFor(page, name) {
  let s = page.children.find((n) => n.type === "SECTION" && n.name === name);
  if (!s) {
    s = figma.createSection();
    s.name = name;
    s.x = 0;
    s.y = 0;
    s.resizeWithoutConstraints(1600, 1400);
  }
  return s;
}

/** Place the next screen to the right of everything already in the section. */
function nextSlot(section, gap) {
  let maxRight = 0;
  section.children.forEach((c) => {
    maxRight = Math.max(maxRight, c.x + c.width);
  });
  return { x: maxRight === 0 ? 80 : maxRight + gap, y: 80 };
}

function stack(parent, opts) {
  const o = opts || {};
  const f = figma.createFrame();
  f.fills = [];
  autolayout(f, {
    dir: o.dir || "VERTICAL",
    gap: o.gap == null ? 0 : o.gap,
    pad: o.pad || [0, 0, 0, 0],
    cross: o.cross || "MIN",
  });
  parent.appendChild(f);
  if (o.width) fixedWidth(f, o.width);
  else f.layoutSizingHorizontal = "FILL";
  return f;
}

function fill(frame) {
  try {
    frame.layoutSizingHorizontal = "FILL";
  } catch (e) {}
  return frame;
}

async function heading(label, parent, gapBefore) {
  if (gapBefore) spacer(parent, gapBefore);
  const t = await text(label, "titleMedium", "color/on-surface");
  parent.appendChild(t);
  return t;
}

function spacer(parent, height) {
  const f = figma.createFrame();
  f.fills = [];
  parent.appendChild(f);
  f.layoutSizingHorizontal = "FILL";
  f.layoutSizingVertical = "FIXED";
  safeResize(f, 10, height);
  return f;
}

async function inputField(parent, kind, state, hint) {
  const name = `Type=${kind}, State=${state}`;
  const inst = componentInstance(name, 320);
  if (!inst) {
    const box = figma.createFrame();
    box.fills = [solid("color/surface-container-lowest")];
    box.cornerRadius = 12;
    box.strokes = [solid("color/outline-variant")];
    box.strokeWeight = 1;
    autolayout(box, { dir: "HORIZONTAL", pad: [16, 14, 16, 14], cross: "CENTER" });
    box.primaryAxisSizingMode = "FIXED";
    box.counterAxisSizingMode = "FIXED";
    safeResize(box, 320, 56);
    box.appendChild(await text(hint, "bodyMedium", "color/on-surface-variant"));
    parent.appendChild(box);
    return box;
  }
  parent.appendChild(inst);
  const t = inst.findOne((n) => n.type === "TEXT");
  if (t) await overrideText(t, hint);
  return inst;
}

async function buttonK(parent, variant, state, label, width) {
  const inst = componentInstance(`Variant=${variant}, State=${state}`, width || 320);
  if (!inst) {
    warn(`Button Variant=${variant}, State=${state} missing; drawing one`);
    const pill = figma.createFrame();
    pill.fills = [solid(variant === "Primary" ? "color/primary" : "color/surface-container-lowest")];
    pill.cornerRadius = 8;
    autolayout(pill, { dir: "HORIZONTAL", pad: [14, 24, 14, 24], cross: "CENTER" });
    pill.primaryAxisAlignItems = "CENTER";
    pill.primaryAxisSizingMode = "FIXED";
    pill.counterAxisSizingMode = "FIXED";
    safeResize(pill, width || 320, 48);
    pill.appendChild(await text(label, "labelLarge", variant === "Primary" ? "color/on-primary" : "color/on-surface"));
    parent.appendChild(pill);
    return pill;
  }
  parent.appendChild(inst);
  const t = inst.findOne((n) => n.type === "TEXT");
  if (t) await overrideText(t, label);
  return inst;
}

// -- login -----------------------------------------------------------------

async function buildLogin(section) {
  const f = screenFrame("Screen/login/signin");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  const form = figma.createFrame();
  form.fills = [];
  autolayout(form, { dir: "VERTICAL", gap: 16, cross: "CENTER" });
  f.appendChild(form);
  fixedWidth(form, 320);
  form.x = (SCREEN_W - 320) / 2;
  form.y = 140;

  form.appendChild(brandMark(56));
  spacer(form, 8);
  form.appendChild(await text("EncueYPay", "headlineMedium", "color/on-surface"));
  form.appendChild(await text("Sign in to continue", "bodyMedium", "color/on-surface-variant"));
  spacer(form, 16);

  await inputField(form, "Text", "Enabled", "Email");
  await inputField(form, "Password", "Enabled", "Password");

  const forgotRow = figma.createFrame();
  forgotRow.fills = [];
  autolayout(forgotRow, { dir: "HORIZONTAL" });
  forgotRow.primaryAxisAlignItems = "MAX";
  form.appendChild(forgotRow);
  fill(forgotRow);
  forgotRow.appendChild(await text("Forgot password?", "labelLarge", "color/primary"));

  spacer(form, 8);
  await buttonK(form, "Primary", "Default", "Sign in");

  spacer(form, 8);

  const divider = figma.createFrame();
  divider.fills = [];
  autolayout(divider, { dir: "HORIZONTAL", gap: 12, cross: "CENTER" });
  form.appendChild(divider);
  fill(divider);
  const lineA = figma.createRectangle();
  lineA.resize(128, 1);
  lineA.fills = [solid("color/outline-variant")];
  divider.appendChild(lineA);
  divider.appendChild(await text("or", "bodySmall", "color/on-surface-variant"));
  const lineB = figma.createRectangle();
  lineB.resize(128, 1);
  lineB.fills = [solid("color/outline-variant")];
  divider.appendChild(lineB);

  await buttonK(form, "Outline", "Default", "Continue with Google");

  spacer(form, 16);

  const toggle = figma.createFrame();
  toggle.fills = [];
  autolayout(toggle, { dir: "HORIZONTAL", gap: 4, cross: "CENTER" });
  toggle.primaryAxisAlignItems = "CENTER";
  form.appendChild(toggle);
  fill(toggle);
  toggle.appendChild(await text("New here?", "bodyMedium", "color/on-surface-variant"));
  toggle.appendChild(await text("Create an account", "labelLarge", "color/primary"));

  return f;
}

// -- home ------------------------------------------------------------------

async function buildHome(section) {
  const f = screenFrame("Screen/home/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "EncueYPay", { action: true, avatar: true });

  const content = figma.createFrame();
  content.fills = [];
  autolayout(content, { dir: "VERTICAL", gap: 20, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  // search
  const search = figma.createFrame();
  search.fills = [solid("color/surface-container")];
  search.cornerRadius = 24;
  autolayout(search, { dir: "HORIZONTAL", gap: 8, pad: [10, 16, 10, 16], cross: "CENTER" });
  content.appendChild(search);
  fill(search);
  const sIcon = icon("search", "color/on-surface-variant");
  if (sIcon) search.appendChild(sIcon);
  search.appendChild(await text("Search products", "bodyMedium", "color/on-surface-variant"));

  // banner
  const banner = figma.createFrame();
  banner.fills = [solid("color/primary-container")];
  banner.cornerRadius = 16;
  autolayout(banner, { dir: "VERTICAL", gap: 4, pad: [20, 20, 20, 20] });
  content.appendChild(banner);
  fill(banner);
  banner.primaryAxisSizingMode = "FIXED";
  safeResize(banner, SCREEN_W - 32, 148);
  banner.appendChild(await text("NEW SEASON", "labelMedium", "color/on-primary-container"));
  banner.appendChild(await text("Up to 30% off coffee gear", "titleLarge", "color/on-primary-container"));
  banner.appendChild(await text("Ends Sunday", "bodySmall", "color/on-primary-container"));

  // dots
  const dots = figma.createFrame();
  dots.fills = [];
  autolayout(dots, { dir: "HORIZONTAL", gap: 6, cross: "CENTER" });
  content.appendChild(dots);
  dots.primaryAxisAlignItems = "CENTER";
  for (let i = 0; i < 3; i++) {
    const d = figma.createEllipse();
    d.resize(i === 0 ? 7 : 5, i === 0 ? 7 : 5);
    d.fills = [solid(i === 0 ? "color/primary" : "color/outline-variant")];
    dots.appendChild(d);
  }

  // categories
  await heading("Shop by category", content);
  const catRow = stack(content, { dir: "HORIZONTAL", gap: 12 });
  for (const [label, glyph] of [
    ["Coffee", "home"],
    ["Gear", "inventory_2"],
  ]) {
    const card = figma.createFrame();
    card.fills = [solid("color/surface-container")];
    card.cornerRadius = 16;
    autolayout(card, { dir: "VERTICAL", gap: 8, pad: [16, 16, 16, 16] });
    catRow.appendChild(card);
    card.layoutGrow = 1;
    card.counterAxisSizingMode = "FIXED";
    safeResize(card, (SCREEN_W - 32 - 12) / 2, 128);
    const g = icon(glyph, "color/on-surface-variant");
    if (g) card.appendChild(g);
    card.appendChild(await text(label, "titleSmall", "color/on-surface"));
  }

  // brands rail
  await heading("Top brands", content);
  const rail = stack(content, { dir: "HORIZONTAL", gap: 12 });
  safeResize(rail, SCREEN_W - 32, 108);
  for (const name of ["Kirirom", "Angkor", "Tonle"]) {
    const tile = figma.createFrame();
    tile.fills = [solid("color/surface-container")];
    tile.cornerRadius = 16;
    autolayout(tile, { dir: "VERTICAL", gap: 4, pad: [12, 12, 12, 12], cross: "CENTER" });
    rail.appendChild(tile);
    tile.counterAxisSizingMode = "FIXED";
    safeResize(tile, 108, 108);
    tile.appendChild(await text(monogramInitials(name), "monogram", "color/on-surface-variant"));
    tile.appendChild(await text(name, "labelSmall", "color/on-surface-variant"));
  }

  // new arrivals
  await heading("New arrivals", content);
  const grid = stack(content, { dir: "HORIZONTAL", gap: 12 });
  for (let i = 0; i < 2; i++) {
    const card = componentInstance("Availability=InStock, Promo=New, Wishlisted=No, Loading=No");
    if (card) {
      grid.appendChild(card);
      card.layoutGrow = 1;
    } else {
      warn("ProductCard instance missing");
    }
  }

  await asyncNavBar(f, "Customer", 0, 3);
  return f;
}

async function batchAuthHome(log) {
  const page = await screenContext();
  const customer = sectionFor(page, "S · Customer");
  for (const [name, fn] of [
    ["Screen/login/signin", buildLogin],
    ["Screen/home/loaded", buildHome],
  ]) {
    const old = customer.findOne((n) => n.name === name);
    if (old) old.remove();
  }
  await buildLogin(customer);
  log("login built");
  await buildHome(customer);
  log("home built");
  return `S1 — 2 screens on ${page.name}`;
}
