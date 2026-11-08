// ===== batch: audit-screens =====
// Measures every Screen/* frame: does its content fit the 390x844 viewport, or is
// it silently clipped? Read-only — changes nothing.
//
// Why not measure the frame's direct children: the scaffold is app bar (56) + a
// content box pinned to 844 - 56 - 72 = 716 + nav bar (72), so the tallest child
// bottom is 844 on every screen no matter how much content it holds. Overflow
// lives *inside* the pinned boxes and is hidden under the nav bar (appended last,
// opaque) or cut by screenFrame's clipsContent. So measure what each subtree
// needs: auto-layout frames as padded sum + gaps, absolute frames as child bottom.

function requiredHeight(node) {
  const kids = node.children || [];
  const pad = (node.paddingTop || 0) + (node.paddingBottom || 0);
  if (node.layoutMode === "VERTICAL") {
    const gap = (node.itemSpacing || 0) * Math.max(0, kids.length - 1);
    return pad + gap + kids.reduce((s, k) => s + requiredHeight(k), 0);
  }
  if (node.layoutMode === "HORIZONTAL") {
    return pad + kids.reduce((m, k) => Math.max(m, requiredHeight(k)), 0);
  }
  // Absolutely positioned children carry their own y.
  return kids.reduce((m, k) => Math.max(m, k.y + requiredHeight(k)), node.height);
}

function requiredWidth(node) {
  const kids = node.children || [];
  const pad = (node.paddingLeft || 0) + (node.paddingRight || 0);
  if (node.layoutMode === "HORIZONTAL") {
    const gap = (node.itemSpacing || 0) * Math.max(0, kids.length - 1);
    return pad + gap + kids.reduce((s, k) => s + requiredWidth(k), 0);
  }
  if (node.layoutMode === "VERTICAL") {
    return pad + kids.reduce((m, k) => Math.max(m, requiredWidth(k)), 0);
  }
  return kids.reduce((m, k) => Math.max(m, k.x + requiredWidth(k)), node.width);
}

/** The frame that loses the most to its own pinned size, deepest wins on a tie. */
function worstClip(node, acc) {
  const over = requiredHeight(node) - node.height;
  if (over > acc.over) {
    acc.over = over;
    acc.name = `${node.name} ${Math.round(node.width)}x${Math.round(node.height)}`;
    acc.needs = requiredHeight(node);
  }
  (node.children || []).forEach((k) => worstClip(k, acc));
  return acc;
}

async function batchAuditScreens(log) {
  const page = await screenContext();
  const frames = page.findAll((n) => n.type === "FRAME" && n.name.startsWith("Screen/"));
  frames.sort((a, b) => a.name.localeCompare(b.name));

  let clipped = 0;
  let wideCount = 0;

  for (const f of frames) {
    let needs = f.height;
    let wide = 0;
    f.children.forEach((c) => {
      needs = Math.max(needs, c.y + requiredHeight(c));
      wide = Math.max(wide, c.x + requiredWidth(c) - f.width);
    });

    const over = Math.round(needs - f.height);
    if (over > 0) clipped++;
    if (wide > 0) wideCount++;

    const acc = { over: 0, name: "", needs: 0 };
    f.children.forEach((c) => worstClip(c, acc));

    log(
      [
        f.name,
        `${Math.round(f.width)}x${Math.round(f.height)}`,
        `needs ${Math.round(needs)}`,
        over > 0 ? `CLIPPED ${over}px` : "fits",
        wide > 0 ? `wide ${Math.round(wide)}px` : "",
        acc.over > 0 ? `worst ${acc.name} → ${Math.round(acc.needs)}` : "",
      ]
        .filter(Boolean)
        .join("\t")
    );
  }

  log("");
  log(`${frames.length} screens · ${clipped} clipped vertically · ${wideCount} wide`);
  return `audit — ${frames.length} screens, ${clipped} clipped`;
}
