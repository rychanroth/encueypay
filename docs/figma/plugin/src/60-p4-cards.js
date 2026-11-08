// ---------------------------------------------------------------------------
// batch: p4-cards
// ---------------------------------------------------------------------------

/** Small rounded label chip (product pills, availability). */
async function pill(label, bgName, fgPaint, iconName) {
  const chip = figma.createFrame();
  autolayout(chip, { dir: "HORIZONTAL", gap: 4, pad: [3, 8, 3, 8], cross: "CENTER" });
  chip.cornerRadius = 8;
  chip.fills = bgName ? [solid(bgName)] : [];

  if (iconName) {
    const g = icon(iconName, null);
    if (g) {
      g.findAll((n) => n.type === "VECTOR").forEach((v) => (v.fills = [fgPaint]));
      chip.appendChild(g);
    }
  }
  const t = await text(label, "labelSmall", null);
  t.fills = [fgPaint];
  chip.appendChild(t);

  hugBoth(chip);
  return chip;
}

// -- KhqrCard: State (3) ---------------------------------------------------

async function buildKhqrCard(parent, log) {
  const variants = [];
  const states = [
    { state: "PendingPayload", note: "Waiting for payment details", verified: false },
    { state: "Ready", note: "Scan with any KHQR-supported banking app", verified: false },
    { state: "Verified", note: "Scan with any KHQR-supported banking app", verified: true },
  ];

  for (const s of states) {
    const c = figma.createComponent();
    c.name = `State=${s.state}`;
    parent.appendChild(c);
    autolayout(c, { dir: "VERTICAL", gap: 0 });
    c.cornerRadius = 16;
    bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r16));
    c.fills = [solid("brand/khqr-surface")];
    c.clipsContent = true;

    // header
    const header = figma.createFrame();
    header.fills = [solid("brand/khqr-red")];
    autolayout(header, { dir: "HORIZONTAL", pad: [10, 16, 10, 16], cross: "CENTER" });
    header.primaryAxisAlignItems = "SPACE_BETWEEN";
    c.appendChild(header);
    header.layoutSizingHorizontal = "FILL";
    header.layoutSizingVertical = "AUTO";

    const word = await text("KHQR", "titleLarge", null);
    word.fills = [literal("#FFFFFF")];
    word.letterSpacing = { unit: "PIXELS", value: 1.5 };
    header.appendChild(word);

    const bakong = await text("BAKONG", "labelMedium", null);
    bakong.fills = [literal("#FFFFFF")];
    bakong.letterSpacing = { unit: "PIXELS", value: 2 };
    header.appendChild(bakong);

    // body
    const body = figma.createFrame();
    body.fills = [];
    autolayout(body, { dir: "VERTICAL", gap: 4, pad: [24, 24, 24, 24], cross: "CENTER" });
    c.appendChild(body);
    body.layoutSizingHorizontal = "FILL";
    body.layoutSizingVertical = "AUTO";

    body.appendChild(await text("EncueYPay Prototype", "titleMedium", "color/on-surface"));
    body.appendChild(await text("$18.00", "priceHighlight", "color/on-surface"));
    body.appendChild(await text("≈ 73,800 KHR", "bodySmall", "color/on-surface-variant"));

    const qrFrame = figma.createFrame();
    qrFrame.fills = [];
    autolayout(qrFrame, { dir: "VERTICAL", pad: [8, 8, 8, 8] });
    qrFrame.cornerRadius = 8;
    qrFrame.strokes = [solid("color/outline")];
    qrFrame.strokeWeight = 1;
    qrFrame.primaryAxisSizingMode = "AUTO";
    qrFrame.counterAxisSizingMode = "AUTO";
    body.appendChild(qrFrame);

    const qr = figma.createFrame();
    qr.resize(220, 220);
    qr.fills = [solid("color/surface-container")];
    autolayout(qr, { dir: "VERTICAL", cross: "CENTER" });
    qr.primaryAxisAlignItems = "CENTER";
    qr.counterAxisAlignItems = "CENTER";
    qr.counterAxisSizingMode = "FIXED";
    qr.primaryAxisSizingMode = "FIXED";
    safeResize(qr, 220, 220);
    qrFrame.appendChild(qr);
    qr.appendChild(
      await text(s.state === "PendingPayload" ? "no payload" : "QR payload", "bodySmall", "color/on-surface-variant")
    );

    if (s.verified) {
      const row = figma.createFrame();
      row.fills = [];
      autolayout(row, { dir: "HORIZONTAL", gap: 4, cross: "CENTER" });
      body.appendChild(row);
      const check = icon("check_circle", "color/tertiary");
      if (check) row.appendChild(check);
      row.appendChild(await text("Payment verified", "labelSmall", "color/tertiary"));
    }

    body.appendChild(await text(s.note, "labelSmall", "color/on-surface-variant"));

    fixedWidth(c, 342);
    logVariant(c, log);
    variants.push(c);
    log("note: QR is a placeholder plate — the payload is server-resolved and must not be faked");
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "KhqrCard";
  grid(set, variants, 3, 32, 32);
  log(`KhqrCard: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- OrderStatusTimeline: StageState x Terminal (6) ------------------------

const TIMELINE_STAGES = [
  "Pending", "Confirmed", "Processing", "Packed", "Shipped", "Out for Delivery", "Delivered",
];

function nodeDot(state, colorName) {
  const dot = figma.createFrame();
  dot.fills = state === "Upcoming" ? [solid("color/surface-container-lowest")] : [solid(colorName)];
  dot.cornerRadius = 11;
  dot.strokes = [solid(colorName)];
  dot.strokeWeight = 2;
  autolayout(dot, { dir: "VERTICAL", cross: "CENTER" });
  dot.primaryAxisAlignItems = "CENTER";
  dot.counterAxisAlignItems = "CENTER";
  dot.primaryAxisSizingMode = "FIXED";
  dot.counterAxisSizingMode = "FIXED";
  safeResize(dot, 22, 22);
  if (state === "Done") {
    const mark = figma.createFrame();
    mark.fills = [literal("#FFFFFF")];
    mark.cornerRadius = 5;
    safeResize(mark, 10, 10);
    dot.appendChild(mark);
  } else if (state === "Current") {
    const core = figma.createFrame();
    core.fills = [literal("#FFFFFF")];
    core.cornerRadius = 8;
    safeResize(core, 8, 8);
    dot.appendChild(core);
  }
  return dot;
}

async function buildOrderStatusTimeline(parent, log) {
  const variants = [];
  const stageStates = ["Done", "Current", "Upcoming"];
  const terminals = ["InFlight", "Cancelled"];
  const focus = 3; // the row whose state the axis controls

  for (const terminal of terminals) {
    for (const stageState of stageStates) {
      const c = figma.createComponent();
      c.name = `StageState=${stageState}, Terminal=${terminal}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: 0 });
      c.fills = [];

      if (terminal === "Cancelled") {
        const banner = figma.createFrame();
        banner.fills = [solid("color/error-container")];
        banner.cornerRadius = 12;
        autolayout(banner, { dir: "HORIZONTAL", gap: 8, pad: [16, 16, 16, 16], cross: "CENTER" });
        banner.primaryAxisSizingMode = "FIXED";
        banner.counterAxisSizingMode = "AUTO";
        fixedWidth(banner, 326);
        c.appendChild(banner);

        const glyph = icon("error", "color/on-error-container");
        if (glyph) banner.appendChild(glyph);
        banner.appendChild(
          await text("This order was cancelled.", "bodyMedium", "color/on-error-container")
        );
        logVariant(c, log);
        variants.push(c);
        continue;
      }

      for (let i = 0; i < TIMELINE_STAGES.length; i++) {
        const state =
          i < focus ? "Done" : i === focus ? stageState : "Upcoming";
        const colorName =
          state === "Done" ? "color/tertiary" : state === "Current" ? "color/primary" : "color/on-surface-variant";

        const row = figma.createFrame();
        row.fills = [];
        autolayout(row, { dir: "HORIZONTAL", gap: 10, cross: "CENTER" });
        row.primaryAxisSizingMode = "AUTO";
        row.counterAxisSizingMode = "AUTO";
        c.appendChild(row);

        const track = figma.createFrame();
        track.fills = [];
        autolayout(track, { dir: "VERTICAL", gap: 0, cross: "CENTER" });
        row.appendChild(track);

        const lineColor = state === "Done" ? colorName : "color/outline-variant";
        if (i > 0) track.appendChild(rect(2, 14, lineColor, 0));
        track.appendChild(nodeDot(state, colorName));
        if (i < TIMELINE_STAGES.length - 1) track.appendChild(rect(2, 14, lineColor, 0));

        row.appendChild(
          await text(TIMELINE_STAGES[i], "labelLarge", state === "Upcoming" ? "color/on-surface-variant" : "color/on-surface")
        );
      }

      hugBoth(c);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "OrderStatusTimeline";
  grid(set, variants, 3, 40, 40);
  log(`OrderStatusTimeline: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- OrderTrackingCard: State x Detail (6) --------------------------------

async function simplifiedTimeline(labels, currentIndex) {
  const row = figma.createFrame();
  row.fills = [];
  autolayout(row, { dir: "HORIZONTAL", gap: 0, cross: "MIN" });
  for (let i = 0; i < labels.length; i++) {
    const col = figma.createFrame();
    col.fills = [];
    autolayout(col, { dir: "VERTICAL", gap: 4, cross: "CENTER" });
    col.layoutGrow = 1;
    row.appendChild(col);

    const track = figma.createFrame();
    track.fills = [];
    autolayout(track, { dir: "HORIZONTAL", cross: "CENTER" });
    col.appendChild(track);
    track.layoutAlign = "STRETCH";

    if (i > 0) {
      const seg = rect(10, 2, i <= currentIndex ? "color/tertiary" : "color/outline-variant", 0);
      seg.layoutGrow = 1;
      track.appendChild(seg);
    }
    const done = i < currentIndex;
    const current = i === currentIndex;
    const dotColor = done ? "color/tertiary" : current ? "color/primary" : "color/on-surface-variant";
    const dot = figma.createFrame();
    dot.fills = [done ? solid("color/tertiary") : current ? solid("color/primary") : []];
    dot.cornerRadius = 8;
    dot.strokes = [solid(dotColor)];
    dot.strokeWeight = 2;
    dot.primaryAxisSizingMode = "FIXED";
    dot.counterAxisSizingMode = "FIXED";
    safeResize(dot, 16, 16);
    track.appendChild(dot);
    if (i < labels.length - 1) {
      const seg = rect(10, 2, i < currentIndex ? "color/tertiary" : "color/outline-variant", 0);
      seg.layoutGrow = 1;
      track.appendChild(seg);
    }

    const label = await text(labels[i], "bodySmall", i <= currentIndex ? "color/on-surface" : "color/on-surface-variant");
    label.textAutoResize = "NONE";
    safeResize(label, 70, 17);
    label.textAlignHorizontal = "CENTER";
    col.appendChild(label);
  }
  return row;
}

async function buildOrderTrackingCard(parent, log) {
  const variants = [];
  const states = ["InFlight", "Delivered", "Cancelled"];
  const details = ["Simplified", "ExactStatus"];
  const headlines = {
    InFlight: "Packed and ready to ship",
    Delivered: null,
    Cancelled: null,
  };

  for (const state of states) {
    for (const detail of details) {
      const c = figma.createComponent();
      c.name = `State=${state}, Detail=${detail}`;
      parent.appendChild(c);
      autolayout(c, { dir: "VERTICAL", gap: 4, pad: [16, 16, 16, 16] });
      c.cornerRadius = 16;
      c.strokes = [solid("color/outline-variant")];
      c.strokeWeight = 1;
      c.fills = [solid("color/surface-container-lowest")];

      if (headlines[state]) {
        c.appendChild(await text(headlines[state], "titleMedium", "color/on-surface"));
      }
      c.appendChild(await text("Order #4F2A9C81", "bodySmall", "color/on-surface-variant"));

      if (state === "InFlight") {
        const tl = await simplifiedTimeline(["Placed", "Preparing", "On its way", "Delivered"], 2);
        c.appendChild(tl);
      }

      const showExact = detail === "ExactStatus" || state !== "InFlight";
      if (showExact) {
        const exact = figma.createFrame();
        exact.fills = [];
        autolayout(exact, { dir: "VERTICAL", gap: 0 });
        c.appendChild(exact);
        // Reuse the timeline component instance.
        const tlComp = CTX.page.findOne(
          (n) => n.type === "COMPONENT" && n.name === "StageState=Current, Terminal=InFlight"
        );
        if (tlComp) {
          const inst = tlComp.createInstance();
          exact.appendChild(inst);
        } else {
          warn("OrderStatusTimeline instance not found; card renders without the exact track");
        }
      }

      if (state === "InFlight") {
        c.appendChild(await text("Show exact status", "labelLarge", "color/primary"));
      }

      fixedWidth(c, 342);
      logVariant(c, log);
      variants.push(c);
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "OrderTrackingCard";
  grid(set, variants, 2, 32, 32);
  log(`OrderTrackingCard: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

// -- ProductCard: Availability x Promo x Wishlisted x Loading (48) --------

const AVAILABILITY = {
  InStock: null,
  LowStock: "Only 3 left",
  OutOfStock: "Out of stock",
  Archived: "Archived",
};

async function buildProductCard(parent, log) {
  const variants = [];
  const W = 171;
  const H = 268;
  const IMAGE_H = 142;
  const productName = "Kirirom Coffee";
  const [monoBg, monoFg] = monogramPair(productName);

  for (const availability of Object.keys(AVAILABILITY)) {
    for (const promo of ["None", "Sale", "New"]) {
      for (const wishlisted of ["No", "Yes"]) {
        for (const loading of ["No", "Yes"]) {
          const c = figma.createComponent();
          c.name = `Availability=${availability}, Promo=${promo}, Wishlisted=${wishlisted}, Loading=${loading}`;
          parent.appendChild(c);
          autolayout(c, { dir: "VERTICAL", gap: 0 });
          c.cornerRadius = 16;
          c.fills = [solid("color/surface-container-lowest")];
          c.clipsContent = true;

          // ---- image area (fixed height so chip offsets stay deterministic) ----
          const image = figma.createFrame();
          image.fills = [];
          image.clipsContent = true;
          c.appendChild(image);
          safeResize(image, W, IMAGE_H);

          if (loading === "Yes") {
            const sk = figma.createRectangle();
            sk.resize(W, IMAGE_H);
            sk.fills = [solid("color/surface-container-high")];
            image.appendChild(sk);
            sk.x = 0;
            sk.y = 0;
          } else {
            const bg = figma.createRectangle();
            bg.resize(W, IMAGE_H);
            bg.fills = [literal(monoBg)];
            image.appendChild(bg);
            bg.x = 0;
            bg.y = 0;

            const initials = await text(monogramInitials(productName), "monogram", null);
            initials.fills = [literal(monoFg)];
            image.appendChild(initials);
            initials.x = W / 2 - initials.width / 2;
            initials.y = 60;

            if (promo === "New") {
              const chip = await pill("NEW", "brand/promotion", literal("#FFFFFF"), null);
              image.appendChild(chip);
              chip.x = 8;
              chip.y = 8;
            }
            if (promo === "Sale") {
              const chip = await pill("SALE", "brand/promotion", literal("#FFFFFF"), null);
              image.appendChild(chip);
              chip.x = 8;
              chip.y = 8;
            }
            if (AVAILABILITY[availability]) {
              const chip = await pill(
                AVAILABILITY[availability],
                "color/error-container",
                solid("color/on-error-container"),
                "error"
              );
              image.appendChild(chip);
              chip.x = W / 2 - chip.width / 2;
              chip.y = IMAGE_H - chip.height - 8;
            }
          }

          const heart = icon(wishlisted === "Yes" ? "favorite" : "favorite_border", wishlisted === "Yes" ? "color/error" : null);
          if (heart) {
            image.appendChild(heart);
            if (wishlisted !== "Yes") heart.fills = [literal("#FFFFFF")];
            heart.x = W - 32;
            heart.y = 8;
          }

          // ---- metadata ----
          const meta = figma.createFrame();
          meta.fills = [];
          autolayout(meta, { dir: "VERTICAL", gap: 2, pad: [10, 10, 10, 10] });
          c.appendChild(meta);
          meta.layoutSizingHorizontal = "FILL";

          if (loading === "Yes") {
            meta.appendChild(rect(90, 10, "color/surface-container-high", 6));
            meta.appendChild(rect(130, 12, "color/surface-container-high", 6));
            meta.appendChild(rect(60, 12, "color/surface-container-high", 6));
          } else {
            meta.appendChild(await text("Kirirom", "labelSmall", "color/on-surface-variant"));
            meta.appendChild(await text(productName, "titleSmall", "color/on-surface"));

            const rating = await text("★ 4.6 (24)", "labelSmall", "color/on-surface-variant");
            meta.appendChild(rating);

            if (promo === "Sale") {
              const priceRow = figma.createFrame();
              priceRow.fills = [];
              autolayout(priceRow, { dir: "HORIZONTAL", gap: 4, cross: "CENTER" });
              meta.appendChild(priceRow);
              const now = await text("$18.00", "titleSmall", "color/on-surface");
              now.fontSize = 15;
              priceRow.appendChild(now);
              const was = await text("$24.00", "labelSmall", "color/on-surface-variant");
              was.textDecoration = "STRIKETHROUGH";
              priceRow.appendChild(was);
            } else {
              const now = await text("$18.00", "titleSmall", "color/on-surface");
              now.fontSize = 15;
              meta.appendChild(now);
            }
            meta.appendChild(await text("≈ 73,800 KHR", "labelSmall", "color/on-surface-variant"));
          }

          c.counterAxisSizingMode = "FIXED";
          c.primaryAxisSizingMode = "FIXED";
          safeResize(c, W, H);
          variants.push(c);
        }
      }
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "ProductCard";
  grid(set, variants, 6, 24, 24);
  log(`ProductCard: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: disabled cards stay tappable in the app; Loading replaces image and metadata with skeletons");
  return set;
}

async function batchCards(log) {
  const parent = parentFor();
  const built = [];
  clearOrphans(parent);
  for (const [name, fn] of [
    ["KhqrCard", buildKhqrCard],
    ["OrderStatusTimeline", buildOrderStatusTimeline],
    ["OrderTrackingCard", buildOrderTrackingCard],
    ["ProductCard", buildProductCard],
  ]) {
    clearOld(parent, name);
    const set = await fn(parent, log);
    placeBelow(parent, set);
    parent.appendChild(set);
    built.push(set);
  }
  return `P4 cards — ${built.length} sets`;
}

