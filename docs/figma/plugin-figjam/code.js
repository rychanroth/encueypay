/**
 * GENERATED FILE — do not edit directly.
 * Sources: docs/figma/plugin/src/*.js (5 files)
 * Rebuild: node docs/figma/plugin-figjam/build.js
 */

// ===== 00-kit.js =====
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

/** Nodes added to the page since a snapshot — the reliable way to collect a drawing. */
function fjSnapshot() {
  return new Set(figma.currentPage.children.map((n) => n.id));
}

function fjAdded(before) {
  return figma.currentPage.children.filter((n) => !before.has(n.id));
}

/** Diagram backdrop + title. Records the page so fjEnd() can group what was added. */
async function fjPanel(x, y, width, height, title) {
  FJ_BEFORE = fjSnapshot();
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
  const added = fjAdded(FJ_BEFORE);
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

// ===== 10-flows-a.js =====
// ===== batch: flows-a =====
// Navigation map, order lifecycle, payment lifecycle. Content mirrors
// flows.json (source commit 81dc7a7).

const NAV_CUSTOMER = [
  ["home\n/home\ntab 1", ["productDetail\n/home/product/:id", "notifications\n/home/notifications"]],
  ["discovery\n/discovery\ntab 2", []],
  ["cart\n/cart\ntab 3", ["checkout\n/cart/checkout", "checkoutAddressEdit\n/checkout/address/edit", "orderPlaced\n/cart/checkout/placed/:id"]],
  ["orders\n/orders\ntab 4", ["orderDetail\n/orders/:id", "reviewCompose\n/orders/review"]],
  ["profile\n/profile\ntab 5", ["profileEdit\n/profile/edit", "addresses\n/profile/addresses", "addressEdit\n/addresses/edit", "wishlist\n/profile/wishlist", "settings\n/profile/settings"]],
];

const NAV_ADMIN = [
  ["adminDashboard\n/admin/dashboard\ntab 1", ["adminAudit", "adminSettings", "adminCategories", "adminPromotions", "adminArchivedCoupons", "profile (admin)", "adminProfileEdit"]],
  ["adminProducts\n/admin/products\ntab 2", ["adminProductForm", "adminBrands"]],
  ["adminOrders\n/admin/orders\ntab 3", ["adminOrderDetail"]],
  ["adminReports\n/admin/reports\ntab 4", []],
];

const FJ_SHELL_PAD = 20;
const FJ_SHELL_HEADER = 44;

/** One shell: its own white card, a header rule with the shell name, and a group. */
async function fjNavShell(x, y, caption, tabs, colW, rowGap) {
  const before = fjSnapshot();

  const bg = figma.createRectangle();
  bg.x = x - FJ_SHELL_PAD;
  bg.y = y - FJ_SHELL_PAD;
  bg.resize(400, 200);
  bg.fills = [fjPaint("#FFFFFF")];
  bg.strokes = [fjPaint(FJ.line)];
  bg.cornerRadius = 14;
  bg.name = caption;

  await fjText(x, y + 12, caption, 14, FJ.primary, true);

  const tabY = y + FJ_SHELL_HEADER;
  const boxes = [];
  for (let i = 0; i < tabs.length; i++) {
    const label = tabs[i][0];
    const children = tabs[i][1];
    const tab = await fjShape(x + i * (colW + 20), tabY, colW, 74, label, {
      fill: FJ.primarySoft,
      stroke: FJ.primary,
    });
    boxes.push(tab);

    let cy = tabY + 100;
    for (const child of children) {
      const c = await fjShape(x + i * (colW + 20), cy, colW, 58, child, { size: 12 });
      fjConnect(tab, c);
      cy += 58 + rowGap;
    }
  }

  const content = fjAdded(before).filter((n) => n !== bg);
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
  bg.x = minX - FJ_SHELL_PAD;
  bg.y = minY - FJ_SHELL_PAD;
  bg.resize(maxX - minX + FJ_SHELL_PAD * 2, maxY - minY + FJ_SHELL_PAD * 2);

  const rule = figma.createRectangle();
  rule.resize(bg.width - 24, 1);
  rule.x = bg.x + 12;
  rule.y = y + FJ_SHELL_HEADER - 8;
  rule.fills = [fjPaint(FJ.line)];
  rule.strokes = [];

  let group = null;
  try {
    group = figma.group([bg].concat(content, [rule]), figma.currentPage);
    group.name = caption;
  } catch (e) {
    warn(`could not group "${caption}": ${(e && e.message) || e}`);
  }
  return { tabs: boxes, h: Math.round((group || bg).height) };
}

async function buildNavigation(x, y, log) {
  await fjPanel(x, y, 1700, 1320, "Navigation map");

  const login = await fjShape(x + 24, y + 64, 220, 64, "login\n/login\noutside shell", {
    fill: FJ.warnSoft,
    stroke: FJ.warnInk,
  });
  const customer = await fjNavShell(x + 24, y + 176, "Customer shell — 5 tabs", NAV_CUSTOMER, 250, 12);
  const admin = await fjNavShell(
    x + 24,
    y + 176 + customer.h + 44,
    "Admin shell — 4 tabs",
    NAV_ADMIN,
    250,
    12
  );

  fjConnect(login, customer.tabs[0]);
  const nav = await fjEnd();
  log(`navigation built (${nav ? nav.w + "x" + nav.h : "ungrouped"}) · shells ${customer.h}px, ${admin.h}px`);
}

async function buildOrderLifecycle(x, y, log) {
  await fjPanel(x, y, 1700, 420, "Order lifecycle");

  const stages = [
    "pending",
    "confirmed",
    "processing",
    "packed",
    "shipped",
    "out_for_delivery",
    "delivered",
  ];
  const boxes = [];
  const boxW = 200;
  const gap = 40;
  for (let i = 0; i < stages.length; i++) {
    const b = await fjShape(x + 24 + i * (boxW + gap), y + 80, boxW, 56, stages[i], {
      fill: i === 0 ? FJ.warnSoft : "#FFFFFF",
    });
    boxes.push(b);
  }
  for (let i = 0; i < boxes.length - 1; i++) {
    fjConnect(boxes[i], boxes[i + 1], "admin_transition_order");
  }

  const cancelled = await fjShape(x + 24, y + 220, 200, 56, "cancelled", {
    fill: "#FFF1F2",
    stroke: "#BE123C",
  });
  fjConnect(boxes[0], cancelled, "cancel_order");
  fjConnect(boxes[1], cancelled, "cancel_order");
  fjConnect(boxes[6], cancelled, "terminal");

  await fjText(
    x + 300,
    y + 220,
    "Guard: one step forward.\nCancelling restores stock and needs a reason.\nA paid QR order cannot be cancelled by the customer.",
    12,
    FJ.muted
  );
  await fjText(x + 300, y + 320, "Excluded: returned (legacy — no refund flow exists).", 12, FJ.muted);
  const ol = await fjEnd();
  log(`order lifecycle built (${ol ? ol.w + "x" + ol.h : "ungrouped"})`);
}

async function buildPaymentLifecycle(x, y, log) {
  await fjPanel(x, y, 1700, 420, "Payment lifecycle");

  const pending = await fjShape(x + 24, y + 160, 200, 56, "pending", {
    fill: FJ.warnSoft,
    stroke: FJ.warnInk,
  });
  const awaiting = await fjShape(
    x + 360,
    y + 80,
    300,
    64,
    "awaiting_payment_verification\n(legacy bank transfer)",
    { size: 12 }
  );
  const verified = await fjShape(x + 360, y + 220, 300, 64, "transaction_verified", {
    fill: "#ECFDF5",
    stroke: "#047857",
  });

  fjConnect(pending, awaiting, "submit_payment_proof (bank_transfer only)");
  fjConnect(pending, verified, "confirm_qr_payment (PayWay webhook, HMAC verified)");
  fjConnect(pending, verified, "admin_mark_cod_paid (COD + delivered)");

  await fjText(
    x + 720,
    y + 120,
    "transaction_verified is the only paid state the UI may render.\nA client-side success must never set it.",
    12,
    FJ.muted
  );
  await fjText(
    x + 720,
    y + 200,
    "Excluded: refund_required, refunded (legacy — no refund flow).",
    12,
    FJ.muted
  );
  const pl = await fjEnd();
  log(`payment lifecycle built (${pl ? pl.w + "x" + pl.h : "ungrouped"})`);
}

const PANELS = ["Navigation map", "Order lifecycle", "Payment lifecycle"];

async function batchFlowsA(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  await fjFont();

  fjClear(PANELS);

  await buildNavigation(0, 0, log);
  await buildOrderLifecycle(1800, 0, log);
  await buildPaymentLifecycle(1800, 480, log);

  return "Flows A — 3 diagrams";
}

// ===== 20-flows-b.js =====
// ===== batch: flows-b =====
// Sequence diagrams: authentication/role routing, checkout placement, KHQR
// verification. Mirrors flows.json.

const SEQ_PARTICIPANT_W = 230;
const SEQ_PARTICIPANT_H = 64;
const SEQ_GAP = 24;
const SEQ_STEP = 56;

/**
 * Draw one sequence diagram.
 * messages: [{from, to, label}]; self-messages loop to the right.
 */
async function fjSequence(x, y, title, participants, messages, log) {
  const width = participants.length * (SEQ_PARTICIPANT_W + SEQ_GAP) + 48;
  const height = SEQ_PARTICIPANT_H + 120 + messages.length * SEQ_STEP;
  await fjPanel(x, y, width, height, title);

  const topY = y + 72;
  const lifelineTop = topY + SEQ_PARTICIPANT_H;
  const lifelineBottom = y + height - 40;
  const centerX = {};

  for (let i = 0; i < participants.length; i++) {
    const px = x + 24 + i * (SEQ_PARTICIPANT_W + SEQ_GAP);
    await fjShape(px, topY, SEQ_PARTICIPANT_W, SEQ_PARTICIPANT_H, participants[i], {
      fill: FJ.primarySoft,
      stroke: FJ.primary,
      size: 12,
    });
    centerX[participants[i]] = px + SEQ_PARTICIPANT_W / 2;

    const lifeline = figma.createRectangle();
    lifeline.resize(2, lifelineBottom - lifelineTop);
    lifeline.x = centerX[participants[i]] - 1;
    lifeline.y = lifelineTop;
    lifeline.fills = [fjPaint(FJ.line)];
    lifeline.strokes = [];
  }

  for (let i = 0; i < messages.length; i++) {
    const m = messages[i];
    const my = lifelineTop + 40 + i * SEQ_STEP;
    const ax = centerX[m.from];
    const bx = centerX[m.to];

    if (ax === bx) {
      // self call: out to the right and back
      fjArrowBetween(ax, my - 8, ax + 44, my - 8, "");
      fjArrowBetween(ax + 44, my - 8, ax, my + 6, m.label);
    } else {
      fjArrowBetween(ax, my, bx, my, m.label);
    }
  }

  return { width, title };
}

async function buildAuthSequence(x, y, log) {
  const seq = await fjSequence(
    x,
    y,
    "Authentication and role routing",
    ["User", "LoginScreen", "Supabase Auth", "users table", "authController", "Router"],
    [
      { from: "User", to: "LoginScreen", label: "email + password / Google" },
      { from: "LoginScreen", to: "Supabase Auth", label: "signInWithPassword | signUp | signInWithOAuth" },
      { from: "Supabase Auth", to: "LoginScreen", label: "session (or deep link login-callback)" },
      { from: "Supabase Auth", to: "authController", label: "onAuthStateChange stream" },
      { from: "authController", to: "users table", label: "select by auth id" },
      { from: "users table", to: "authController", label: "AppUser (fallback: metadata full_name)" },
      { from: "authController", to: "Router", label: "emit AppUser" },
      { from: "Router", to: "User", label: "defaultRouteForRole(role)" },
    ],
    log
  );
  const g = await fjEnd();
  log(`authentication built (${g ? g.w + "x" + g.h : "ungrouped"})`);
  return seq.width;
}

async function buildCheckoutSequence(x, y, log) {
  const seq = await fjSequence(
    x,
    y,
    "Checkout and atomic placement",
    ["CheckoutScreen", "CheckoutRepository", "validate_coupon", "preview_order_totals", "create_order_from_cart", "Tables", "Cart"],
    [
      { from: "CheckoutScreen", to: "CheckoutRepository", label: "apply code" },
      { from: "CheckoutRepository", to: "validate_coupon", label: "p_code" },
      { from: "validate_coupon", to: "CheckoutRepository", label: "valid, message, discount_minor" },
      { from: "CheckoutScreen", to: "CheckoutRepository", label: "address + method + codes + note" },
      { from: "CheckoutRepository", to: "preview_order_totals", label: "p_codes[]" },
      { from: "preview_order_totals", to: "CheckoutScreen", label: "server-priced totals" },
      { from: "CheckoutRepository", to: "create_order_from_cart", label: "place order" },
      { from: "create_order_from_cart", to: "Tables", label: "lock stock, re-price, insert order/items/payment/coupons" },
      { from: "create_order_from_cart", to: "Cart", label: "clear cart" },
      { from: "create_order_from_cart", to: "CheckoutScreen", label: "order id" },
      { from: "CheckoutScreen", to: "CheckoutScreen", label: "goNamed(orderPlaced, :id)" },
    ],
    log
  );

  await fjText(
    x + 24,
    y + SEQ_PARTICIPANT_H + 120 + 11 * SEQ_STEP,
    "Invariants: the client never computes the charge · placement is atomic · a failure keeps notes, coupons and address intact.",
    12,
    FJ.muted
  );
  const g = await fjEnd();
  log(`checkout placement built (${g ? g.w + "x" + g.h : "ungrouped"})`);
  return seq.width;
}

async function buildKhqrSequence(x, y, log) {
  const seq = await fjSequence(
    x,
    y,
    "KHQR payment verification",
    ["OrderPlacedScreen", "payway-create", "PayWay API", "payments", "payway-webhook", "Realtime"],
    [
      { from: "OrderPlacedScreen", to: "payway-create", label: "{ orderId }" },
      { from: "payway-create", to: "PayWay API", label: "create transaction" },
      { from: "PayWay API", to: "payway-create", label: "qrPayload" },
      { from: "payway-create", to: "payments", label: "register_qr_payment(order_id, payload)" },
      { from: "payway-create", to: "OrderPlacedScreen", label: "{ configured, qrPayload } or soft failure" },
      { from: "OrderPlacedScreen", to: "OrderPlacedScreen", label: "render KhqrCard(pending)" },
      { from: "PayWay API", to: "payway-webhook", label: "tran_id, status=0, amount, apv + HMAC-SHA512" },
      { from: "payway-webhook", to: "payway-webhook", label: "verify HMAC over ascending-key values" },
      { from: "payway-webhook", to: "payments", label: "confirm_qr_payment(order_id, reference)" },
      { from: "payments", to: "Realtime", label: "UPDATE status=transaction_verified" },
      { from: "Realtime", to: "OrderPlacedScreen", label: "verified state" },
    ],
    log
  );

  await fjText(
    x + 24,
    y + SEQ_PARTICIPANT_H + 120 + 11 * SEQ_STEP,
    "Invariants: the screen waits for server confirmation · a signature failure must not confirm · soft failures show a retry card, never a fake QR.",
    12,
    FJ.muted
  );
  const g = await fjEnd();
  log(`KHQR verification built (${g ? g.w + "x" + g.h : "ungrouped"})`);
  return seq.width;
}

const PANELS_B = [
  "Authentication and role routing",
  "Checkout and atomic placement",
  "KHQR payment verification",
];

async function batchFlowsB(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  await fjFont();

  fjClear(PANELS_B);

  await buildAuthSequence(0, 1400, log);
  await buildCheckoutSequence(0, 2160, log);
  await buildKhqrSequence(0, 2920, log);

  return "Flows B — 3 sequence diagrams";
}

// ===== 30-flows-c.js =====
// ===== batch: flows-c =====
// Data model (ERD), permission matrix, state ownership. Mirrors flows.json.

const ERD_ENTITIES = [
  ["users", "id uuid PK · = auth.users.id"],
  ["addresses", "id, user_id FK, is_default"],
  ["device_tokens", "id, user_id FK, token unique"],
  ["notifications", "id, recipient_id, order_id FK"],
  ["audit_logs", "id, actor, action, target_type, target_id"],
  ["categories", "id, parent_id FK categories"],
  ["brands", "id, name unique, status"],
  ["products", "id, category_id FK, brand_id FK, base_price_minor, stock"],
  ["product_variants", "id, product_id FK, price_minor NOT NULL"],
  ["product_images", "id, product_id FK, storage_path, sort_order"],
  ["carts", "id, user_id unique"],
  ["cart_items", "id, cart_id FK, product_variant_id FK, quantity"],
  ["wishlists", "id, user_id unique"],
  ["wishlist_items", "id, wishlist_id FK, product_id FK"],
  ["orders", "id, customer_id FK, shipping snapshot, totals, status"],
  ["order_items", "id, order_id FK, snapshot copy"],
  ["payments", "id, order_id FK one-per-order, method, status"],
  ["order_coupons", "id, order_id FK, coupon_id FK"],
  ["coupons", "id, code unique, discount, window"],
  ["sales", "id, scope, brand_id FK, category_id FK, discount"],
  ["banners", "id, sale_id FK, image_path, status"],
  ["reviews", "id, order_item_id unique FK, product_id, rating 1-5"],
];

const ERD_RELATIONS = [
  ["users", "addresses", "1:N"],
  ["users", "carts", "1:1"],
  ["users", "wishlists", "1:1"],
  ["users", "orders", "1:N"],
  ["users", "notifications", "1:N"],
  ["users", "device_tokens", "1:N"],
  ["carts", "cart_items", "1:N"],
  ["product_variants", "cart_items", "1:N"],
  ["products", "product_variants", "1:N"],
  ["products", "product_images", "1:N"],
  ["categories", "products", "1:N"],
  ["brands", "products", "1:N"],
  ["orders", "order_items", "1:N"],
  ["orders", "payments", "1:1"],
  ["orders", "order_coupons", "1:N"],
  ["coupons", "order_coupons", "1:N"],
  ["wishlists", "wishlist_items", "1:N"],
  ["products", "wishlist_items", "1:N"],
  ["products", "reviews", "1:N"],
  ["order_items", "reviews", "1:0..1"],
  ["sales", "banners", "1:N"],
  ["brands", "sales", "1:N scope"],
  ["categories", "sales", "1:N scope"],
];

async function buildErd(x, y, log) {
  const cols = 6;
  const boxW = 250;
  const boxH = 96;
  const gapX = 24;
  const gapY = 30;
  const rows = Math.ceil(ERD_ENTITIES.length / cols);
  const width = cols * boxW + (cols - 1) * gapX + 48;
  const height = 96 + rows * (boxH + gapY);
  await fjPanel(x, y, width, height, "Data model (ERD)");

  const boxes = {};
  for (let i = 0; i < ERD_ENTITIES.length; i++) {
    const [id, key] = ERD_ENTITIES[i];
    const col = i % cols;
    const row = Math.floor(i / cols);
    const bx = x + 24 + col * (boxW + gapX);
    const by = y + 72 + row * (boxH + gapY);
    boxes[id] = await fjShape(bx, by, boxW, boxH, `${id}\n${key}`, { size: 11 });
  }

  for (const [from, to, card] of ERD_RELATIONS) {
    if (boxes[from] && boxes[to]) fjConnect(boxes[from], boxes[to], card);
  }

  await fjText(
    x + 24,
    y + height - 40,
    "Dropped: businesses · business_orders · deliveries · pickup_stops · role_applications · return_requests · return_items",
    12,
    FJ.muted
  );
  const g = await fjEnd();
  log(`ERD built (${g ? g.w + "x" + g.h : "ungrouped"})`);
}

const MATRIX_ROWS = [
  ["Public catalog / category / brand / banner reads", "yes", "yes"],
  ["Own profile, addresses, wishlist, cart, orders, payments, notifications", "yes", "own account"],
  ["Add / update / remove cart lines", "yes", "no"],
  ["Validate coupon / preview totals / place order", "yes", "no"],
  ["Cancel own order", "pending / confirmed", "via transition"],
  ["Submit review", "delivered item, once", "no"],
  ["Product / variant / image CRUD", "no", "yes"],
  ["Category / brand CRUD", "no", "yes"],
  ["Sale / coupon / banner create, toggle, moderate", "no", "yes"],
  ["Order status transition / cancel", "no", "yes"],
  ["Mark COD paid", "no", "delivered COD only"],
  ["Reports, KPIs, audit log, platform settings", "no", "yes"],
];

function matrixCell(value) {
  if (value === "yes") return "✓";
  if (value === "no") return "—";
  return String(value);
}

async function buildMatrix(x, y, log) {
  const rowH = 44;
  const width = 1320;
  const height = 140 + MATRIX_ROWS.length * rowH;
  await fjPanel(x, y, width, height, "Permission matrix");

  const capX = x + 24;
  const colX = [capX + 780, capX + 1010];

  await fjText(capX, y + 76, "Capability", 13, FJ.muted, true);
  await fjText(colX[0], y + 76, "Customer", 13, FJ.muted, true);
  await fjText(colX[1], y + 76, "Admin", 13, FJ.muted, true);

  for (let i = 0; i < MATRIX_ROWS.length; i++) {
    const [cap, customer, admin] = MATRIX_ROWS[i];
    const ry = y + 108 + i * rowH;
    await fjText(capX, ry, cap, 12, FJ.ink);
    await fjText(colX[0], ry, matrixCell(customer), 12, FJ.ink);
    await fjText(colX[1], ry, matrixCell(admin), 12, FJ.ink);

    if (i < MATRIX_ROWS.length - 1) {
      const rule = figma.createRectangle();
      rule.resize(width - 48, 1);
      rule.x = capX;
      rule.y = ry + rowH - 12;
      rule.fills = [fjPaint(FJ.line)];
      rule.strokes = [];
    }
  }

  await fjText(
    x + 24,
    y + height - 34,
    "The UI is not a security boundary — is_admin() inside RPCs and RLS policies is.",
    12,
    FJ.muted
  );
  const g = await fjEnd();
  log(`permission matrix built (${g ? g.w + "x" + g.h : "ungrouped"})`);
}

const LAYERS = [
  ["core", ["supabaseClientProvider", "appRouterProvider", "themeControllerProvider"]],
  ["auth", ["authControllerProvider", "loginControllerProvider"]],
  ["catalog", ["productsControllerProvider", "productDetailControllerProvider", "homeProductsProvider", "homeBannersProvider", "categoriesProvider", "brandsProvider", "activeSalesProvider", "deliveryFeeMinorProvider"]],
  ["cart / checkout", ["cartControllerProvider", "checkoutControllerProvider"]],
  ["orders", ["ordersControllerProvider", "orderDetailControllerProvider", "reviewControllerProvider"]],
  ["profile", ["profileControllerProvider", "addressesControllerProvider", "dashboardControllerProvider"]],
  ["admin", ["adminKpisProvider", "adminProductsProvider", "adminOrdersProvider", "adminReportsProvider", "promotionsControllerProvider"]],
];

async function buildProviderMap(x, y, log) {
  const colW = 240;
  const gap = 16;
  const width = LAYERS.length * (colW + gap) + 48;
  const maxNodes = Math.max(...LAYERS.map((l) => l[1].length));
  const height = 120 + maxNodes * 52;
  await fjPanel(x, y, width, height, "State ownership and refresh paths");

  for (let i = 0; i < LAYERS.length; i++) {
    const [layer, nodes] = LAYERS[i];
    const cx = x + 24 + i * (colW + gap);
    await fjText(cx, y + 72, layer, 13, FJ.muted, true);
    for (let j = 0; j < nodes.length; j++) {
      await fjShape(cx, y + 98 + j * 52, colW, 42, nodes[j], {
        fill: FJ.primarySoft,
        size: 11,
      });
    }
  }

  await fjText(
    x + 24,
    y + height - 66,
    "Mutations: AsyncValue.guard then ref.invalidateSelf() — no optimistic writes.",
    12,
    FJ.muted
  );
  await fjText(
    x + 24,
    y + height - 44,
    "Orders, dashboard and notifications subscribe to realtime streams and keep last data on stream error.",
    12,
    FJ.muted
  );
  await fjText(
    x + 24,
    y + height - 22,
    "The router rebuilds structurally only on a role change.",
    12,
    FJ.muted
  );
  const g = await fjEnd();
  log(`state ownership built (${g ? g.w + "x" + g.h : "ungrouped"})`);
}

const PANELS_C = ["Data model (ERD)", "Permission matrix", "State ownership and refresh paths"];

async function batchFlowsC(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  await fjFont();

  fjClear(PANELS_C);

  await buildErd(1800, 1400, log);
  await buildMatrix(1800, 2160, log);
  await buildProviderMap(1800, 2960, log);

  return "Flows C — ERD, matrix, state ownership";
}

// ===== 90-runner.js =====
// ===== runner + UI =====

const BATCHES = {
  "flows-a": batchFlowsA,
  "flows-b": batchFlowsB,
  "flows-c": batchFlowsC,
  reset: batchReset,
  inspect: batchInspectBoard,
};

/**
 * Read-only: what the page actually holds. One line per top-level node with its type,
 * size and child count — the answer to "is each diagram really a group?".
 */
async function batchInspectBoard(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  const page = figma.currentPage;
  const nodes = page.children.slice();
  const counts = {};
  nodes.forEach((n) => {
    counts[n.type] = (counts[n.type] || 0) + 1;
  });

  nodes
    .sort((a, b) => a.y - b.y || a.x - b.x)
    .forEach((n) => {
      const kids = n.children ? n.children.length : 0;
      log(
        [
          n.type,
          n.name || "(unnamed)",
          `${Math.round(n.width)}x${Math.round(n.height)}`,
          `children ${kids}`,
          `at ${Math.round(n.x)},${Math.round(n.y)}`,
        ].join("\t")
      );
    });

  log("");
  log(
    `${nodes.length} top-level nodes · ` +
      Object.keys(counts)
        .sort()
        .map((k) => `${counts[k]} ${k}`)
        .join(" · ")
  );
  return `inspect — ${nodes.length} top-level nodes`;
}

/**
 * Clear the board. The board is generated end to end by this plugin, so there is
 * nothing to preserve; needed once to drop the pre-grouping diagrams, whose children
 * are page-level and unnamed (fjClear can only sweep them by position).
 */
async function batchReset(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  const page = figma.currentPage;
  const start = page.children.length;
  let total = 0;
  // Removal cascades (shapes take their connectors), so sweep passes until empty
  // instead of walking one stale snapshot.
  for (let pass = 0; pass < 20 && page.children.length; pass++) {
    total += fjRemove(page.children.slice());
  }
  log(`cleared ${total} of ${start} top-level nodes${page.children.length ? `, ${page.children.length} left` : ""}`);
  return `reset — ${total} nodes removed`;
}

const HTML = `
<!doctype html>
<html>
<head>
<style>
  body { margin: 0; font: 11px/1.5 -apple-system, "Segoe UI", system-ui, sans-serif;
         background: #1e1e1e; color: #e6e6e6; }
  .bar { display: flex; flex-wrap: wrap; gap: 6px; padding: 10px; background: #2c2c2c;
         border-bottom: 1px solid #3d3d3d; }
  button { font: inherit; padding: 5px 9px; border-radius: 6px; cursor: pointer;
           border: 1px solid #4a4a4a; background: #383838; color: #e6e6e6; }
  button:hover:not(:disabled) { background: #454545; }
  button:disabled { opacity: .45; cursor: default; }
  textarea { width: 100%; height: 260px; box-sizing: border-box; border: 0;
             background: #1e1e1e; color: #cfd8e3; font: 11px/1.45 ui-monospace, Menlo, monospace;
             padding: 10px; resize: none; outline: none; }
</style>
</head>
<body>
  <div class="bar">
    <button data-batch="flows-a">Flows A · nav + lifecycles</button>
    <button data-batch="flows-b">Flows B · sequences</button>
    <button data-batch="flows-c">Flows C · data + permissions</button>
    <button data-batch="reset">Reset · clear board</button>
    <button data-batch="inspect">Inspect · board</button>
    <button id="copy">Copy log</button>
  </div>
  <textarea id="log" readonly placeholder="Run a batch to see its report."></textarea>
<script>
  var logEl = document.getElementById("log");
  var buttons = Array.prototype.slice.call(document.querySelectorAll("button"));

  function setBusy(busy) { buttons.forEach(function (b) { b.disabled = busy; }); }

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
    if (m.type === "start" && logEl.value) logEl.value += "\\n";
    if (m.type === "done") setBusy(false);
  };
</script>
</body>
</html>
`;

async function run(batch) {
  const fn = BATCHES[batch];
  const log = (s) => figma.ui.postMessage({ type: "log", text: String(s) });
  if (!fn) {
    log(`unknown batch: ${batch}`);
    figma.ui.postMessage({ type: "done" });
    return;
  }

  figma.ui.postMessage({ type: "start", batch });
  log(`=== ${batch} ===`);
  try {
    const summary = await fn(log);
    if (WARNINGS.length) {
      log(`warnings (${WARNINGS.length}):`);
      WARNINGS.forEach((w) => log("  ! " + w));
    }
    log(`done: ${summary}`);
    figma.notify(summary, { timeout: 8000 });
  } catch (err) {
    const message = (err && err.message) || String(err);
    log(`FAILED: ${message}`);
    figma.notify(`Build failed: ${message}`, { error: true, timeout: 15000 });
  }
  figma.ui.postMessage({ type: "done" });
}

figma.showUI(HTML, { width: 460, height: 380, themeColors: true });
figma.ui.onmessage = async (msg) => {
  if (msg && msg.type === "run") await run(msg.batch);
};
