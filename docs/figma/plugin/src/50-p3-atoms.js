// ---------------------------------------------------------------------------
// batch: p3-atoms
// ---------------------------------------------------------------------------

/** Literal paint. Badge/monogram palettes are code constants, not ColorScheme slots. */
function literal(hex) {
  return { type: "SOLID", color: hexToRgb(hex) };
}

/** Mirror of statusBadgePalette in lib/core/presentation/theme/app_colors.dart. */
const BADGE_PAIRS = {
  Pending: ["#FFFBEB", "#B45309"],
  Confirmed: ["#EFF6FF", "#1D4ED8"],
  Processing: ["#EEF2FF", "#4338CA"],
  Packed: ["#F0F9FF", "#0369A1"],
  Shipped: ["#ECFEFF", "#0E7490"],
  OutForDelivery: ["#F0FDFA", "#0F766E"],
  Delivered: ["#ECFDF5", "#047857"],
  Cancelled: ["#FFF1F2", "#BE123C"],
  Refunded: ["#F1F5F9", "#334155"],
  Unknown: ["#F1F5F9", "#334155"],
};

/** Mirror of _MonogramFallback._pairs — (bg, fg), picked by code-unit sum. */
const MONO_PAIRS = [
  ["#1E3A8A", "#EFF6FF"],
  ["#059669", "#ECFDF5"],
  ["#0E7490", "#ECFEFF"],
  ["#7E22CE", "#FAF5FF"],
  ["#BE123C", "#FFF1F2"],
  ["#B45309", "#FFFBEB"],
];

function monogramPair(name) {
  const sum = name.split("").reduce((a, ch) => a + ch.charCodeAt(0), 0);
  return MONO_PAIRS[Math.abs(sum) % MONO_PAIRS.length];
}

function monogramInitials(name) {
  const words = name.trim().split(/\s+/).filter((w) => w.length > 0).slice(0, 2);
  const out = words.map((w) => w[0].toUpperCase()).join("");
  return out || "?";
}

/** Instance a Button variant if the set exposes it; otherwise nothing. */
function buttonInstance(name) {
  const comp = CTX.page.findOne((n) => n.type === "COMPONENT" && n.name === name);
  if (!comp) return null;
  try {
    return comp.createInstance();
  } catch (e) {
    return null;
  }
}

function block(width, height, fillName, radius) {
  const r = figma.createRectangle();
  r.resize(width, height);
  r.cornerRadius = radius || 0;
  r.fills = fillName ? [solid(fillName)] : [];
  return r;
}

function logVariant(c, log) {
  log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
}

// -- PriceText: Mode x Emphasis (6) -----------------------------------------

async function buildPriceText(parent, log) {
  const variants = [];
  const modes = [
    { mode: "UsdOnly", usd: "$18.00", khr: null, strike: null },
    { mode: "UsdAndKhr", usd: "$18.00", khr: "≈ 73,800 KHR", strike: null },
    { mode: "Sale", usd: "$18.00", khr: "≈ 73,800 KHR", strike: "$24.00" },
  ];
  const emphases = [
    { emphasis: "Default", ink: "color/on-surface" },
    { emphasis: "Highlight", ink: "color/primary" },
  ];

  for (const m of modes) {
    for (const e of emphases) {
      const c = figma.createComponent();
      c.name = `Mode=${m.mode}, Emphasis=${e.emphasis}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: 1 });
      c.fills = [];

      if (m.strike) {
        const old = await text(m.strike, "priceHighlight", "color/on-surface-variant");
        old.textDecoration = "STRIKETHROUGH";
        c.appendChild(old);
      }
      c.appendChild(await text(m.usd, "priceHighlight", e.ink));
      if (m.khr) {
        c.appendChild(await text(m.khr, "bodySmall", "color/on-surface-variant"));
      }
      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "PriceText";
  grid(set, variants, 2, 32, 32);
  log(`PriceText: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- StatusBadge: Status x Density (20) -------------------------------------

async function buildStatusBadge(parent, log) {
  const variants = [];
  const statuses = Object.keys(BADGE_PAIRS);
  const densities = [
    { density: "Default", pad: [4, 8, 4, 8] },
    { density: "Dense", pad: [2, 6, 2, 6] },
  ];

  for (const status of statuses) {
    for (const d of densities) {
      const c = figma.createComponent();
      c.name = `Status=${status}, Density=${d.density}`;
      parent.appendChild(c);

      autolayout(c, { dir: "HORIZONTAL", gap: 4, pad: d.pad, cross: "CENTER" });
      c.cornerRadius = 8;
      bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r8));
      c.fills = [literal(BADGE_PAIRS[status][0])];

      const label = await text(status === "OutForDelivery" ? "Out for delivery" : status, "labelSmall", null);
      label.fills = [literal(BADGE_PAIRS[status][1])];
      c.appendChild(label);

      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "StatusBadge";
  grid(set, variants, 5, 16, 16);
  log(`StatusBadge: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: badge colors are code constants (not ColorScheme slots); dark pairs are computed in code and deferred");
  return set;
}

// -- Skeleton: Shape x Density (8) -----------------------------------------

async function buildSkeleton(parent, log) {
  const variants = [];
  const shapes = ["Block", "Line", "ListView", "Grid"];
  const densities = [
    { density: "Compact", gap: 8, block: [120, 96], line: 120, cell: [100, 80] },
    { density: "Regular", gap: 16, block: [160, 128], line: 220, cell: [140, 100] },
  ];

  for (const shape of shapes) {
    for (const d of densities) {
      const c = figma.createComponent();
      c.name = `Shape=${shape}, Density=${d.density}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: d.gap });
      c.fills = [];
      bindGap(c, d.gap === 8 ? SPACE.sm : SPACE.md);

      if (shape === "Block") {
        c.appendChild(block(d.block[0], d.block[1], "color/surface-container-high", 12));
      } else if (shape === "Line") {
        c.appendChild(block(d.line, 14, "color/surface-container-high", 12));
      } else if (shape === "ListView") {
        c.appendChild(block(d.line, 14, "color/surface-container-high", 12));
        c.appendChild(block(Math.round(d.line * 0.8), 14, "color/surface-container-high", 12));
        c.appendChild(block(Math.round(d.line * 0.6), 14, "color/surface-container-high", 12));
      } else {
        const rowA = figma.createFrame();
        rowA.fills = [];
        autolayout(rowA, { dir: "HORIZONTAL", gap: d.gap });
        rowA.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        rowA.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        const rowB = figma.createFrame();
        rowB.fills = [];
        autolayout(rowB, { dir: "HORIZONTAL", gap: d.gap });
        rowB.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        rowB.appendChild(block(d.cell[0], d.cell[1], "color/surface-container-high", 12));
        c.appendChild(rowA);
        c.appendChild(rowB);
        hugBoth(rowA);
        hugBoth(rowB);
      }

      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "Skeleton";
  grid(set, variants, 4, 32, 32);
  log(`Skeleton: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- EmptyState: Action (2) ------------------------------------------------

function iconPlate(size, plateColorName, iconName) {
  const plate = figma.createFrame();
  plate.fills = [solid(plateColorName)];
  plate.cornerRadius = size / 2;
  autolayout(plate, { dir: "VERTICAL", cross: "CENTER" });
  plate.primaryAxisAlignItems = "CENTER";
  plate.counterAxisAlignItems = "CENTER";
  plate.primaryAxisSizingMode = "FIXED";
  plate.counterAxisSizingMode = "FIXED";
  safeResize(plate, size, size);
  const glyph = icon(iconName, "color/on-surface-variant");
  if (glyph) plate.appendChild(glyph);
  return plate;
}

async function buildEmptyState(parent, log) {
  const variants = [];
  const actions = [
    { action: "None", label: null },
    { action: "Primary", label: "Start shopping" },
  ];

  for (const a of actions) {
    const c = figma.createComponent();
    c.name = `Action=${a.action}`;
    parent.appendChild(c);

    autolayout(c, { dir: "VERTICAL", gap: 24, pad: [32, 32, 32, 32], cross: "CENTER" });
    bindSpace(c, ["top", "right", "bottom", "left"], SPACE.xl);
    bindGap(c, SPACE.lg);
    c.fills = [];

    c.appendChild(iconPlate(72, "color/surface-container", "shopping_cart"));

    const copy = figma.createFrame();
    copy.fills = [];
    autolayout(copy, { dir: "VERTICAL", gap: 8, cross: "CENTER" });
    fixedWidth(copy, 262);
    copy.counterAxisAlignItems = "CENTER";
    const title = await text("Your cart is empty", "titleMedium", "color/on-surface");
    title.textAlignHorizontal = "CENTER";
    copy.appendChild(title);

    const body = await text("Items you add will show up here.", "bodySmall", "color/on-surface-variant");
    body.textAutoResize = "HEIGHT";
    safeResize(body, 262, body.height);
    body.textAlignHorizontal = "CENTER";
    copy.appendChild(body);

    c.appendChild(copy);

    if (a.label) {
      const btn = buttonInstance("Variant=Secondary, State=Default");
      if (btn) {
        c.appendChild(btn);
      } else {
        warn("Button variant Secondary/Default not found; using a text label");
        c.appendChild(await text(a.label, "labelLarge", "color/primary"));
      }
    }

    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "EmptyState";
  grid(set, variants, 2, 32, 32);
  log(`EmptyState: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- AsyncValue: State (3) -------------------------------------------------

async function buildAsyncValue(parent, log) {
  const variants = [];

  // Loading
  {
    const c = figma.createComponent();
    c.name = "State=Loading";
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 8, pad: [16, 16, 16, 16] });
    c.fills = [];
    c.appendChild(block(294, 140, "color/surface-container-high", 12));
    c.appendChild(block(180, 14, "color/surface-container-high", 12));
    c.appendChild(block(120, 14, "color/surface-container-high", 12));
    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
  }

  // Error
  {
    const c = figma.createComponent();
    c.name = "State=Error";
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 16, pad: [32, 32, 32, 32], cross: "CENTER" });
    c.fills = [];

    const art = block(80, 80, "color/surface-container", 16);
    c.appendChild(art);

    const msg = await text("We couldn't load this right now.", "bodyMedium", "color/on-surface");
    msg.textAutoResize = "HEIGHT";
    safeResize(msg, 262, msg.height);
    msg.textAlignHorizontal = "CENTER";
    c.appendChild(msg);

    const retry = buttonInstance("Variant=Secondary, State=Default");
    if (retry) c.appendChild(retry);
    else c.appendChild(await text("Retry", "labelLarge", "color/primary"));

    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
    log("note: error art is a placeholder plate; the app uses AppIllustrations.error");
  }

  // Data
  {
    const c = figma.createComponent();
    c.name = "State=Data";
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 8, pad: [16, 16, 16, 16] });
    c.fills = [];
    c.appendChild(block(294, 160, "color/surface-container-high", 12));
    c.appendChild(block(220, 14, "color/surface-container-high", 12));
    c.appendChild(block(140, 14, "color/surface-container-high", 12));
    fixedWidth(c, 326);
    logVariant(c, log);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "AsyncValue";
  grid(set, variants, 3, 32, 32);
  log(`AsyncValue: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- MonogramImage: State (4) ----------------------------------------------

async function buildMonogramImage(parent, log) {
  const variants = [];
  const states = [
    { state: "Loading", name: "Kirirom Coffee" },
    { state: "Loaded", name: "Kirirom Coffee" },
    { state: "Error", name: "Angkor Mart" },
    { state: "Empty", name: "" },
  ];

  for (const s of states) {
    const c = figma.createComponent();
    c.name = `State=${s.state}`;
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", cross: "CENTER" });
    c.primaryAxisAlignItems = "CENTER";
    c.counterAxisSizingMode = "FIXED";
    c.primaryAxisSizingMode = "FIXED";
    safeResize(c, 96, 96);

    if (s.state === "Loading") {
      c.fills = [solid("color/surface-container-high")];
    } else if (s.state === "Loaded") {
      c.fills = [solid("color/surface-container")];
      const label = await text("image", "bodySmall", "color/on-surface-variant");
      c.appendChild(label);
    } else {
      const [bg, fg] = monogramPair(s.name);
      c.fills = [literal(bg)];
      const initials = await text(monogramInitials(s.name), "monogram", null);
      initials.fills = [literal(fg)];
      c.appendChild(initials);
    }

    logVariant(c, log);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "MonogramImage";
  grid(set, variants, 4, 24, 24);
  log(`MonogramImage: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: accent pairs are code constants; Error and Empty render identically (both fall back to the monogram)");
  return set;
}

async function batchAtoms(log) {
  const parent = parentFor();
  const built = [];

  clearOrphans(parent);
  for (const [name, fn] of [
    ["PriceText", buildPriceText],
    ["StatusBadge", buildStatusBadge],
    ["Skeleton", buildSkeleton],
    ["EmptyState", buildEmptyState],
    ["AsyncValue", buildAsyncValue],
    ["MonogramImage", buildMonogramImage],
  ]) {
    clearOld(parent, name);
    const set = await fn(parent, log);
    placeBelow(parent, set);
    parent.appendChild(set);
    built.push(set);
  }
  return `P3 atoms — ${built.length} sets`;
}

