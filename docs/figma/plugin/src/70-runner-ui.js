// ---------------------------------------------------------------------------
// runner
// ---------------------------------------------------------------------------

const BATCHES = {
  inspect: batchInspect,
  "p2a-fix": batchIconFix,
  "p2b-overlays": batchOverlays,
  "p3-atoms": batchAtoms,
  "p4-cards": batchCards,
};

async function run(batch) {
  const fn = BATCHES[batch];
  const log = (s) => figma.ui.postMessage({ type: "log", text: String(s) });
  if (!fn) {
    log(`unknown batch: ${batch}`);
    return;
  }
  log(`=== ${batch} ===`);
  figma.ui.postMessage({ type: "start", batch });
  try {
    await context();
    const summary = await fn(log);
    if (CTX.warnings.length) {
      log(`warnings (${CTX.warnings.length}):`);
      CTX.warnings.forEach((w) => log("  ! " + w));
    }
    log(`done: ${summary}`);
    figma.notify(summary, { timeout: 8000 });
  } catch (err) {
    const message = (err && err.message) || String(err);
    log(`FAILED: ${message}`);
    if (err && err.stack) log(err.stack);
    figma.notify(`Build failed: ${message}`, { error: true, timeout: 15000 });
  }
  figma.ui.postMessage({ type: "done" });
}

// ---------------------------------------------------------------------------
// ui
// ---------------------------------------------------------------------------

const HTML = `
<!doctype html>
<html>
<head>
<style>
  body { margin: 0; font: 11px/1.5 -apple-system, "Segoe UI", system-ui, sans-serif;
         background: #1e1e1e; color: #e6e6e6; }
  .bar { display: flex; flex-wrap: wrap; gap: 6px; padding: 10px; background: #2c2c2c;
         border-bottom: 1px solid #3d3d3d; position: sticky; top: 0; }
  button { font: inherit; padding: 5px 9px; border-radius: 6px; cursor: pointer;
           border: 1px solid #4a4a4a; background: #383838; color: #e6e6e6; }
  button:hover:not(:disabled) { background: #454545; }
  button:disabled { opacity: .45; cursor: default; }
  textarea { width: 100%; height: 300px; box-sizing: border-box; border: 0;
             background: #1e1e1e; color: #cfd8e3; font: 11px/1.45 ui-monospace, Menlo, monospace;
             padding: 10px; resize: none; outline: none; }
</style>
</head>
<body>
  <div class="bar">
    <button data-batch="inspect">Inspect</button>
    <button data-batch="p2a-fix">P2a · icons</button>
    <button data-batch="p2b-overlays">P2b · overlays</button>
    <button data-batch="p3-atoms">P3 · atoms</button>
    <button data-batch="p4-cards">P4 · cards</button>
    <button id="copy">Copy log</button>
  </div>
  <textarea id="log" readonly placeholder="Run a batch to see its report."></textarea>
<script>
  var logEl = document.getElementById("log");
  var buttons = Array.prototype.slice.call(document.querySelectorAll("button"));

  function setBusy(busy) {
    buttons.forEach(function (b) { b.disabled = busy; });
  }

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
    if (m.type === "start") {
      if (logEl.value) logEl.value += "\\n";
    }
    if (m.type === "done") setBusy(false);
  };
</script>
</body>
</html>
`;

figma.showUI(HTML, { width: 520, height: 420, themeColors: true });

figma.ui.onmessage = async (msg) => {
  if (msg && msg.type === "run") await run(msg.batch);
};
