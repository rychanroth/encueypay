// ===== runner + UI =====

const BATCHES = {
  "flows-a": batchFlowsA,
  "flows-b": batchFlowsB,
  "flows-c": batchFlowsC,
  reset: batchReset,
  inspect: batchInspectBoard,
};

/**
 * Read-only: what the page actually holds. One line per top-level node with its type,
 * size and child count — the answer to "is each diagram really a group?".
 */
async function batchInspectBoard(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  const page = figma.currentPage;
  const nodes = page.children.slice();
  const counts = {};
  nodes.forEach((n) => {
    counts[n.type] = (counts[n.type] || 0) + 1;
  });

  nodes
    .sort((a, b) => a.y - b.y || a.x - b.x)
    .forEach((n) => {
      const kids = n.children ? n.children.length : 0;
      log(
        [
          n.type,
          n.name || "(unnamed)",
          `${Math.round(n.width)}x${Math.round(n.height)}`,
          `children ${kids}`,
          `at ${Math.round(n.x)},${Math.round(n.y)}`,
        ].join("\t")
      );
    });

  log("");
  log(
    `${nodes.length} top-level nodes · ` +
      Object.keys(counts)
        .sort()
        .map((k) => `${counts[k]} ${k}`)
        .join(" · ")
  );
  return `inspect — ${nodes.length} top-level nodes`;
}

/**
 * Clear the board. The board is generated end to end by this plugin, so there is
 * nothing to preserve; needed once to drop the pre-grouping diagrams, whose children
 * are page-level and unnamed (fjClear can only sweep them by position).
 */
async function batchReset(log) {
  if (figma.editorType !== "figjam") {
    throw new Error("Open the FigJam board (EncueYPay — Flows & Data) and run this there.");
  }
  const page = figma.currentPage;
  const start = page.children.length;
  let total = 0;
  // Removal cascades (shapes take their connectors), so sweep passes until empty
  // instead of walking one stale snapshot.
  for (let pass = 0; pass < 20 && page.children.length; pass++) {
    total += fjRemove(page.children.slice());
  }
  log(`cleared ${total} of ${start} top-level nodes${page.children.length ? `, ${page.children.length} left` : ""}`);
  return `reset — ${total} nodes removed`;
}

const HTML = `
<!doctype html>
<html>
<head>
<style>
  body { margin: 0; font: 11px/1.5 -apple-system, "Segoe UI", system-ui, sans-serif;
         background: #1e1e1e; color: #e6e6e6; }
  .bar { display: flex; flex-wrap: wrap; gap: 6px; padding: 10px; background: #2c2c2c;
         border-bottom: 1px solid #3d3d3d; }
  button { font: inherit; padding: 5px 9px; border-radius: 6px; cursor: pointer;
           border: 1px solid #4a4a4a; background: #383838; color: #e6e6e6; }
  button:hover:not(:disabled) { background: #454545; }
  button:disabled { opacity: .45; cursor: default; }
  textarea { width: 100%; height: 260px; box-sizing: border-box; border: 0;
             background: #1e1e1e; color: #cfd8e3; font: 11px/1.45 ui-monospace, Menlo, monospace;
             padding: 10px; resize: none; outline: none; }
</style>
</head>
<body>
  <div class="bar">
    <button data-batch="flows-a">Flows A · nav + lifecycles</button>
    <button data-batch="flows-b">Flows B · sequences</button>
    <button data-batch="flows-c">Flows C · data + permissions</button>
    <button data-batch="reset">Reset · clear board</button>
    <button data-batch="inspect">Inspect · board</button>
    <button id="copy">Copy log</button>
  </div>
  <textarea id="log" readonly placeholder="Run a batch to see its report."></textarea>
<script>
  var logEl = document.getElementById("log");
  var buttons = Array.prototype.slice.call(document.querySelectorAll("button"));

  function setBusy(busy) { buttons.forEach(function (b) { b.disabled = busy; }); }

  buttons.forEach(function (b) {
    b.onclick = function () {
      var batch = b.getAttribute("data-batch");
      if (!batch) return;
      setBusy(true);
      parent.postMessage({ pluginMessage: { type: "run", batch: batch } }, "*");
    };
  });

  document.getElementById("copy").onclick = function () {
    logEl.select();
    try { document.execCommand("copy"); } catch (e) {}
    if (navigator.clipboard) navigator.clipboard.writeText(logEl.value);
  };

  window.onmessage = function (event) {
    var m = event.data && event.data.pluginMessage;
    if (!m) return;
    if (m.type === "log") {
      logEl.value += m.text + "\\n";
      logEl.scrollTop = logEl.scrollHeight;
    }
    if (m.type === "start" && logEl.value) logEl.value += "\\n";
    if (m.type === "done") setBusy(false);
  };
</script>
</body>
</html>
`;

async function run(batch) {
  const fn = BATCHES[batch];
  const log = (s) => figma.ui.postMessage({ type: "log", text: String(s) });
  if (!fn) {
    log(`unknown batch: ${batch}`);
    figma.ui.postMessage({ type: "done" });
    return;
  }

  figma.ui.postMessage({ type: "start", batch });
  log(`=== ${batch} ===`);
  try {
    const summary = await fn(log);
    if (WARNINGS.length) {
      log(`warnings (${WARNINGS.length}):`);
      WARNINGS.forEach((w) => log("  ! " + w));
    }
    log(`done: ${summary}`);
    figma.notify(summary, { timeout: 8000 });
  } catch (err) {
    const message = (err && err.message) || String(err);
    log(`FAILED: ${message}`);
    figma.notify(`Build failed: ${message}`, { error: true, timeout: 15000 });
  }
  figma.ui.postMessage({ type: "done" });
}

figma.showUI(HTML, { width: 460, height: 380, themeColors: true });
figma.ui.onmessage = async (msg) => {
  if (msg && msg.type === "run") await run(msg.batch);
};
