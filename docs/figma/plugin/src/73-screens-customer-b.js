// ===== batch: s3-customer-b =====
// Customer pixel screens: checkout, orderPlaced, orders, orderDetail.

async function subHeading(parent, label) {
  const t = await text(label, "labelMedium", "color/on-surface-variant");
  parent.appendChild(t);
  return t;
}

function radioRow(label, sub, selected) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 10, cross: "CENTER" });
  row.paddingTop = 8;
  row.paddingBottom = 8;

  const dot = figma.createEllipse();
  dot.resize(18, 18);
  dot.fills = selected ? [solid("color/primary")] : [];
  dot.strokes = [solid(selected ? "color/primary" : "color/on-surface-variant")];
  dot.strokeWeight = 2;
  row.appendChild(dot);

  const col = figma.createFrame();
  col.fills = [];
  autolayout(col, { dir: "VERTICAL", gap: 2 });
  row.appendChild(col);
  col.layoutGrow = 1;
  return { row, col, label, sub };
}

async function fillRadio(radio, primary, secondary) {
  radio.col.appendChild(await text(primary, "bodyMedium", "color/on-surface"));
  if (secondary) {
    radio.col.appendChild(await text(secondary, "bodySmall", "color/on-surface-variant"));
  }
  return radio.row;
}

async function lineItem(parent, name, qty, price) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 8, cross: "CENTER" });
  parent.appendChild(row);
  fill(row);
  const label = await text(name + " × " + qty, "bodyMedium", "color/on-surface");
  label.layoutGrow = 1;
  row.appendChild(label);
  row.appendChild(await text(price, "labelLarge", "color/on-surface"));
  return row;
}

// -- checkout --------------------------------------------------------------

async function buildCheckout(section) {
  const f = screenFrame("Screen/checkout/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Checkout", { back: true });

  const barH = 88;
  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 10, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - barH);

  await subHeading(content, "ORDER ITEMS");
  await lineItem(content, "Coffee grinder", 1, "$18.00");
  await lineItem(content, "Kirirom beans", 2, "$24.00");
  await lineItem(content, "Paper filters", 1, "$6.00");

  await subHeading(content, "DELIVERY ADDRESS");
  content.appendChild(await fillRadio(radioRow("Home", "", true), "Home", "St 271, Phnom Penh · Sokha"));
  content.appendChild(
    await fillRadio(radioRow("Office", "", false), "Office", "Toul Kork, Phnom Penh · Sokha")
  );
  content.appendChild(await text("+ Add address", "labelLarge", "color/primary"));

  await subHeading(content, "PAYMENT");
  content.appendChild(await fillRadio(radioRow("COD", "", true), "Cash on delivery", "Pay the driver"));
  content.appendChild(await fillRadio(radioRow("KHQR", "", false), "KHQR / Bakong", "Scan to pay"));

  const feeRow = figma.createFrame();
  feeRow.fills = [];
  autolayout(feeRow, { dir: "HORIZONTAL" });
  content.appendChild(feeRow);
  fill(feeRow);
  feeRow.primaryAxisAlignItems = "SPACE_BETWEEN";
  feeRow.appendChild(await text("Delivery fee", "bodyMedium", "color/on-surface-variant"));
  feeRow.appendChild(await text("$1.50", "labelLarge", "color/on-surface"));

  await subHeading(content, "COUPON");
  const coupon = await inputField(content, "Text", "Enabled", "Coupon code");

  await subHeading(content, "ORDER NOTE");
  await inputField(content, "Text", "Enabled", "Note for the seller");

  await subHeading(content, "SUMMARY");
  const summary = cardBase(SCREEN_W - 32, 96, "color/surface-container", 12);
  summary.strokes = [];
  summary.clipsContent = false;
  autolayout(summary, { dir: "VERTICAL", gap: 4, pad: [12, 12, 12, 12] });
  summary.counterAxisSizingMode = "FIXED";
  content.appendChild(summary);
  safeResize(summary, SCREEN_W - 32, 96);
  for (const [k, v] of [
    ["Subtotal", "$48.00"],
    ["Delivery", "$1.50"],
  ]) {
    const r = figma.createFrame();
    r.fills = [];
    autolayout(r, { dir: "HORIZONTAL" });
    summary.appendChild(r);
    fill(r);
    r.primaryAxisAlignItems = "SPACE_BETWEEN";
    r.appendChild(await text(k, "bodySmall", "color/on-surface-variant"));
    r.appendChild(await text(v, "bodySmall", "color/on-surface"));
  }
  const totalRow = figma.createFrame();
  totalRow.fills = [];
  autolayout(totalRow, { dir: "HORIZONTAL" });
  summary.appendChild(totalRow);
  fill(totalRow);
  totalRow.primaryAxisAlignItems = "SPACE_BETWEEN";
  totalRow.appendChild(await text("Total", "titleSmall", "color/on-surface"));
  totalRow.appendChild(await text("$49.50", "priceHighlight", "color/on-surface"));

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

  const totals = figma.createFrame();
  totals.fills = [];
  autolayout(totals, { dir: "VERTICAL", gap: 2 });
  bar.appendChild(totals);
  totals.appendChild(await text("Total", "labelSmall", "color/on-surface-variant"));
  totals.appendChild(await text("$49.50", "priceHighlight", "color/on-surface"));
  totals.appendChild(await text("≈ 202,950 KHR", "bodySmall", "color/on-surface-variant"));

  const cta = await buttonK(bar, "Primary", "Default", "Place order", 200);
  cta.layoutGrow = 1;

  return f;
}

// -- orderPlaced -----------------------------------------------------------

async function buildOrderPlaced(section) {
  const f = screenFrame("Screen/orderPlaced/qr-pending");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 16, pad: [24, 24, 24, 24], cross: "CENTER" });
  f.appendChild(content);
  content.x = 0;
  content.y = 0;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H);

  content.appendChild(await text("Complete payment", "headlineSmall", "color/on-surface"));
  content.appendChild(
    await text("Scan the QR with any KHQR-supported bank app.", "bodyMedium", "color/on-surface-variant")
  );

  const khqr = componentInstance("State=Ready");
  if (khqr) content.appendChild(khqr);

  const summary = cardBase(SCREEN_W - 48, 76, "color/surface-container", 12);
  summary.strokes = [];
  summary.clipsContent = false;
  autolayout(summary, { dir: "VERTICAL", gap: 4, pad: [12, 12, 12, 12] });
  summary.counterAxisSizingMode = "FIXED";
  content.appendChild(summary);
  safeResize(summary, SCREEN_W - 48, 76);
  summary.appendChild(await text("Order #4F2A9C81", "labelLarge", "color/on-surface"));
  summary.appendChild(await text("3 items · $49.50", "bodySmall", "color/on-surface-variant"));
  summary.appendChild(await text("≈ 202,950 KHR", "bodySmall", "color/on-surface-variant"));

  await buttonK(content, "Primary", "Default", "View order details", 342);
  await buttonK(content, "Outline", "Default", "Back to Home", 342);

  return f;
}

// -- orders ----------------------------------------------------------------

async function orderCard(parent, id, badge, dateLine, total, khrtotal) {
  const card = cardBase(SCREEN_W - 32, 132, "color/surface-container-lowest", 16);
  card.clipsContent = false;
  parent.appendChild(card);

  const head = figma.createFrame();
  head.fills = [];
  autolayout(head, { dir: "HORIZONTAL", cross: "CENTER" });
  card.appendChild(head);
  head.x = 12;
  head.y = 12;
  head.counterAxisSizingMode = "FIXED";
  safeResize(head, SCREEN_W - 32 - 24, 24);
  head.primaryAxisAlignItems = "SPACE_BETWEEN";
  head.appendChild(await text("Order #" + id, "labelLarge", "color/on-surface"));

  const chipInst = componentInstance(`Status=${badge}, Density=Default`);
  if (chipInst) head.appendChild(chipInst);

  const meta = await text(dateLine, "bodySmall", "color/on-surface-variant");
  card.appendChild(meta);
  meta.x = 12;
  meta.y = 40;

  const price = await text(total, "priceHighlight", "color/on-surface");
  card.appendChild(price);
  price.x = 12;
  price.y = 62;

  const khr = await text(khrtotal, "bodySmall", "color/on-surface-variant");
  card.appendChild(khr);
  khr.x = 12;
  khr.y = 86;

  const track = await text("Track order", "labelLarge", "color/primary");
  card.appendChild(track);
  track.x = 220;
  track.y = 68;

  return card;
}

async function buildOrders(section) {
  const f = screenFrame("Screen/orders/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Orders", {});

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 10, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  await chipRow(content, ["All", "Active", "Completed", "Cancelled"], 1);

  const rangeRow = figma.createFrame();
  rangeRow.fills = [];
  autolayout(rangeRow, { dir: "HORIZONTAL", gap: 8, cross: "CENTER" });
  content.appendChild(rangeRow);
  fill(rangeRow);
  rangeRow.appendChild(await text("Last 30 days", "labelMedium", "color/on-surface-variant"));
  const x = icon("close", "color/on-surface-variant");
  if (x) rangeRow.appendChild(x);

  await orderCard(content, "4F2A9C81", "Packed", "12 Jun · 3 items", "$49.50", "≈ 202,950 KHR");
  await orderCard(content, "8A11BE20", "Delivered", "2 Jun · 1 item", "$18.00", "≈ 73,800 KHR");
  await orderCard(content, "C71D0F45", "Cancelled", "28 May · 2 items", "$24.00", "≈ 98,400 KHR");

  await asyncNavBar(f, "Customer", 3, 4);
  return f;
}

// -- orderDetail -----------------------------------------------------------

async function buildOrderDetail(section) {
  const f = screenFrame("Screen/orderDetail/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Order #4F2A9C81", { back: true, action: true });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H);

  const head = figma.createFrame();
  head.fills = [];
  autolayout(head, { dir: "HORIZONTAL", cross: "CENTER" });
  content.appendChild(head);
  fill(head);
  head.primaryAxisAlignItems = "SPACE_BETWEEN";
  head.appendChild(await text("Placed 12 Jun 2026", "bodySmall", "color/on-surface-variant"));

  const tracking = componentInstance("State=InFlight, Detail=Simplified");
  if (tracking) content.appendChild(tracking);

  await subHeading(content, "ITEMS");
  await lineItem(content, "Coffee grinder", 1, "$18.00");
  await lineItem(content, "Kirirom beans", 2, "$24.00");

  await subHeading(content, "PAYMENT");
  content.appendChild(await fillRadio(radioRow("KHQR", "", true), "KHQR / Bakong", "Paid · verified"));
  content.appendChild(
    await fillRadio(radioRow("Address", "", false), "Home", "St 271, Phnom Penh · Sokha")
  );

  await subHeading(content, "TOTALS");
  for (const [k, v] of [
    ["Subtotal", "$48.00"],
    ["Delivery", "$1.50"],
    ["Total", "$49.50"],
  ]) {
    const r = figma.createFrame();
    r.fills = [];
    autolayout(r, { dir: "HORIZONTAL" });
    content.appendChild(r);
    fill(r);
    r.primaryAxisAlignItems = "SPACE_BETWEEN";
    r.appendChild(await text(k, k === "Total" ? "titleSmall" : "bodySmall", "color/on-surface"));
    r.appendChild(await text(v, k === "Total" ? "priceHighlight" : "bodySmall", "color/on-surface"));
  }

  await buttonK(content, "Outline", "Default", "Cancel order", 358);

  return f;
}

async function batchCustomerB(log) {
  const page = await screenContext();
  const section = sectionFor(page, "S · Customer");

  const screens = [
    ["Screen/checkout/loaded", buildCheckout],
    ["Screen/orderPlaced/qr-pending", buildOrderPlaced],
    ["Screen/orders/loaded", buildOrders],
    ["Screen/orderDetail/loaded", buildOrderDetail],
  ];
  for (const [name] of screens) {
    const old = section.findOne((n) => n.name === name);
    if (old) old.remove();
  }
  for (const [name, fn] of screens) {
    await fn(section);
    log(`${name} built`);
  }
  return "S3 — 4 screens";
}
