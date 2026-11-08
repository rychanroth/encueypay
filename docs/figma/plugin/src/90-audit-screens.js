// ===== batch: audit-screens =====
// Measures every Screen/* frame: does its content fit the 390x844 viewport, or
// is it silently clipped? Read-only — changes nothing.

async function batchAuditScreens(log) {
  const page = await screenContext();
  const frames = page.findAll((n) => n.type === "FRAME" && n.name.startsWith("Screen/"));
  frames.sort((a, b) => a.name.localeCompare(b.name));

  let clipped = 0;
  let inflated = 0;

  for (const f of frames) {
    let maxBottom = 0;
    let maxRight = 0;
    f.children.forEach((c) => {
      maxBottom = Math.max(maxBottom, c.y + c.height);
      maxRight = Math.max(maxRight, c.x + c.width);
    });

    const over = Math.round(maxBottom - f.height);
    if (over > 0) clipped++;

    // A row that still carries far more height than its content suggests.
    const fatRows = f.findAll(
      (n) =>
        n.type === "FRAME" &&
        n.layoutMode !== "NONE" &&
        n.height > 90 &&
        n.children.length <= 2 &&
        n.children.length > 0
    );
    if (fatRows.length) inflated += fatRows.length;

    log(
      [
        f.name,
        `${Math.round(f.width)}x${Math.round(f.height)}`,
        `content ${Math.round(maxBottom)}`,
        over > 0 ? `CLIPPED ${over}px` : "fits",
        maxRight > f.width ? `wide ${Math.round(maxRight - f.width)}px` : "",
      ]
        .filter(Boolean)
        .join("\t")
    );
  }

  log("");
  log(`${frames.length} screens · ${clipped} clipped · ${inflated} oversized row frames`);

  return `audit — ${frames.length} screens, ${clipped} clipped`;
}
