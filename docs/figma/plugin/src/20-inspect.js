// ---------------------------------------------------------------------------
// batch: inspect
// ---------------------------------------------------------------------------

async function batchInspect(log) {
  log(`page: ${CTX.page.name}`);
  log(`-- color variables (${CTX.colors.size}) --`);
  log([...CTX.colors.keys()].sort().join("\n"));

  log(`-- float variables (${CTX.floats.size}) --`);
  if (!CTX.floats.size) {
    log("(none — spacing/radius are literals in this file)");
  } else {
    [...CTX.floats.entries()]
      .sort((a, b) => a[0].localeCompare(b[0]))
      .forEach(([name, v]) => {
        const values = Object.values(v.valuesByMode || {}).join(",");
        const coll = CTX.collectionName.get(v.variableCollectionId) || "?";
        log(`${name}\t${values}\t[${coll}]`);
      });
  }

  log(`-- resolutions P2b needs --`);
  const probes = [
    ...Object.values(RADIUS).map((c) => c[0]),
    ...Object.values(SPACE).map((c) => c[0]),
  ];
  probes.forEach((p) => {
    const hit = float([p]);
    log(`${p}\t${hit ? "FOUND" : "missing"}`);
  });
  if (CTX.resolved.length) log("fuzzy: " + CTX.resolved.join(" | "));

  log(`-- text styles (${CTX.styles.size}) --`);
  log([...CTX.styles.keys()].sort().join("\n"));

  log(`-- ${FAMILY} faces (${CTX.faces.length}) --`);
  log(CTX.faces.map((f) => f.style).sort().join(", ") || "(family not installed)");

  log(`-- top-level nodes on ${PAGE_NAME} --`);
  CTX.page.children.forEach((c) =>
    log(`${c.type}\t${c.name}\t${Math.round(c.x)},${Math.round(c.y)}\t${Math.round(c.width)}x${Math.round(c.height)}`)
  );

  log(`-- component sets --`);
  CTX.page.findAll((n) => n.type === "COMPONENT_SET").forEach((s) => {
    const props = s.variantGroupProperties
      ? Object.keys(s.variantGroupProperties).join(", ")
      : "";
    log(`${s.name}\t${s.children.length} variants\t[${props}]`);
  });

  return "inspect done — copy this log back";
}

