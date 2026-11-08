#!/usr/bin/env node
/**
 * Assemble the Figma plugin from src/*.js.
 *
 * The Figma plugin runtime needs ONE flat file (no imports; figma-linux's
 * extension loader rejects subfolder paths and dashes), so sources are kept
 * small and concatenated here. This is deliberately not a bundler: no
 * transpile, no module graph — concatenation in filename order.
 *
 *   node docs/figma/plugin/build.js
 */

const fs = require("fs");
const path = require("path");

const here = __dirname;
const srcDir = path.join(here, "src");
const outFile = path.join(here, "code.js");

const files = fs
  .readdirSync(srcDir)
  .filter((f) => f.endsWith(".js"))
  .sort();

if (!files.length) {
  console.error("no sources in", srcDir);
  process.exit(1);
}

const banner = `/**
 * GENERATED FILE — do not edit directly.
 * Sources: docs/figma/plugin/src/*.js (${files.length} files)
 * Rebuild: node docs/figma/plugin/build.js
 */
`;

const body = files
  .map((f) => `// ===== ${f} =====\n${fs.readFileSync(path.join(srcDir, f), "utf8").replace(/\s*$/, "")}\n`)
  .join("\n");

fs.writeFileSync(outFile, banner + "\n" + body);
console.log(`built ${path.relative(process.cwd(), outFile)} from ${files.length} sources (${body.split("\n").length} lines)`);
