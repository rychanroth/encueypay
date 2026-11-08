// ===== batch: s4-profile-admin =====
// Profile (customer pixel) and the four admin pixel screens.

function menuRow(label) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", cross: "CENTER" });
  row.paddingTop = 12;
  row.paddingBottom = 12;
  return row;
}

async function menuRowFilled(label, hint) {
  const row = menuRow(label);
  const t = await text(label, "bodyMedium", "color/on-surface");
  t.layoutGrow = 1;
  row.appendChild(t);
  if (hint) row.appendChild(await text(hint, "bodySmall", "color/on-surface-variant"));
  const chev = icon("chevron_right", "color/on-surface-variant");
  if (chev) row.appendChild(chev);
  return row;
}

function kpiCard(value, label, width) {
  const c = cardBase(width, 76, "color/surface-container", 12);
  c.strokes = [];
  c.clipsContent = false;
  autolayout(c, { dir: "VERTICAL", gap: 2, pad: [12, 12, 12, 12] });
  c.counterAxisSizingMode = "FIXED";
  safeResize(c, width, 76);
  return c;
}

async function kpiFilled(card, value, label) {
  card.appendChild(await text(value, "titleLarge", "color/on-surface"));
  card.appendChild(await text(label, "bodySmall", "color/on-surface-variant"));
  return card;
}

// -- profile ---------------------------------------------------------------

async function buildProfile(section) {
  const f = screenFrame("Screen/profile/customer-loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Profile", {});

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  // identity
  const idCard = cardBase(SCREEN_W - 32, 88, "color/surface-container-lowest", 16);
  idCard.clipsContent = false;
  content.appendChild(idCard);

  const avatar = imageTile(64, 64, "Sokha Chan", 32);
  idCard.appendChild(avatar);
  avatar.x = 12;
  avatar.y = 12;
  await initialsInto(avatar, "Sokha Chan");

  const cam = figma.createFrame();
  cam.fills = [solid("color/primary")];
  cam.cornerRadius = 10;
  cam.primaryAxisSizingMode = "FIXED";
  cam.counterAxisSizingMode = "FIXED";
  safeResize(cam, 20, 20);
  idCard.appendChild(cam);
  cam.x = 58;
  cam.y = 58;

  const who = await text("Sokha Chan", "titleMedium", "color/on-surface");
  idCard.appendChild(who);
  who.x = 92;
  who.y = 22;
  const mail = await text("sokha@example.com", "bodySmall", "color/on-surface-variant");
  idCard.appendChild(mail);
  mail.x = 92;
  mail.y = 46;

  // overview
  const overview = figma.createFrame();
  overview.fills = [];
  autolayout(overview, { dir: "HORIZONTAL", gap: 12 });
  content.appendChild(overview);
  fill(overview);
  for (const [value, label] of [
    ["12", "Orders"],
    ["5", "Wishlist"],
    ["2", "Addresses"],
  ]) {
    const c = kpiCard((SCREEN_W - 32 - 24) / 3, 76, (SCREEN_W - 32 - 24) / 3);
    overview.appendChild(c);
    c.layoutGrow = 1;
    await kpiFilled(c, value, label);
  }

  const list = cardBase(SCREEN_W - 32, 176, "color/surface-container-lowest", 16);
  list.clipsContent = false;
  list.strokes = [];
  list.fills = [solid("color/surface-container")];
  autolayout(list, { dir: "VERTICAL", gap: 0, pad: [4, 12, 4, 12] });
  list.counterAxisSizingMode = "FIXED";
  content.appendChild(list);
  safeResize(list, SCREEN_W - 32, 176);

  for (const label of ["Edit profile", "Addresses", "Wishlist", "Settings"]) {
    const row = await menuRowFilled(label);
    list.appendChild(row);
    fill(row);
    if (label !== "Settings") {
      const sep = figma.createRectangle();
      sep.resize(SCREEN_W - 56, 1);
      sep.fills = [solid("color/outline-variant")];
      list.appendChild(sep);
    }
  }

  await buttonK(content, "Outline", "Default", "Sign out", 358);

  await asyncNavBar(f, "Customer", 4, 4);
  return f;
}

// -- adminDashboard --------------------------------------------------------

async function buildAdminDashboard(section) {
  const f = screenFrame("Screen/adminDashboard/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Dashboard", { action: true });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  // KPI hero
  const hero = cardBase(SCREEN_W - 32, 132, "color/primary", 16);
  hero.clipsContent = false;
  autolayout(hero, { dir: "VERTICAL", gap: 4, pad: [16, 16, 16, 16] });
  hero.counterAxisSizingMode = "FIXED";
  content.appendChild(hero);
  safeResize(hero, SCREEN_W - 32, 132);

  hero.appendChild(await text("TOTAL SALES", "labelSmall", "color/on-primary"));
  hero.appendChild(await text("$12,480.00", "displayLarge", "color/on-primary"));

  const heroRow = figma.createFrame();
  heroRow.fills = [];
  autolayout(heroRow, { dir: "HORIZONTAL", gap: 16 });
  hero.appendChild(heroRow);
  fill(heroRow);
  heroRow.appendChild(await text("128 orders", "bodySmall", "color/on-primary"));
  heroRow.appendChild(await text("84 customers", "bodySmall", "color/on-primary"));
  heroRow.appendChild(await text("+18% 7d", "labelMedium", "color/on-primary"));

  // stock alert
  const alert = cardBase(SCREEN_W - 32, 64, "color/error-container", 12);
  alert.strokes = [];
  alert.clipsContent = false;
  autolayout(alert, { dir: "HORIZONTAL", gap: 8, pad: [12, 12, 12, 12], cross: "CENTER" });
  alert.counterAxisSizingMode = "FIXED";
  content.appendChild(alert);
  safeResize(alert, SCREEN_W - 32, 64);
  const warnIcon = icon("warning", "color/on-error-container");
  if (warnIcon) alert.appendChild(warnIcon);
  alert.appendChild(await text("3 products are low on stock", "bodyMedium", "color/on-error-container"));

  // 14-day chart
  const chartCard = cardBase(SCREEN_W - 32, 168, "color/surface-container-lowest", 16);
  chartCard.clipsContent = false;
  autolayout(chartCard, { dir: "VERTICAL", gap: 8, pad: [12, 12, 12, 12] });
  chartCard.counterAxisSizingMode = "FIXED";
  content.appendChild(chartCard);
  safeResize(chartCard, SCREEN_W - 32, 168);
  chartCard.appendChild(await text("14-day sales", "labelMedium", "color/on-surface-variant"));

  const chart = figma.createFrame();
  chart.fills = [];
  autolayout(chart, { dir: "HORIZONTAL", gap: 6, cross: "MAX" });
  chartCard.appendChild(chart);
  fill(chart);
  chart.primaryAxisAlignItems = "SPACE_BETWEEN";
  const heights = [34, 52, 40, 66, 48, 72, 58, 80, 62, 90, 74, 96, 84, 104];
  for (const h of heights) {
    const bar = figma.createRectangle();
    bar.resize(14, h);
    bar.cornerRadius = 4;
    bar.fills = [solid("color/primary")];
    chart.appendChild(bar);
  }

  // top sellers
  await subHeading(content, "TOP SELLERS");
  for (const [name, sales] of [
    ["Coffee grinder", "42 sold"],
    ["Kirirom beans", "38 sold"],
    ["Paper filters", "21 sold"],
  ]) {
    const row = figma.createFrame();
    row.fills = [];
    autolayout(row, { dir: "HORIZONTAL", cross: "CENTER" });
    content.appendChild(row);
    fill(row);
    const t = await text(name, "bodyMedium", "color/on-surface");
    t.layoutGrow = 1;
    row.appendChild(t);
    row.appendChild(await text(sales, "labelMedium", "color/on-surface-variant"));
  }

  // quick links
  await subHeading(content, "QUICK LINKS");
  for (const rowLabels of [
    ["Reports", "Categories"],
    ["Promotions", "Account"],
    ["Audit logs", "Platform settings"],
  ]) {
    const row = figma.createFrame();
    row.fills = [];
    autolayout(row, { dir: "HORIZONTAL", gap: 12 });
    content.appendChild(row);
    fill(row);
    for (const label of rowLabels) {
      const link = cardBase((SCREEN_W - 32 - 12) / 2, 56, "color/surface-container", 12);
      link.strokes = [];
      link.clipsContent = false;
      autolayout(link, { dir: "HORIZONTAL", pad: [12, 12, 12, 12], cross: "CENTER" });
      link.counterAxisSizingMode = "FIXED";
      row.appendChild(link);
      link.layoutGrow = 1;
      safeResize(link, (SCREEN_W - 32 - 12) / 2, 56);
      link.appendChild(await text(label, "labelMedium", "color/on-surface"));
    }
  }

  await asyncNavBar(f, "Admin", 0);
  return f;
}

// -- adminProducts ---------------------------------------------------------

async function adminProductRow(parent, name, meta, stock, badge) {
  const row = cardBase(SCREEN_W - 32, 64, "color/surface-container-lowest", 12);
  row.clipsContent = false;
  parent.appendChild(row);

  const t = await text(name, "titleSmall", "color/on-surface");
  row.appendChild(t);
  t.x = 12;
  t.y = 10;

  const m = await text(meta, "bodySmall", "color/on-surface-variant");
  row.appendChild(m);
  m.x = 12;
  m.y = 30;

  if (badge) {
    const tag = await pill(badge, "color/error-container", solid("color/on-error-container"), null);
    row.appendChild(tag);
    tag.x = 12;
    tag.y = 42;
  }

  const step = figma.createFrame();
  step.fills = [];
  step.strokes = [solid("color/outline-variant")];
  step.strokeWeight = 1;
  step.cornerRadius = 999;
  step.primaryAxisSizingMode = "FIXED";
  step.counterAxisSizingMode = "FIXED";
  safeResize(step, 88, 32);
  row.appendChild(step);
  step.x = 224;
  step.y = 16;
  const minus = await text("−", "labelLarge", "color/on-surface");
  step.appendChild(minus);
  minus.x = 12;
  minus.y = 6;
  const q = await text(String(stock), "labelLarge", "color/on-surface");
  step.appendChild(q);
  q.x = 42;
  q.y = 6;
  const plus = await text("+", "labelLarge", "color/on-surface");
  step.appendChild(plus);
  plus.x = 68;
  plus.y = 6;

  const more = icon("more_vert", "color/on-surface-variant");
  if (more) {
    row.appendChild(more);
    more.x = 330;
    more.y = 20;
  }
  return row;
}

async function buildAdminProducts(section) {
  const f = screenFrame("Screen/adminProducts/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Products", { action: true });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 10, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  const search = screenSearchField();
  content.appendChild(search);
  fill(search);
  await inputInto(search, "Search products");

  await chipRow(content, ["All", "Low stock", "Out of stock"], 0);

  await adminProductRow(content, "Coffee grinder", "Kirirom · Gear", 12, null);
  await adminProductRow(content, "Kirirom beans", "Kirirom · Coffee", 3, "Low stock");
  await adminProductRow(content, "Paper filters", "Angkor · Gear", 0, "Out of stock");
  await adminProductRow(content, "Ceramic dripper", "Tonle · Gear", 8, null);

  // FAB
  const fab = figma.createFrame();
  fab.fills = [solid("color/primary")];
  fab.cornerRadius = 28;
  fab.primaryAxisSizingMode = "FIXED";
  fab.counterAxisSizingMode = "FIXED";
  safeResize(fab, 56, 56);
  f.appendChild(fab);
  fab.x = SCREEN_W - 16 - 56;
  fab.y = SCREEN_H - NAVBAR_H - 16 - 56;
  const plusH = figma.createRectangle();
  plusH.resize(20, 2);
  plusH.cornerRadius = 1;
  plusH.fills = [literal("#FFFFFF")];
  fab.appendChild(plusH);
  plusH.x = 18;
  plusH.y = 27;
  const plusV = figma.createRectangle();
  plusV.resize(2, 20);
  plusV.cornerRadius = 1;
  plusV.fills = [literal("#FFFFFF")];
  fab.appendChild(plusV);
  plusV.x = 27;
  plusV.y = 18;

  await asyncNavBar(f, "Admin", 1);
  return f;
}

// -- adminOrders -----------------------------------------------------------

async function adminOrderRow(parent, customer, total, when, items, payment, lifecycle) {
  const row = cardBase(SCREEN_W - 32, 88, "color/surface-container-lowest", 12);
  row.clipsContent = false;
  parent.appendChild(row);

  const name = await text(customer, "titleSmall", "color/on-surface");
  row.appendChild(name);
  name.x = 12;
  name.y = 10;

  const meta = await text(`${when} · ${items} items`, "bodySmall", "color/on-surface-variant");
  row.appendChild(meta);
  meta.x = 12;
  meta.y = 30;

  const pay = await text(payment, "labelSmall", "color/on-surface-variant");
  row.appendChild(pay);
  pay.x = 12;
  pay.y = 52;

  const amount = await text(total, "priceHighlight", "color/on-surface");
  row.appendChild(amount);
  amount.x = 240;
  amount.y = 10;

  const inst = componentInstance(`Status=${lifecycle}, Density=Dense`);
  if (inst) {
    row.appendChild(inst);
    inst.x = 240;
    inst.y = 52;
  }
  return row;
}

async function buildAdminOrders(section) {
  const f = screenFrame("Screen/adminOrders/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Orders", { action: true });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 10, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  await adminOrderRow(content, "Sokha Chan", "$49.50", "12 Jun", 3, "KHQR · verified", "Packed");
  await adminOrderRow(content, "Dara Kim", "$18.00", "12 Jun", 1, "COD · pending", "Confirmed");
  await adminOrderRow(content, "Vibol Ly", "$24.00", "11 Jun", 2, "KHQR · pending", "Pending");
  await adminOrderRow(content, "Chenda Sok", "$72.00", "11 Jun", 4, "COD · paid", "Delivered");

  await asyncNavBar(f, "Admin", 2);
  return f;
}

// -- adminReports ----------------------------------------------------------

async function buildAdminReports(section) {
  const f = screenFrame("Screen/adminReports/loaded");
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;

  await appBar(f, "Reports", { action: true });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H - NAVBAR_H);

  await chipRow(content, ["7D", "15D", "30D", "MTD", "Custom"], 2);

  const rangeRow = figma.createFrame();
  rangeRow.fills = [];
  autolayout(rangeRow, { dir: "HORIZONTAL" });
  content.appendChild(rangeRow);
  fill(rangeRow);
  rangeRow.primaryAxisAlignItems = "SPACE_BETWEEN";
  rangeRow.appendChild(await text("1 Jun – 30 Jun 2026", "bodySmall", "color/on-surface-variant"));
  rangeRow.appendChild(await text("Export", "labelMedium", "color/primary"));

  // KPI grid
  for (const pair of [
    [["$12,480", "Revenue"], ["128", "Orders"]],
    [["$97.50", "Avg order"], ["84", "Customers"]],
  ]) {
    const row = figma.createFrame();
    row.fills = [];
    autolayout(row, { dir: "HORIZONTAL", gap: 12 });
    content.appendChild(row);
    fill(row);
    for (const [value, label] of pair) {
      const width = (SCREEN_W - 32 - 12) / 2;
      const c = kpiCard(width, 76, width);
      row.appendChild(c);
      c.layoutGrow = 1;
      await kpiFilled(c, value, label);
    }
  }

  // payment split
  await subHeading(content, "PAYMENT SPLIT");
  const split = figma.createFrame();
  split.fills = [];
  autolayout(split, { dir: "HORIZONTAL", gap: 0 });
  content.appendChild(split);
  fill(split);
  split.clipsContent = true;
  split.cornerRadius = 6;
  split.counterAxisSizingMode = "FIXED";
  safeResize(split, SCREEN_W - 32, 12);
  const khqrBar = figma.createRectangle();
  khqrBar.resize(250, 12);
  khqrBar.fills = [solid("color/primary")];
  split.appendChild(khqrBar);
  const codBar = figma.createRectangle();
  codBar.resize(76, 12);
  codBar.fills = [solid("color/tertiary")];
  split.appendChild(codBar);

  const legend = figma.createFrame();
  legend.fills = [];
  autolayout(legend, { dir: "HORIZONTAL", gap: 16 });
  content.appendChild(legend);
  legend.appendChild(await text("KHQR 76%", "labelSmall", "color/on-surface-variant"));
  legend.appendChild(await text("COD 24%", "labelSmall", "color/on-surface-variant"));

  // lists
  for (const [title, rows] of [
    ["BEST SELLERS", [["Coffee grinder", "42"], ["Kirirom beans", "38"], ["Paper filters", "21"]]],
    ["TOP CATEGORIES", [["Gear", "$6,240"], ["Coffee", "$4,880"], ["Beans", "$1,360"]]],
    ["BRAND REVENUE", [["Kirirom", "$5,120"], ["Angkor", "$3,940"], ["Tonle", "$2,100"]]],
    ["PURCHASE FREQUENCY", [["1 order", "62%"], ["2–3 orders", "28%"], ["4+ orders", "10%"]]],
  ]) {
    await subHeading(content, title);
    for (const [name, value] of rows) {
      const row = figma.createFrame();
      row.fills = [];
      autolayout(row, { dir: "HORIZONTAL" });
      content.appendChild(row);
      fill(row);
      row.primaryAxisAlignItems = "SPACE_BETWEEN";
      row.appendChild(await text(name, "bodySmall", "color/on-surface"));
      row.appendChild(await text(value, "labelSmall", "color/on-surface-variant"));
    }
  }

  await asyncNavBar(f, "Admin", 3);
  return f;
}

async function batchProfileAdmin(log) {
  const page = await screenContext();
  const customer = sectionFor(page, "S · Customer");
  const admin = sectionFor(page, "S · Admin");

  const old = [];
  for (const name of [
    "Screen/profile/customer-loaded",
    "Screen/adminDashboard/loaded",
    "Screen/adminProducts/loaded",
    "Screen/adminOrders/loaded",
    "Screen/adminReports/loaded",
  ]) {
    page.findOne((n) => n.name === name) && old.push(page.findOne((n) => n.name === name));
  }
  old.forEach((n) => n.remove());

  const built = [
    ["Screen/profile/customer-loaded", buildProfile, customer],
    ["Screen/adminDashboard/loaded", buildAdminDashboard, admin],
    ["Screen/adminProducts/loaded", buildAdminProducts, admin],
    ["Screen/adminOrders/loaded", buildAdminOrders, admin],
    ["Screen/adminReports/loaded", buildAdminReports, admin],
  ];
  for (const [name, fn, section] of built) {
    await fn(section);
    log(`${name} built`);
  }
  return "S4 — 5 screens";
}
