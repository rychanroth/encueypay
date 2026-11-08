// ===== batch: s5-wire =====
// The 15 wireframe screens. Each region declares a KIND, so the drawing shows
// what the widget is — field, picker, primary/outline button, toggle, stepper,
// chips, segmented control, media grid, list row, notice, summary — instead of
// one uniform band. Wire tier: no component instances, light only.

const WIRE_H = {
  heading: 28,
  labels: 18,
  field: 56,
  textarea: 96,
  picker: 56,
  button: 48,
  buttonOutline: 48,
  toggle: 40,
  stepper: 32,
  chips: 34,
  segmented: 40,
  stars: 36,
  listRow: 72,
  media: 110,
  notice: 56,
  summary: 96,
  fab: 56,
};

const WIRE_SCREENS = [
  {
    id: "reviewCompose", title: "Write a review", section: "customer", back: true,
    blocks: [
      ["listRow", "Coffee grinder · Order #4F2A9C81"],
      ["heading", "Your rating"],
      ["stars", ""],
      ["textarea", "Tell others what you think"],
      ["button", "Submit review"],
      ["notice", "Reviews are read-only after submitting"],
    ],
  },
  {
    id: "profileEdit", title: "Edit profile", section: "customer", back: true,
    blocks: [
      ["field", "Full name (required)"],
      ["field", "Phone (optional)"],
      ["button", "Save"],
    ],
  },
  {
    id: "addresses", title: "Addresses", section: "customer", back: true,
    blocks: [
      ["listRow", "Home · default · Sokha Chan"],
      ["listRow", "Office · Dara Kim"],
      ["buttonOutline", "Add address"],
      ["notice", "Empty state: one default per account, enforced by the server"],
    ],
  },
  {
    id: "addressEdit", title: "Add address", section: "customer", back: true,
    blocks: [
      ["field", "Contact name"],
      ["field", "Phone number"],
      ["buttonOutline", "Use my current location"],
      ["media", "Verification map"],
      ["picker", "Province"],
      ["picker", "District"],
      ["picker", "Commune"],
      ["picker", "Village"],
      ["field", "Street / house number"],
      ["textarea", "Additional details"],
      ["button", "Save address"],
    ],
  },
  {
    id: "wishlist", title: "Wishlist", section: "customer", back: true,
    blocks: [
      ["media", "Product card grid (2 columns)"],
      ["notice", "Empty: browse products"],
    ],
  },
  {
    id: "settings", title: "Settings", section: "customer", back: true,
    blocks: [
      ["heading", "Appearance"],
      ["labels", "Theme"],
      ["segmented", "System|Light|Dark"],
    ],
  },
  {
    id: "notFound", title: "Page not found", section: "customer", back: false,
    blocks: [
      ["notice", "Page not found: /unknown/path"],
      ["buttonOutline", "Back"],
    ],
  },

  {
    id: "adminProductForm", title: "Add product", section: "admin", back: true,
    blocks: [
      ["field", "Name"],
      ["textarea", "Description"],
      ["labels", "Variant note: price lives on the variant, not the product"],
      ["field", "Product-wide stock"],
      ["listRow", "Variants · Walnut $18.00"],
      ["picker", "Category"],
      ["picker", "Brand"],
      ["media", "Images (max 8)"],
      ["button", "Create product"],
    ],
  },
  {
    id: "adminBrands", title: "Brands", section: "admin", back: true,
    blocks: [
      ["listRow", "Kirirom · active"],
      ["listRow", "Angkor · archived"],
      ["button", "Add brand"],
    ],
  },
  {
    id: "adminCategories", title: "Categories", section: "admin", back: true,
    blocks: [
      ["listRow", "Coffee"],
      ["listRow", "↳ Beans (child)"],
      ["listRow", "Gear"],
      ["notice", "Two levels maximum — a child cannot become a parent"],
      ["button", "Create category"],
    ],
  },
  {
    id: "adminPromotions", title: "Promotions", section: "admin", back: true,
    blocks: [
      ["chips", "Sales|Coupons|Banners"],
      ["listRow", "Sale · 30% off · active"],
      ["heading", "Coupons"],
      ["listRow", "COFFEE10 · 10%"],
      ["listRow", "Banner · New season"],
      ["button", "New sale"],
    ],
  },
  {
    id: "adminArchivedCoupons", title: "Archived coupons", section: "admin", back: true,
    blocks: [
      ["notice", "Read-only: archived coupons cannot be reissued"],
      ["listRow", "OLD10 · expired"],
      ["listRow", "SUMMER · expired"],
    ],
  },
  {
    id: "adminAudit", title: "Audit logs", section: "admin", back: true,
    blocks: [
      ["listRow", "update · products · 12:04"],
      ["listRow", "transition_order · orders · 11:52"],
      ["listRow", "create_coupon · coupons · 09:31"],
      ["labels", "Latest 100 entries"],
    ],
  },
  {
    id: "adminSettings", title: "Platform settings", section: "admin", back: true,
    blocks: [
      ["field", "Delivery fee"],
      ["field", "Platform commission %"],
      ["field", "Payment account"],
      ["button", "Save settings"],
    ],
  },
  {
    id: "adminOrderDetail", title: "Order #8A11BE20", section: "admin", back: true,
    blocks: [
      ["summary", ""],
      ["button", "Advance to shipped"],
      ["buttonOutline", "Cancel order"],
      ["button", "Mark cash received"],
      ["listRow", "Items · 3"],
    ],
  },
];

// -- primitives ------------------------------------------------------------

function wireBox(width, height, opts) {
  const o = opts || {};
  const f = figma.createFrame();
  f.fills = o.fill === false ? [] : [solid(o.fill || "color/surface-container-lowest")];
  if (o.stroke !== false) {
    f.strokes = [solid(o.stroke || "color/outline-variant")];
    f.strokeWeight = 1;
  }
  f.cornerRadius = o.radius == null ? 12 : o.radius;
  f.clipsContent = o.clip !== false;
  autolayout(f, {
    dir: o.dir || "HORIZONTAL",
    gap: o.gap == null ? 8 : o.gap,
    pad: o.pad || [14, 14, 14, 14],
    cross: o.cross || "CENTER",
  });
  f.counterAxisSizingMode = "FIXED";
  f.primaryAxisSizingMode = "FIXED";
  safeResize(f, width, height);
  return f;
}

async function wireField(content, label, kind) {
  const tall = kind === "textarea";
  const box = wireBox(SCREEN_W - 32, tall ? WIRE_H.textarea : WIRE_H.field, {
    dir: "VERTICAL",
    cross: "MIN",
    pad: [10, 12, 10, 12],
    gap: 2,
  });
  box.primaryAxisSizingMode = "FIXED";
  content.appendChild(box);
  box.appendChild(await text(label, "bodyMedium", "color/on-surface-variant"));
  if (tall) {
    box.appendChild(await text("", "bodySmall", "color/on-surface-variant"));
  }
  return box;
}

async function wirePicker(content, label) {
  const box = wireBox(SCREEN_W - 32, WIRE_H.picker, { dir: "HORIZONTAL" });
  content.appendChild(box);
  const t = await text(label, "bodyMedium", "color/on-surface-variant");
  t.layoutGrow = 1;
  box.appendChild(t);
  const chev = icon("arrow_drop_down", "color/on-surface-variant");
  if (chev) box.appendChild(chev);
  return box;
}

async function wireButton(content, label, primary) {
  const box = wireBox(SCREEN_W - 32, WIRE_H.button, {
    dir: "HORIZONTAL",
    fill: primary ? "color/primary" : false,
    stroke: primary ? false : "color/outline-variant",
    radius: 8,
    pad: [14, 16, 14, 16],
  });
  box.primaryAxisAlignItems = "CENTER";
  content.appendChild(box);
  box.appendChild(await text(label, "labelLarge", primary ? "color/on-primary" : "color/on-surface"));
  return box;
}

async function wireToggle(content, label) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", cross: "CENTER" });
  content.appendChild(row);
  fill(row);
  const t = await text(label, "bodyMedium", "color/on-surface");
  t.layoutGrow = 1;
  row.appendChild(t);

  const track = figma.createFrame();
  track.fills = [solid("color/primary")];
  track.cornerRadius = 999;
  track.primaryAxisSizingMode = "FIXED";
  track.counterAxisSizingMode = "FIXED";
  safeResize(track, 40, 22);
  row.appendChild(track);
  const knob = figma.createFrame();
  knob.fills = [literal("#FFFFFF")];
  knob.cornerRadius = 9;
  knob.primaryAxisSizingMode = "FIXED";
  knob.counterAxisSizingMode = "FIXED";
  safeResize(knob, 18, 18);
  track.appendChild(knob);
  knob.x = 20;
  knob.y = 2;
  return row;
}

async function wireStepper(content, label) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", cross: "CENTER" });
  content.appendChild(row);
  fill(row);
  const t = await text(label, "bodyMedium", "color/on-surface");
  t.layoutGrow = 1;
  row.appendChild(t);

  const step = wireBox(88, 32, { radius: 999, pad: [4, 10, 4, 10], gap: 10 });
  row.appendChild(step);
  step.appendChild(await text("−", "labelLarge", "color/on-surface"));
  step.appendChild(await text("3", "labelLarge", "color/on-surface"));
  step.appendChild(await text("+", "labelLarge", "color/on-surface"));
  return row;
}

async function wireChips(content, spec) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 8 });
  content.appendChild(row);
  const labels = spec.split("|");
  for (let i = 0; i < labels.length; i++) {
    row.appendChild(await chipAsync(labels[i], i === 0));
  }
  return row;
}

async function wireSegmented(content, spec) {
  const labels = spec.split("|");
  const box = wireBox(SCREEN_W - 32, WIRE_H.segmented, {
    fill: "color/surface-container",
    stroke: false,
    radius: 8,
    pad: [4, 4, 4, 4],
    gap: 4,
  });
  content.appendChild(box);
  for (let i = 0; i < labels.length; i++) {
    const seg = figma.createFrame();
    seg.fills = i === 0 ? [solid("color/surface-container-lowest")] : [];
    seg.cornerRadius = 6;
    autolayout(seg, { dir: "HORIZONTAL", pad: [6, 8, 6, 8] });
    seg.primaryAxisAlignItems = "CENTER";
    seg.layoutGrow = 1;
    box.appendChild(seg);
    seg.appendChild(
      await text(labels[i], "labelMedium", i === 0 ? "color/on-surface" : "color/on-surface-variant")
    );
  }
  return box;
}

async function wireStars(content) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 8 });
  content.appendChild(row);
  for (let i = 0; i < 5; i++) {
    const star = icon("favorite_border", i < 4 ? "color/primary" : "color/on-surface-variant");
    if (star) {
      try {
        star.rescale(1.4);
      } catch (e) {}
      row.appendChild(star);
    }
  }
  return row;
}

async function wireListRow(content, label) {
  const box = wireBox(SCREEN_W - 32, WIRE_H.listRow, { dir: "HORIZONTAL", pad: [12, 12, 12, 12] });
  content.appendChild(box);
  const t = await text(label, "bodyMedium", "color/on-surface");
  t.layoutGrow = 1;
  box.appendChild(t);
  const chev = icon("chevron_right", "color/on-surface-variant");
  if (chev) box.appendChild(chev);
  return box;
}

async function wireMedia(content, label) {
  const wrap = figma.createFrame();
  wrap.fills = [];
  autolayout(wrap, { dir: "VERTICAL", gap: 6 });
  content.appendChild(wrap);
  wrap.appendChild(await text(label, "labelMedium", "color/on-surface-variant"));

  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 8 });
  wrap.appendChild(row);
  for (let i = 0; i < 3; i++) {
    const tile = wireBox(96, 76, { fill: "color/surface-container", stroke: false, pad: [0, 0, 0, 0] });
    row.appendChild(tile);
    tile.layoutGrow = 1;
    safeResize(tile, 96, 76);
  }
  return wrap;
}

async function wireNotice(content, label) {
  const box = wireBox(SCREEN_W - 32, WIRE_H.notice, {
    fill: "color/primary-container",
    stroke: false,
    pad: [12, 12, 12, 12],
  });
  content.appendChild(box);
  const glyph = icon("info", "color/on-primary-container");
  if (glyph) box.appendChild(glyph);
  const t = await text(label, "bodySmall", "color/on-primary-container");
  t.layoutGrow = 1;
  box.appendChild(t);
  return box;
}

async function wireSummary(content) {
  const box = wireBox(SCREEN_W - 32, WIRE_H.summary, {
    dir: "VERTICAL",
    cross: "MIN",
    pad: [12, 12, 12, 12],
    gap: 4,
  });
  content.appendChild(box);
  for (const [k, v] of [
    ["Subtotal", "$48.00"],
    ["Delivery", "$1.50"],
    ["Total", "$49.50"],
  ]) {
    const row = figma.createFrame();
    row.fills = [];
    autolayout(row, { dir: "HORIZONTAL" });
    box.appendChild(row);
    fill(row);
    row.primaryAxisAlignItems = "SPACE_BETWEEN";
    row.appendChild(await text(k, k === "Total" ? "titleSmall" : "bodySmall", "color/on-surface"));
    row.appendChild(await text(v, k === "Total" ? "priceHighlight" : "bodySmall", "color/on-surface"));
  }
  return box;
}

async function wireFab(content) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL" });
  content.appendChild(row);
  fill(row);
  row.primaryAxisAlignItems = "MAX";

  const fab = figma.createFrame();
  fab.fills = [solid("color/primary")];
  fab.cornerRadius = 28;
  fab.primaryAxisSizingMode = "FIXED";
  fab.counterAxisSizingMode = "FIXED";
  safeResize(fab, 56, 56);
  row.appendChild(fab);
  const h = figma.createRectangle();
  h.resize(20, 2);
  h.cornerRadius = 1;
  h.fills = [literal("#FFFFFF")];
  fab.appendChild(h);
  h.x = 18;
  h.y = 27;
  const v = figma.createRectangle();
  v.resize(2, 20);
  v.cornerRadius = 1;
  v.fills = [literal("#FFFFFF")];
  fab.appendChild(v);
  v.x = 27;
  v.y = 18;
  return row;
}

async function renderWireBlock(content, kind, label) {
  switch (kind) {
    case "heading":
      content.appendChild(await text(label, "titleMedium", "color/on-surface"));
      return;
    case "labels":
      content.appendChild(await text(label, "labelMedium", "color/on-surface-variant"));
      return;
    case "field":
    case "textarea":
      return wireField(content, label, kind);
    case "picker":
      return wirePicker(content, label);
    case "button":
      return wireButton(content, label, true);
    case "buttonOutline":
      return wireButton(content, label, false);
    case "toggle":
      return wireToggle(content, label);
    case "stepper":
      return wireStepper(content, label);
    case "chips":
      return wireChips(content, label);
    case "segmented":
      return wireSegmented(content, label);
    case "stars":
      return wireStars(content);
    case "listRow":
      return wireListRow(content, label);
    case "media":
      return wireMedia(content, label);
    case "notice":
      return wireNotice(content, label);
    case "summary":
      return wireSummary(content);
    case "fab":
      return wireFab(content);
    default:
      warn(`unknown wire kind: ${kind}`);
      return wireListRow(content, label);
  }
}

async function buildWireScreen(section, spec) {
  const f = screenFrame(`Screen/${spec.id}/wire`);
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;
  f.fills = [solid("color/surface-container-lowest")];
  f.strokes = [solid("color/outline-variant")];
  f.strokeWeight = 1;

  await appBar(f, spec.title, { back: spec.back });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H);

  for (const [kind, label] of spec.blocks) {
    await renderWireBlock(content, kind, label);
  }

  return f;
}

async function batchWire(log) {
  const page = await screenContext();
  const customer = sectionFor(page, "S · Customer");
  const admin = sectionFor(page, "S · Admin");

  for (const spec of WIRE_SCREENS) {
    const name = `Screen/${spec.id}/wire`;
    const old = page.findOne((n) => n.name === name);
    if (old) old.remove();
  }

  let count = 0;
  for (const spec of WIRE_SCREENS) {
    await buildWireScreen(spec.section === "admin" ? admin : customer, spec);
    log(`${spec.id} built`);
    count++;
  }
  return `S5 — ${count} wire screens`;
}
