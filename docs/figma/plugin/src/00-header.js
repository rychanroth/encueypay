/**
 * EncueYPay — Figma mirror builder (local development plugin).
 *
 * Runs the mirror builders through the Plugin API with no MCP metering.
 * Each batch is a function in BATCHES. The plugin shows a tiny UI so several
 * batches can run in one session without re-importing.
 *
 * Batches
 *   inspect      — dump variables, text styles, fonts and page inventory
 *   p2a-fix      — replace font-glyph icons with imported vectors; fix widths
 *   p2b-overlays — Snackbar (3), Dialog (2), BottomSheet (4)
 *
 * Idempotency: a batch deletes the sets it owns before rebuilding them.
 * Source of truth: docs/figma/spec/{tokens,components}.json.
 */

const PAGE_NAME = "01 · Foundations & Components";
const FAMILY = "Plus Jakarta Sans";

/** Typography, copied from docs/figma/spec/tokens.json (figmaName is Type/<name>). */
const TYPE = {
  displayLarge: { size: 32, weight: 800, lh: 38.4, ls: -0.8 },
  headlineMedium: { size: 24, weight: 700, lh: 30, ls: -0.5 },
  headlineSmall: { size: 22, weight: 700, lh: 27.5, ls: -0.4 },
  bodyLarge: { size: 16, weight: 400, lh: 24, ls: 0 },
  titleLarge: { size: 20, weight: 600, lh: 26, ls: -0.3 },
  titleMedium: { size: 16, weight: 600, lh: 21.6, ls: -0.2 },
  bodyMedium: { size: 14, weight: 400, lh: 20.3, ls: 0 },
  bodySmall: { size: 12, weight: 400, lh: 16.8, ls: 0 },
  labelLarge: { size: 14, weight: 600, lh: 16.8, ls: 0.1 },
  labelMedium: { size: 12, weight: 600, lh: 14.4, ls: 0.15 },
  titleSmall: { size: 14, weight: 600, lh: 18.2, ls: -0.1 },
  labelSmall: { size: 11, weight: 600, lh: 13.2, ls: 0.2 },
  priceHighlight: { size: 18, weight: 700, lh: null, ls: -0.4 },
  // Not a style: code does headlineMedium.copyWith(fontSize: 26) for monograms.
  monogram: { size: 26, weight: 700, lh: null, ls: -0.5 },
};

/** Last-resort colors, used only when a variable cannot be resolved. */
const FALLBACK = {
  "color/inverse-surface": "#0F172A",
  "color/on-inverse-surface": "#FFFFFF",
  "color/inverse-primary": "#93C5FD",
  "color/surface-container-lowest": "#FFFFFF",
  "color/on-surface": "#0F172A",
  "color/on-surface-variant": "#64748B",
  "color/primary": "#1E3A8A",
  "color/error": "#E11D48",
  "color/outline-variant": "#E2E8F0",
  "color/surface-container": "#F1F5F9",
  "color/surface-container-high": "#F1F5F9",
  "color/error-container": "#FFF1F2",
  "color/on-error-container": "#BE123C",
  "color/tertiary": "#059669",
  "brand/promotion": "#FF5722",
  "brand/khqr-red": "#D32027",
  "brand/khqr-surface": "#FFFFFF",
};

const WEIGHT_STYLE = { 400: "Regular", 500: "Medium", 600: "SemiBold", 700: "Bold", 800: "ExtraBold" };

