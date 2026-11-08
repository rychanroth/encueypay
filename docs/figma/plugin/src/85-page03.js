// ===== batch: p6-contracts =====
// Page 03: motion tokens, a four-step storyboard, and the cross-cutting
// contracts. Text-forward by design — this page documents, it does not draw app
// surfaces.

async function contractsPage() {
  await context();
  const page = figma.root.children.find((p) => p.name === "03 · Motion & Contracts");
  if (!page) throw new Error('Page "03 · Motion & Contracts" not found.');
  await figma.setCurrentPageAsync(page);
  return page;
}

function docCard(x, y, width, title) {
  const c = figma.createFrame();
  c.name = title;
  c.fills = [solid("color/surface-container-lowest")];
  c.strokes = [solid("color/outline-variant")];
  c.strokeWeight = 1;
  c.cornerRadius = 16;
  c.clipsContent = false;
  autolayout(c, { dir: "VERTICAL", gap: 10, pad: [20, 20, 20, 20] });
  c.x = x;
  c.y = y;
  c.counterAxisSizingMode = "FIXED";
  safeResize(c, width, 200);
  return c;
}

async function kvRow(parent, key, value) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 12 });
  parent.appendChild(row);
  fill(row);
  const k = await text(key, "labelMedium", "color/on-surface-variant");
  k.textAutoResize = "HEIGHT";
  safeResize(k, 120, k.height);
  row.appendChild(k);
  const v = await text(value, "bodyMedium", "color/on-surface");
  v.textAutoResize = "HEIGHT";
  v.layoutGrow = 1;
  row.appendChild(v);
  return row;
}

async function bullet(parent, chars) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 8 });
  parent.appendChild(row);
  fill(row);
  const dot = figma.createEllipse();
  dot.resize(5, 5);
  dot.fills = [solid("color/on-surface-variant")];
  row.appendChild(dot);
  const t = await text(chars, "bodyMedium", "color/on-surface");
  t.textAutoResize = "HEIGHT";
  t.layoutGrow = 1;
  row.appendChild(t);
  return row;
}

async function storyboardStep(parent, index, caption) {
  const col = figma.createFrame();
  col.fills = [];
  autolayout(col, { dir: "VERTICAL", gap: 6, cross: "CENTER" });
  parent.appendChild(col);
  col.layoutGrow = 1;

  const tile = figma.createFrame();
  tile.fills = [solid("color/surface-container")];
  tile.cornerRadius = 12;
  autolayout(tile, { dir: "VERTICAL", cross: "CENTER" });
  tile.primaryAxisAlignItems = "CENTER";
  tile.counterAxisAlignItems = "CENTER";
  tile.primaryAxisSizingMode = "FIXED";
  tile.counterAxisSizingMode = "FIXED";
  safeResize(tile, 96, 96);
  col.appendChild(tile);

  // A button-ish pill whose weight changes per step, so the strip reads as a
  // progression rather than four identical boxes.
  const pill = figma.createFrame();
  pill.cornerRadius = 8;
  pill.primaryAxisSizingMode = "FIXED";
  pill.counterAxisSizingMode = "FIXED";
  safeResize(pill, index === 1 ? 52 : 56, index === 1 ? 26 : 28);
  pill.fills = [
    solid(index >= 2 ? "color/primary" : "color/on-surface-variant"),
  ];
  try {
    pill.opacity = index === 2 ? 0.7 : 1;
  } catch (e) {}
  tile.appendChild(pill);

  const step = await text(String(index + 1), "labelMedium", "color/on-surface-variant");
  col.appendChild(step);
  const cap = await text(caption, "bodySmall", "color/on-surface-variant");
  cap.textAutoResize = "HEIGHT";
  safeResize(cap, 96, cap.height);
  cap.textAlignHorizontal = "CENTER";
  col.appendChild(cap);
  return col;
}

async function batchContracts(log) {
  const page = await contractsPage();
  const own = ["Motion · tokens", "Motion · storyboard", "Contracts · invariants"];
  // The heading and subtitle are page children, not part of any docCard, so a
  // re-run used to append a second copy at the same (80, 40). Sweep them too.
  page.children
    .filter((n) => own.includes(n.name) || n.type === "TEXT")
    .forEach((n) => n.remove());

  const title = await text("Motion & cross-cutting contracts", "headlineMedium", "color/on-surface");
  page.appendChild(title);
  title.name = "Contracts · title";
  title.x = 80;
  title.y = 40;

  const sub = await text(
    "Source: lib/core/presentation/motion.dart and docs/architecture-contract.md. The storyboard is illustrative — do not recreate keyframe timelines here.",
    "bodyMedium",
    "color/on-surface-variant"
  );
  page.appendChild(sub);
  sub.name = "Contracts · subtitle";
  sub.x = 80;
  sub.y = 84;

  // --- motion tokens -------------------------------------------------------
  const tokens = docCard(80, 140, 520, "Motion · tokens");
  page.appendChild(tokens);
  tokens.appendChild(await text("Durations", "titleMedium", "color/on-surface"));
  await kvRow(tokens, "press", "160 ms — tap feedback");
  await kvRow(tokens, "enter", "240 ms — content appears");
  await kvRow(tokens, "exit", "200 ms — content leaves");
  await kvRow(tokens, "stagger", "360 ms — list reveal");

  tokens.appendChild(await text("Curves", "titleMedium", "color/on-surface"));
  await kvRow(tokens, "enterCurve", "easeOutCubic");
  await kvRow(tokens, "exitCurve", "easeInCubic");
  await kvRow(tokens, "layoutCurve", "easeInOutCubic");

  tokens.appendChild(await text("Reduced motion", "titleMedium", "color/on-surface"));
  await bullet(tokens, "disableAnimations collapses every duration to zero.");
  await bullet(tokens, "The order-timeline pulse freezes at opacity 1.0 rather than stopping mid-fade.");
  await bullet(tokens, "Skeletons ignore reduced motion today — a known gap, not a decision.");

  // --- storyboard ----------------------------------------------------------
  const board = docCard(640, 140, 520, "Motion · storyboard");
  page.appendChild(board);
  board.appendChild(await text("Primary button, tap to settled", "titleMedium", "color/on-surface"));

  const strip = figma.createFrame();
  strip.fills = [];
  autolayout(strip, { dir: "HORIZONTAL", gap: 12, cross: "MIN" });
  board.appendChild(strip);
  fill(strip);

  await storyboardStep(strip, 0, "Idle");
  await storyboardStep(strip, 1, "Press\n160 ms");
  await storyboardStep(strip, 2, "Enter\n240 ms");
  await storyboardStep(strip, 3, "Settled");

  await bullet(board, "Press dims and scales to 0.98; release returns with easeOutCubic.");
  await bullet(board, "Screen enter is a 240 ms fade plus an 8 dp rise; exit is 200 ms and does not wait.");
  await bullet(board, "Lists stagger at 360 ms so rows are read in order.");

  // --- contracts -----------------------------------------------------------
  const contracts = docCard(1200, 140, 520, "Contracts · invariants");
  page.appendChild(contracts);
  contracts.appendChild(await text("Architecture", "titleMedium", "color/on-surface"));
  await bullet(contracts, "presentation → domain ← data. Features never import features; core never imports features except core/router.");
  await bullet(contracts, "DTOs never leave data/; mapping happens through <Dto>X.toDomain().");
  await bullet(contracts, "Failures are mapped once, at the repository boundary, via mapRepositoryError.");

  contracts.appendChild(await text("State", "titleMedium", "color/on-surface"));
  await bullet(contracts, "Mutations use AsyncValue.guard then ref.invalidateSelf(); there are no optimistic writes.");
  await bullet(contracts, "Every controller surface shares one loading / empty / error / data vocabulary.");

  contracts.appendChild(await text("Boundaries", "titleMedium", "color/on-surface"));
  await bullet(contracts, "Route names exist only as AppRoutes constants, used with context.goNamed.");
  await bullet(contracts, "No local database or cache. shared_preferences stores the theme mode and nothing else.");
  await bullet(contracts, "The server prices the cart and the order; the client never computes a charge.");

  log("motion tokens, storyboard and contracts written");
  return "P6 — page 03";
}
