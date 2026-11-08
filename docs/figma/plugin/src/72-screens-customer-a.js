// ===== batch: s2-customer-a =====
// Customer pixel screens: productDetail, cart, discovery, notifications.

async function chipAsync(label, selected) {
  const c = figma.createFrame();
  c.fills = selected ? [solid("color/primary-container")] : [solid("color/surface-container")];
  c.cornerRadius = 999;
  autolayout(c, { dir: "HORIZONTAL", gap: 4, pad: [6, 12, 6, 12], cross: "CENTER" });
  c.appendChild(
    await text(
      label,
      "labelMedium",
      selected ? "color/on-primary-container" : "color/on-surface-variant"
    )
  );
  hugBoth(c);
  return c;
}

async function chipRow(parent, labels, selectedIndex) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 8 });
  parent.appendChild(row);
  for (let i = 0; i < labels.length; i++) {
    row.appendChild(await chipAsync(labels[i], i === selectedIndex));
  }
  return row;
}

function cardBase(width, height, fillName, radius) {
  const f = figma.createFrame();
  f.fills = fillName ? [solid(fillName)] : [];
  f.cornerRadius = radius == null ? 16 : radius;
  f.strokes = [solid("color/outline-variant")];
  f.strokeWeight = 1;
  f.clipsContent = true;
  safeResize(f, width, height);
  return f;
}

function imageTile(width, height, name, radius) {
  const tile = figma.createFrame();
  const pair = monogramPair(name);
  tile.fills = [literal(pair[0])];
  tile.cornerRadius = radius == null ? 12 : radius;
  tile.clipsContent = true;
  safeResize(tile, width, height);
  return tile;
}

async function initialsInto(tile, name) {
  const t = await text(monogramInitials(name), "monogram", null);
  t.fills = [literal(monogramPair(name)[1])];
  tile.appendChild(t);
  t.x = tile.width / 2 - t.width / 2;
  t.y = tile.height / 2 - t.height / 2;
  return t;
}

// -- productDetail ---------------------------------------------------------

async function buildProductDetail(section) {
  const f = screenFrame("Screen/productDetail/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Coffee grinder", { back: true, action: true });

  const barH = 80;
  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - barH);

  // hero image + KHQR badge
  const hero = imageTile(SCREEN_W - 32, 260, "Coffee grinder", 16);
  content.appendChild(hero);
  await initialsInto(hero, "Coffee grinder");
  const khqrBadge = figma.createFrame();
  khqrBadge.fills = [solid("brand/khqr-red")];
  khqrBadge.cornerRadius = 8;
  autolayout(khqrBadge, { dir: "HORIZONTAL", pad: [4, 8, 4, 8] });
  hero.appendChild(khqrBadge);
  khqrBadge.x = hero.width - 76;
  khqrBadge.y = 12;
  const khqrLabel = await text("KHQR", "labelSmall", null);
  khqrLabel.fills = [literal("#FFFFFF")];
  khqrBadge.appendChild(khqrLabel);

  // variant thumb rail
  const rail = figma.createFrame();
  rail.fills = [];
  autolayout(rail, { dir: "HORIZONTAL", gap: 8 });
  content.appendChild(rail);
  for (let i = 0; i < 4; i++) {
    const thumb = imageTile(64, 64, "Variant " + (i + 1), 12);
    rail.appendChild(thumb);
    await initialsInto(thumb, "V" + (i + 1));
  }

  content.appendChild(await text("Kirirom", "labelSmall", "color/primary"));
  content.appendChild(await text("Coffee grinder — hand burr", "titleLarge", "color/on-surface"));

  const ratingRow = figma.createFrame();
  ratingRow.fills = [];
  autolayout(ratingRow, { dir: "HORIZONTAL", gap: 6, cross: "CENTER" });
  content.appendChild(ratingRow);
  ratingRow.appendChild(await text("★ 4.6", "labelSmall", "color/on-surface"));
  ratingRow.appendChild(await text("(24 reviews)", "labelSmall", "color/on-surface-variant"));

  content.appendChild(await text("In stock · ships in 2 days", "bodySmall", "color/tertiary"));
  content.appendChild(await text("$18.00", "priceHighlight", "color/on-surface"));
  content.appendChild(await text("≈ 73,800 KHR", "bodySmall", "color/on-surface-variant"));

  // promises
  const promises = cardBase(SCREEN_W - 32, 96, "color/surface-container-lowest", 16);
  promises.fills = [solid("color/surface-container")];
  promises.strokes = [];
  promises.clipsContent = false;
  autolayout(promises, { dir: "VERTICAL", gap: 6, pad: [12, 12, 12, 12] });
  promises.counterAxisSizingMode = "FIXED";
  content.appendChild(promises);
  safeResize(promises, SCREEN_W - 32, 96);
  for (const line of ["Cash on delivery available", "KHQR payment accepted", "7-day returns"]) {
    promises.appendChild(await text(line, "bodySmall", "color/on-surface"));
  }

  content.appendChild(await text("Description", "titleMedium", "color/on-surface"));
  content.appendChild(
    await text(
      "A compact hand grinder with a stainless burr and a walnut body. Consistent grind for filter coffee.",
      "bodyMedium",
      "color/on-surface-variant"
    )
  );

  content.appendChild(await text("Reviews", "titleMedium", "color/on-surface"));
  for (const [who, body] of [
    ["Sokha", "Grinds evenly, feels solid."],
    ["Dara", "Great for the price."],
  ]) {
    const review = cardBase(SCREEN_W - 32, 76, null, 12);
    review.strokes = [];
    review.fills = [solid("color/surface-container")];
    review.clipsContent = false;
    autolayout(review, { dir: "VERTICAL", gap: 4, pad: [10, 10, 10, 10] });
    review.counterAxisSizingMode = "FIXED";
    content.appendChild(review);
    safeResize(review, SCREEN_W - 32, 76);
    review.appendChild(await text(who + " · ★★★★★", "labelSmall", "color/on-surface"));
    review.appendChild(await text(body, "bodySmall", "color/on-surface-variant"));
  }

  // related
  content.appendChild(await text("You may also like", "titleMedium", "color/on-surface"));
  const related = figma.createFrame();
  related.fills = [];
  autolayout(related, { dir: "HORIZONTAL", gap: 12 });
  content.appendChild(related);
  for (let i = 0; i < 2; i++) {
    const card = componentInstance("Availability=InStock, Promo=None, Wishlisted=No, Loading=No");
    if (card) related.appendChild(card);
  }

  // fixed bottom bar
  const bar = figma.createFrame();
  bar.fills = [solid("color/surface-container-lowest")];
  bar.strokes = [solid("color/outline-variant")];
  bar.strokeWeight = 1;
  autolayout(bar, { dir: "HORIZONTAL", gap: 12, pad: [16, 16, 16, 16], cross: "CENTER" });
  f.appendChild(bar);
  bar.x = 0;
  bar.y = SCREEN_H - barH;
  bar.primaryAxisSizingMode = "FIXED";
  bar.counterAxisSizingMode = "FIXED";
  safeResize(bar, SCREEN_W, barH);

  const wish = figma.createFrame();
  wish.fills = [];
  wish.strokes = [solid("color/outline-variant")];
  wish.strokeWeight = 1;
  wish.cornerRadius = 8;
  wish.primaryAxisSizingMode = "FIXED";
  wish.counterAxisSizingMode = "FIXED";
  safeResize(wish, 48, 48);
  bar.appendChild(wish);
  const heart = icon("favorite_border", "color/on-surface");
  if (heart) {
    wish.appendChild(heart);
    heart.x = 12;
    heart.y = 12;
  }

  const cta = await buttonK(bar, "Primary", "Default", "Add to Cart", 282);
  cta.layoutGrow = 1;

  return f;
}

// -- cart ------------------------------------------------------------------

async function cartLine(parent, name, variantName, qty, lineTotal) {
  const line = cardBase(SCREEN_W - 32, 88, "color/surface-container-lowest", 16);
  line.clipsContent = false;
  parent.appendChild(line);

  const img = imageTile(64, 64, name, 12);
  line.appendChild(img);
  img.x = 12;
  img.y = 12;
  await initialsInto(img, name);

  const col = figma.createFrame();
  col.fills = [];
  autolayout(col, { dir: "VERTICAL", gap: 2 });
  line.appendChild(col);
  col.x = 88;
  col.y = 12;
  col.counterAxisSizingMode = "FIXED";
  safeResize(col, 180, 64);
  col.appendChild(await text(name, "titleSmall", "color/on-surface"));
  col.appendChild(await text(variantName, "bodySmall", "color/on-surface-variant"));
  col.appendChild(await text("$18.00 × " + qty, "bodySmall", "color/on-surface-variant"));
  col.appendChild(await text(lineTotal, "labelLarge", "color/on-surface"));

  const step = figma.createFrame();
  step.fills = [];
  step.strokes = [solid("color/outline-variant")];
  step.strokeWeight = 1;
  step.cornerRadius = 999;
  step.primaryAxisSizingMode = "FIXED";
  step.counterAxisSizingMode = "FIXED";
  safeResize(step, 88, 32);
  line.appendChild(step);
  step.x = 258;
  step.y = 44;
  const minus = await text("−", "labelLarge", "color/on-surface");
  step.appendChild(minus);
  minus.x = 12;
  minus.y = 6;
  const q = await text(String(qty), "labelLarge", "color/on-surface");
  step.appendChild(q);
  q.x = 42;
  q.y = 6;
  const plus = await text("+", "labelLarge", "color/on-surface");
  step.appendChild(plus);
  plus.x = 68;
  plus.y = 6;

  return line;
}

async function buildCart(section) {
  const f = screenFrame("Screen/cart/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Cart", { action: true });

  const dockH = 88;
  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - dockH - NAVBAR_H);

  await cartLine(content, "Coffee grinder", "Walnut", 1, "$18.00");
  await cartLine(content, "Kirirom beans", "500 g · Medium", 2, "$24.00");
  await cartLine(content, "Paper filters", "100 pack", 1, "$6.00");

  const dock = figma.createFrame();
  dock.fills = [solid("color/surface-container-lowest")];
  dock.strokes = [solid("color/outline-variant")];
  dock.strokeWeight = 1;
  autolayout(dock, { dir: "HORIZONTAL", gap: 12, pad: [16, 16, 16, 16], cross: "CENTER" });
  f.appendChild(dock);
  dock.x = 0;
  dock.y = SCREEN_H - NAVBAR_H - dockH;
  dock.primaryAxisSizingMode = "FIXED";
  dock.counterAxisSizingMode = "FIXED";
  safeResize(dock, SCREEN_W, dockH);

  const totals = figma.createFrame();
  totals.fills = [];
  autolayout(totals, { dir: "VERTICAL", gap: 2 });
  dock.appendChild(totals);
  totals.appendChild(await text("Total", "labelSmall", "color/on-surface-variant"));
  totals.appendChild(await text("$48.00", "priceHighlight", "color/on-surface"));
  totals.appendChild(await text("≈ 196,800 KHR", "bodySmall", "color/on-surface-variant"));

  const cta = await buttonK(dock, "Primary", "Default", "Checkout", 180);
  cta.layoutGrow = 1;

  await asyncNavBar(f, "Customer", 2, 4);
  return f;
}

// -- discovery -------------------------------------------------------------

async function buildDiscovery(section) {
  const f = screenFrame("Screen/discovery/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Discover", { action: false });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  const search = screenSearchField();
  content.appendChild(search);
  fill(search);
  await inputInto(search, "Search products");

  // deep-link banner
  const banner = figma.createFrame();
  banner.fills = [solid("color/primary-container")];
  banner.cornerRadius = 12;
  autolayout(banner, { dir: "HORIZONTAL", gap: 8, pad: [10, 12, 10, 12], cross: "CENTER" });
  content.appendChild(banner);
  fill(banner);
  banner.primaryAxisAlignItems = "SPACE_BETWEEN";
  banner.appendChild(await text("Brand: Kirirom", "labelMedium", "color/on-primary-container"));
  const clear = icon("close", "color/on-primary-container");
  if (clear) banner.appendChild(clear);

  await chipRow(content, ["All", "Coffee", "Gear", "Beans"], 1);
  await chipRow(content, ["Kirirom", "Angkor", "Tonle"], -1);

  const countRow = figma.createFrame();
  countRow.fills = [];
  autolayout(countRow, { dir: "HORIZONTAL", cross: "CENTER" });
  content.appendChild(countRow);
  fill(countRow);
  countRow.primaryAxisAlignItems = "SPACE_BETWEEN";
  countRow.appendChild(await text("42 products", "bodySmall", "color/on-surface-variant"));
  countRow.appendChild(await text("Sort: Newest", "labelMedium", "color/primary"));

  for (let row = 0; row < 2; row++) {
    const gridRow = figma.createFrame();
    gridRow.fills = [];
    autolayout(gridRow, { dir: "HORIZONTAL", gap: 12 });
    content.appendChild(gridRow);
    fill(gridRow);
    for (let i = 0; i < 2; i++) {
      const card = componentInstance("Availability=InStock, Promo=None, Wishlisted=No, Loading=No");
      if (card) {
        gridRow.appendChild(card);
        card.layoutGrow = 1;
      }
    }
  }

  await asyncNavBar(f, "Customer", 1, 4);
  return f;
}

function screenSearchField() {
  const s = figma.createFrame();
  s.fills = [solid("color/surface-container")];
  s.cornerRadius = 12;
  autolayout(s, { dir: "HORIZONTAL", gap: 8, pad: [12, 12, 12, 12], cross: "CENTER" });
  return s;
}

async function inputInto(frame, hint) {
  const glyph = icon("search", "color/on-surface-variant");
  if (glyph) frame.appendChild(glyph);
  frame.appendChild(await text(hint, "bodyMedium", "color/on-surface-variant"));
  return frame;
}

// -- notifications ---------------------------------------------------------

async function notificationCard(parent, iconName, title, body, time, unread) {
  const card = cardBase(SCREEN_W - 32, 96, "color/surface-container-lowest", 16);
  card.clipsContent = false;
  parent.appendChild(card);

  const plate = figma.createFrame();
  plate.fills = [solid("color/surface-container")];
  plate.cornerRadius = 20;
  plate.primaryAxisSizingMode = "FIXED";
  plate.counterAxisSizingMode = "FIXED";
  safeResize(plate, 40, 40);
  card.appendChild(plate);
  plate.x = 12;
  plate.y = 12;
  const glyph = icon(iconName, "color/on-surface-variant");
  if (glyph) {
    plate.appendChild(glyph);
    glyph.x = 8;
    glyph.y = 8;
  }

  const col = figma.createFrame();
  col.fills = [];
  autolayout(col, { dir: "VERTICAL", gap: 2 });
  card.appendChild(col);
  col.x = 64;
  col.y = 12;
  col.counterAxisSizingMode = "FIXED";
  safeResize(col, 270, 72);
  col.appendChild(await text(title, "labelMedium", "color/on-surface"));
  col.appendChild(await text(body, "bodySmall", "color/on-surface-variant"));
  col.appendChild(await text(time, "labelSmall", "color/on-surface-variant"));

  if (unread) {
    const dot = figma.createEllipse();
    dot.resize(8, 8);
    dot.fills = [solid("color/primary")];
    card.appendChild(dot);
    dot.x = 344;
    dot.y = 16;
  }
  return card;
}

async function buildNotifications(section) {
  const f = screenFrame("Screen/notifications/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Notifications", { back: true });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 8, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H);

  const markRow = figma.createFrame();
  markRow.fills = [];
  autolayout(markRow, { dir: "HORIZONTAL" });
  content.appendChild(markRow);
  fill(markRow);
  markRow.primaryAxisAlignItems = "MAX";
  markRow.appendChild(await text("Mark all read", "labelLarge", "color/primary"));

  content.appendChild(await text("TODAY", "labelSmall", "color/on-surface-variant"));
  await notificationCard(content, "check_circle", "Order shipped", "Order #4F2A9C81 is on its way.", "2h ago", true);
  await notificationCard(content, "info", "Promotion live", "Coffee gear is 30% off until Sunday.", "5h ago", false);

  content.appendChild(await text("YESTERDAY", "labelSmall", "color/on-surface-variant"));
  await notificationCard(content, "error", "Payment failed", "Your KHQR payment was not completed.", "1d ago", false);

  content.appendChild(await text("EARLIER", "labelSmall", "color/on-surface-variant"));
  await notificationCard(content, "shopping_cart", "Order delivered", "Order #8A11BE20 was delivered.", "4d ago", false);

  return f;
}

async function batchCustomerA(log) {
  const page = await screenContext();
  const section = sectionFor(page, "S · Customer");

  const screens = [
    ["Screen/productDetail/loaded", buildProductDetail],
    ["Screen/cart/loaded", buildCart],
    ["Screen/discovery/loaded", buildDiscovery],
    ["Screen/notifications/loaded", buildNotifications],
  ];
  for (const [name] of screens) {
    const old = section.findOne((n) => n.name === name);
    if (old) old.remove();
  }
  for (const [name, fn] of screens) {
    await fn(section);
    log(`${name} built`);
  }
  return `S2 — 4 screens`;
}
