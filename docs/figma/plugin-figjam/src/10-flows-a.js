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
