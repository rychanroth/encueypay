// ===== batch: s5-wire =====
// The 15 wireframe screens. Data-driven: each entry lists the regions from
// screens.json with a height. Wire screens exist to complete the inventory —
// they are not a promise of visual fidelity (PLAN §3).

const WIRE_SCREENS = [
  {
    id: "reviewCompose", title: "Write a review", section: "customer", back: true,
    blocks: [["Product name + thumbnail", 64], ["5 star buttons 36dp", 56], ["Review text (4 lines)", 120], ["Submit", 48], ["Read-only notice", 44]],
  },
  {
    id: "profileEdit", title: "Edit profile", section: "customer", back: true,
    blocks: [["Full name (required)", 56], ["Phone (optional)", 56], ["Save", 48]],
  },
  {
    id: "addresses", title: "Addresses", section: "customer", back: true,
    blocks: [["Address card · default star, label, recipient, line", 92], ["Address card · set default / delete", 92], ["FAB: Add address", 48], ["Empty state", 120]],
  },
  {
    id: "addressEdit", title: "Add address", section: "customer", back: true,
    blocks: [["Contact name + phone", 56], ["Use my current location", 44], ["Verification map", 140], ["Province / district / commune / village", 56], ["Street / house number", 56], ["Additional details", 56], ["Save", 48]],
  },
  {
    id: "wishlist", title: "Wishlist", section: "customer", back: true,
    blocks: [["ProductCard grid (2 columns)", 260], ["Empty state + Browse products", 140]],
  },
  {
    id: "settings", title: "Settings", section: "customer", back: true,
    blocks: [["Theme", 24], ["System / Light / Dark segmented", 48]],
  },
  {
    id: "notFound", title: "Page not found", section: "customer", back: false,
    blocks: [["Centered message with the attempted path", 140], ["Back action", 48]],
  },

  {
    id: "adminProductForm", title: "Add product", section: "admin", back: true,
    blocks: [["Name", 56], ["Description", 96], ["Variant note", 44], ["Product-wide stock", 56], ["Variants list", 120], ["Category picker", 56], ["Brand picker", 56], ["Images (max 8)", 72], ["Create", 48]],
  },
  {
    id: "adminBrands", title: "Brands", section: "admin", back: true,
    blocks: [["Brand row · logo, name, status, actions", 84], ["Brand row · archived, restore", 84], ["Add brand", 48]],
  },
  {
    id: "adminCategories", title: "Categories", section: "admin", back: true,
    blocks: [["Category row · top level", 76], ["Child category row · indented", 76], ["Grandchild blocked (2 levels max)", 44], ["Create category", 48]],
  },
  {
    id: "adminPromotions", title: "Promotions", section: "admin", back: true,
    blocks: [["Refresh / New sale / New coupon / New banner", 72], ["Sales list · active switch", 120], ["Coupons header + Archived link", 32], ["Coupon tiles", 120], ["Banners list", 120]],
  },
  {
    id: "adminArchivedCoupons", title: "Archived coupons", section: "admin", back: true,
    blocks: [["Explanatory copy", 72], ["Archived coupon tiles (read-only)", 200]],
  },
  {
    id: "adminAudit", title: "Audit logs", section: "admin", back: true,
    blocks: [["Audit row · action, target, timestamp", 64], ["Audit row · action, target, timestamp", 64], ["Audit row · action, target, timestamp", 64], ["Latest 100 entries", 44]],
  },
  {
    id: "adminSettings", title: "Platform settings", section: "admin", back: true,
    blocks: [["Delivery fee", 56], ["Platform commission %", 56], ["Payment account", 56], ["Save", 48]],
  },
  {
    id: "adminOrderDetail", title: "Order #8A11BE20", section: "admin", back: true,
    blocks: [["Summary card", 120], ["Next transition button", 48], ["Cancel order (reason required)", 48], ["Mark cash received", 48], ["Items", 140]],
  },
];

async function buildWireScreen(section, spec) {
  const f = screenFrame(`Screen/${spec.id}/wire`);
  section.appendChild(f);
  const slot = nextSlot(section, 64);
  f.x = slot.x;
  f.y = 80;
  f.fills = [solid("color/surface-container-lowest")];
  f.strokes = [solid("color/outline-variant")];
  f.strokeWeight = 1;

  await appBar(f, spec.title, { back: spec.back });

  const content = figma.createFrame();
  content.fills = [];
  content.clipsContent = true;
  autolayout(content, { dir: "VERTICAL", gap: 12, pad: [16, 16, 16, 16] });
  f.appendChild(content);
  content.x = 0;
  content.y = APPBAR_H;
  fixedWidth(content, SCREEN_W);
  safeResize(content, SCREEN_W, SCREEN_H - APPBAR_H);

  for (const [label, height] of spec.blocks) {
    const block = wireBlock(label, height);
    content.appendChild(block);
    fill(block);

    block.appendChild(await text(label, "labelMedium", "color/on-surface-variant"));

    // Placeholder rules so the region reads as "content lives here".
    const bars = Math.max(0, Math.min(3, Math.floor((height - 48) / 22)));
    for (let i = 0; i < bars; i++) {
      const bar = figma.createRectangle();
      bar.cornerRadius = 4;
      bar.fills = [solid("color/outline-variant")];
      block.appendChild(bar);
      bar.layoutSizingHorizontal = "FILL";
      bar.layoutSizingVertical = "FIXED";
      safeResize(bar, 10, 8);
    }
  }

  return f;
}

async function batchWire(log) {
  const page = await screenContext();
  const customer = sectionFor(page, "S · Customer");
  const admin = sectionFor(page, "S · Admin");

  for (const spec of WIRE_SCREENS) {
    const name = `Screen/${spec.id}/wire`;
    const old = page.findOne((n) => n.name === name);
    if (old) old.remove();
  }

  let count = 0;
  for (const spec of WIRE_SCREENS) {
    await buildWireScreen(spec.section === "admin" ? admin : customer, spec);
    log(`${spec.id} built`);
    count++;
  }
  return `S5 — ${count} wire screens`;
}
