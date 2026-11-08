// ===== batch: registry =====
// Read-only node-id dump for manifest.json: the three pages, every component set
// (with its variant count), every Screen/* frame and the page-03 anchors. §5 Step 4
// wants real ids pinned at freeze time, and PLAN.md §6 forbids rediscovering nodes
// by screenshot. Changes nothing.

async function batchRegistry(log) {
  await context();

  const pages = figma.root.children.filter((p) => p.type === "PAGE");
  for (const page of pages) {
    log(`page\t${page.name}\t${page.id}`);
  }
  log("");

  for (const page of pages) {
    const sets = page.findAll((n) => n.type === "COMPONENT_SET");
    sets.sort((a, b) => a.name.localeCompare(b.name));
    for (const s of sets) {
      log(`set\t${page.name}\t${s.name}\t${s.id}\t${s.children.length}`);
    }

    const screens = page.findAll((n) => n.type === "FRAME" && n.name.startsWith("Screen/"));
    screens.sort((a, b) => a.name.localeCompare(b.name));
    for (const s of screens) {
      log(`screen\t${page.name}\t${s.name}\t${s.id}`);
    }

    const anchors = page.children.filter(
      (n) =>
        n.type === "FRAME" &&
        (n.name.startsWith("S · ") ||
          n.name.startsWith("Motion · ") ||
          n.name.startsWith("Contracts · ") ||
          n.name === "Brand — Board v1")
    );
    anchors.sort((a, b) => a.name.localeCompare(b.name));
    for (const a of anchors) {
      log(`anchor\t${page.name}\t${a.name}\t${a.id}`);
    }
  }

  const counts = {
    sets: figma.root.children.reduce(
      (n, p) => n + p.findAll((x) => x.type === "COMPONENT_SET").length,
      0
    ),
    screens: figma.root.children.reduce(
      (n, p) => n + p.findAll((x) => x.type === "FRAME" && x.name.startsWith("Screen/")).length,
      0
    ),
  };
  log("");
  log(`${counts.sets} component sets · ${counts.screens} screens across ${pages.length} pages`);
  return `registry — ${counts.sets} sets, ${counts.screens} screens`;
}
