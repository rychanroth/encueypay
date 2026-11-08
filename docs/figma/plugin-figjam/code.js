/**
 * GENERATED FILE — do not edit directly.
 * Sources: docs/figma/plugin/src/*.js (3 files)
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

async function fjNavShell(x, y, caption, tabs, colW, rowGap) {
  await fjText(x, y, caption, 13, FJ.muted, true);
  const tabY = y + 28;
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
  return boxes;
}

async function buildNavigation(x, y, log) {
  await fjPanel(x, y, 1700, 1320, "Navigation map");

  const login = await fjShape(x + 24, y + 64, 220, 64, "login\n/login\noutside shell", {
    fill: FJ.warnSoft,
    stroke: FJ.warnInk,
  });
  const customer = await fjNavShell(x + 24, y + 148, "Customer shell — 5 tabs", NAV_CUSTOMER, 250, 12);
  await fjNavShell(x + 24, y + 600, "Admin shell — 4 tabs", NAV_ADMIN, 250, 12);

  fjConnect(login, customer[0]);
  log("navigation built");
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
  log("order lifecycle built");
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
  log("payment lifecycle built");
}

const PANELS = ["Navigation map", "Order lifecycle", "Payment lifecycle"];

async function batchFlowsA(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  await fjFont();

  figma.currentPage.children
    .filter((n) => PANELS.includes(n.name))
    .forEach((n) => n.remove());

  await buildNavigation(0, 0, log);
  await buildOrderLifecycle(1800, 0, log);
  await buildPaymentLifecycle(1800, 480, log);

  return "Flows A — 3 diagrams";
}

// ===== 90-runner.js =====
// ===== runner + UI =====

const BATCHES = {
  "flows-a": batchFlowsA,
};

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
