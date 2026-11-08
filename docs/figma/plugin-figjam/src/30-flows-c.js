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
  log("ERD built");
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
  log("permission matrix built");
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
  log("state ownership built");
}

const PANELS_C = ["Data model (ERD)", "Permission matrix", "State ownership and refresh paths"];

async function batchFlowsC(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  await fjFont();

  figma.currentPage.children
    .filter((n) => PANELS_C.includes(n.name))
    .forEach((n) => n.remove());

  await buildErd(1800, 1400, log);
  await buildMatrix(1800, 2160, log);
  await buildProviderMap(1800, 2960, log);

  return "Flows C — ERD, matrix, state ownership";
}
