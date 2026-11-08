// ---------------------------------------------------------------------------
// batch: p2b-overlays
// ---------------------------------------------------------------------------

const RADIUS = {
  r8: ["radius/r8", "radius/8", "Radius/r8", "r8"],
  r12: ["radius/r12", "radius/12", "Radius/r12", "r12"],
  r16: ["radius/r16", "radius/16", "Radius/r16", "r16"],
  r24: ["radius/r24", "radius/24", "Radius/r24", "r24"],
  full: ["radius/full", "Radius/full", "full"],
};
const SPACE = {
  xs: ["space/xs", "spacing/xs", "Space/xs"],
  sm: ["space/sm", "spacing/sm", "Space/sm"],
  md: ["space/md", "spacing/md", "Space/md"],
  lg: ["space/lg", "spacing/lg", "Space/lg"],
  xl: ["space/xl", "spacing/xl", "Space/xl"],
  xxl: ["space/xxl", "spacing/xxl", "Space/xxl"],
};

async function buildSnackbar(parent, log) {
  const variants = [];
  const tones = [
    { tone: "Info", copy: "Changes saved", iconName: "check_circle", action: null },
    { tone: "Error", copy: "Could not reach the server", iconName: "error", action: null },
    { tone: "Action", copy: "Item removed from cart", iconName: null, action: "Undo" },
  ];

  for (const t of tones) {
    const c = figma.createComponent();
    c.name = "Tone=" + t.tone;
    parent.appendChild(c);

    autolayout(c, { dir: "HORIZONTAL", gap: 12, pad: [16, 16, 16, 16], cross: "CENTER" });
    bindSpace(c, ["top", "right", "bottom", "left"], SPACE.md);
    c.primaryAxisAlignItems = "SPACE_BETWEEN";
    c.cornerRadius = 12;
    bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r12));
    c.fills = [solid("color/inverse-surface")];

    if (t.iconName) {
      const i = icon(t.iconName, "color/on-inverse-surface");
      if (i) c.appendChild(i);
    }

    const label = await text(t.copy, "bodyMedium", "color/on-inverse-surface");
    c.appendChild(label);
    try {
      label.layoutGrow = 1;
    } catch (e) {}

    if (t.action) {
      const a = await text(t.action, "labelLarge", "color/inverse-primary");
      c.appendChild(a);
    }

    c.primaryAxisSizingMode = "FIXED";
    safeResize(c, 358, c.height);
    c.counterAxisSizingMode = "AUTO";
    c.minHeight = 56; // text-only tones must match icon tones
    log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "Snackbar";
  grid(set, variants, 3, 24, 24);
  log(`Snackbar: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

async function buildDialog(parent, log) {
  const variants = [];
  const kinds = [
    {
      type: "Default",
      title: "Discard changes?",
      body: "Your edits have not been saved.",
      confirm: "Discard",
      confirmColor: "color/primary",
    },
    {
      type: "DestructiveConfirm",
      title: "Delete this product?",
      body: "Products with orders are archived instead of deleted.",
      confirm: "Delete",
      confirmColor: "color/error",
    },
  ];

  for (const k of kinds) {
    const c = figma.createComponent();
    c.name = "Type=" + k.type;
    parent.appendChild(c);

    autolayout(c, { dir: "VERTICAL", gap: 16, pad: [24, 24, 24, 24] });
    bindSpace(c, ["top", "right", "bottom", "left"], SPACE.lg);
    bindGap(c, SPACE.md);
    c.cornerRadius = 24;
    bindFloat(c, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.r24));
    c.fills = [solid("color/surface-container-lowest")];

    const title = await text(k.title, "titleLarge", "color/on-surface");
    c.appendChild(title);

    const body = await text(k.body, "bodyMedium", "color/on-surface-variant");
    body.textAutoResize = "HEIGHT";
    safeResize(body, 352, body.height);
    c.appendChild(body);

    const actions = figma.createFrame();
    actions.name = "Actions";
    actions.fills = [];
    autolayout(actions, { dir: "HORIZONTAL", gap: 8, cross: "CENTER" });
    bindGap(actions, SPACE.sm);
    actions.primaryAxisAlignItems = "MAX";
    actions.primaryAxisSizingMode = "FIXED";
    actions.counterAxisSizingMode = "AUTO";
    safeResize(actions, 352, 48);
    c.appendChild(actions);

    const cancel = await text("Cancel", "labelLarge", "color/on-surface-variant");
    actions.appendChild(cancel);

    const confirm = await text(k.confirm, "labelLarge", k.confirmColor);
    actions.appendChild(confirm);

    c.counterAxisSizingMode = "FIXED";
    safeResize(c, 400, c.height);
    c.primaryAxisSizingMode = "AUTO";
    log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "Dialog";
  grid(set, variants, 2, 24, 24);
  log(`Dialog: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

async function buildBottomSheet(parent, log) {
  const variants = [];
  const combos = [
    { behavior: "Default", header: "Text" },
    { behavior: "Default", header: "TextAndHandle" },
    { behavior: "ScrollControlled", header: "Text" },
    { behavior: "ScrollControlled", header: "TextAndHandle" },
  ];

  for (const combo of combos) {
    const c = figma.createComponent();
    c.name = `Behavior=${combo.behavior}, Header=${combo.header}`;
    parent.appendChild(c);

    autolayout(c, { dir: "VERTICAL", gap: 16, pad: [24, 16, 24, 16] });
    bindSpace(c, ["top", "bottom"], SPACE.lg);
    bindSpace(c, ["left", "right"], SPACE.md);
    bindGap(c, SPACE.md);
    c.cornerRadius = 24;
    c.topLeftRadius = 24;
    c.topRightRadius = 24;
    c.bottomLeftRadius = 0;
    c.bottomRightRadius = 0;
    bindFloat(c, ["topLeftRadius", "topRightRadius"], float(RADIUS.r24));
    c.fills = [solid("color/surface-container-lowest")];

    if (combo.header === "TextAndHandle") {
      const handle = rect(32, 4, "color/outline-variant", 2);
      bindFloat(handle, ["topLeftRadius", "topRightRadius", "bottomLeftRadius", "bottomRightRadius"], float(RADIUS.full));
      c.appendChild(handle);
    }

    const title = await text("Choose a delivery address", "titleLarge", "color/on-surface");
    c.appendChild(title);

    const body = await text(
      "Saved addresses and a new-address option would be listed here.",
      "bodyMedium",
      "color/on-surface-variant"
    );
    body.textAutoResize = "HEIGHT";
    safeResize(body, 342, body.height);
    c.appendChild(body);

    c.counterAxisSizingMode = "FIXED";
    safeResize(c, 390, c.height);
    if (combo.behavior === "Default") {
      c.primaryAxisSizingMode = "AUTO";
    } else {
      c.primaryAxisSizingMode = "FIXED";
      safeResize(c, 390, 480);
      c.clipsContent = true;
    }
    log(`  ${c.name}: ${Math.round(c.width)}x${Math.round(c.height)}`);
    variants.push(c);
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "BottomSheet";
  grid(set, variants, 2, 32, 32);
  log(`BottomSheet: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  return set;
}

async function batchOverlays(log) {
  const parent = parentFor();
  const built = [];

  clearOrphans(parent);

  for (const [name, fn] of [
    ["Snackbar", buildSnackbar],
    ["Dialog", buildDialog],
    ["BottomSheet", buildBottomSheet],
  ]) {
    clearOld(parent, name);
    const set = await fn(parent, log);
    placeBelow(parent, set);
    built.push(set);
    // keep a readable column: each new set sits under the previous one
    parent.appendChild(set);
  }

  return `P2b overlays — ${built.length} sets`;
}

