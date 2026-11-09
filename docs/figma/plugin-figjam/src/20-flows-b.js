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
