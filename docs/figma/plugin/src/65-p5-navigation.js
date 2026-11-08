// ===== batch: p5-nav =====
// NavigationBar as tab items (Role x State x CartBadge = 8), not whole bars:
// "State" and "CartBadge" are per-tab properties, so a bar is composed from
// item instances in the screen builders. Widths follow the tab counts —
// 390/5 = 78 (customer) and 390/4 = 97 (admin).

async function buildNavigationBar(parent, log) {
  await ensureExtraIcons(log);

  const variants = [];
  const roles = [
    { role: "Customer", glyph: "shopping_cart", label: "Cart", width: 78 },
    { role: "Admin", glyph: "receipt_long", label: "Orders", width: 97 },
  ];
  const states = ["Selected", "Unselected"];
  const badges = ["None", "Count"];
  const GW = 64;
  const GH = 32;

  for (const r of roles) {
    for (const state of states) {
      for (const badge of badges) {
        const c = figma.createComponent();
        c.name = `Role=${r.role}, State=${state}, CartBadge=${badge}`;
        parent.appendChild(c);
        autolayout(c, { dir: "VERTICAL", gap: 4, pad: [8, 0, 0, 0], cross: "CENTER" });
        c.fills = [];

        // indicator pill
        const pill = figma.createFrame();
        pill.fills = state === "Selected" ? [solid("color/primary-container")] : [];
        pill.cornerRadius = 16;
        pill.clipsContent = false;
        safeResize(pill, GW, GH);
        c.appendChild(pill);

        const glyph = icon(
          r.glyph,
          state === "Selected" ? "color/on-primary-container" : "color/on-surface-variant"
        );
        if (glyph) {
          pill.appendChild(glyph);
          glyph.x = (GW - 24) / 2;
          glyph.y = (GH - 24) / 2;
        }

        if (badge === "Count") {
          const b = figma.createFrame();
          b.fills = [solid("color/error")];
          b.cornerRadius = 8;
          b.clipsContent = false;
          autolayout(b, { dir: "VERTICAL", cross: "CENTER" });
          b.primaryAxisAlignItems = "CENTER";
          b.counterAxisAlignItems = "CENTER";
          b.primaryAxisSizingMode = "FIXED";
          b.counterAxisSizingMode = "FIXED";
          safeResize(b, 16, 16);
          pill.appendChild(b);
          b.x = GW - 22;
          b.y = -4;

          const count = await text("3", "labelSmall", null);
          count.fontSize = 9;
          count.fills = [literal("#FFFFFF")];
          b.appendChild(count);
        }

        c.appendChild(
          await text(
            r.label,
            "labelMedium",
            state === "Selected" ? "color/on-surface" : "color/on-surface-variant"
          )
        );

        c.counterAxisSizingMode = "FIXED";
        c.primaryAxisSizingMode = "FIXED";
        safeResize(c, r.width, 72);
        logVariant(c, log);
        variants.push(c);
      }
    }
  }

  const set = figma.combineAsVariants(variants, parent);
  set.name = "NavigationBar";
  grid(set, variants, 4, 24, 24);
  log(`NavigationBar: ${variants.length} variants, ${Math.round(set.width)}x${Math.round(set.height)}`);
  log("note: tab items, not whole bars — compose a bar from instances and pick State=Selected for the active tab");
  return set;
}

async function batchNavigation(log) {
  const parent = parentFor();
  clearOrphans(parent);
  clearOld(parent, "NavigationBar");
  const set = await buildNavigationBar(parent, log);
  placeBelow(parent, set);
  parent.appendChild(set);
  return "P5 nav — 1 set";
}
