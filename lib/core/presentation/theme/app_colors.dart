import 'package:flutter/material.dart';

/// Design tokens — colors (DESIGN.md §2).
///
/// The single source for every color the app renders with. Screens must read
/// these through the `ColorScheme`/`TextTheme` (THEME-03); direct reads are
/// reserved for the theme builder itself and for surfaces the ColorScheme
/// cannot express (KHQR card chrome, status badge palettes).
abstract final class AppColors {
  // --- Brand primary & shell chrome (§2.1) --------------------------------
  /// Slate 900 — shell headers, major titles.
  static const Color primaryNavy = Color(0xFF0F172A);

  /// Blue 900 — primary CTAs, active states, key accents.
  static const Color primaryRoyal = Color(0xFF1E3A8A);

  /// Blue 700 — hover/pressed; doubles as the dark-mode primary (filled
  /// surfaces carry white labels, so contrast stays accessible).
  static const Color primaryRoyalHover = Color(0xFF1D4ED8);

  /// Blue 50 — subtle selected containers.
  static const Color primarySubtle = Color(0xFFEFF6FF);

  // --- Semantic & financial accents (§2.1) ---------------------------------
  /// Emerald 600 — success, KHQR verified, paid.
  static const Color accentEmerald = Color(0xFF059669);
  static const Color accentEmeraldLight = Color(0xFFECFDF5);

  /// Amber 600 — ratings, pending, warnings.
  static const Color accentAmber = Color(0xFFD97706);
  static const Color accentAmberLight = Color(0xFFFFFBEB);

  /// Rose 600 — out of stock, cancelled, errors.
  static const Color accentRose = Color(0xFFE11D48);
  static const Color accentRoseLight = Color(0xFFFFF1F2);

  /// Deep Orange — promotions, coupons, flash sales.
  static const Color promotionCoral = Color(0xFFFF5722);

  // --- Surfaces & neutrals, light (§2.1) -----------------------------------
  /// Slate 50 — main page background.
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// Pure white — cards, bottom sheets, inputs.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Slate 100 — secondary containers, chips.
  static const Color surfaceContainerLight = Color(0xFFF1F5F9);

  /// Slate 200 — hairline dividers, borders.
  static const Color borderLight = Color(0xFFE2E8F0);

  /// Slate 900 — high-contrast headlines.
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Slate 500 — subtitles, labels, descriptions.
  static const Color textSecondaryLight = Color(0xFF64748B);

  /// Slate 400 — placeholder, inactive text.
  static const Color textMutedLight = Color(0xFF94A3B8);

  // --- Surfaces & neutrals, dark (§2.1) ------------------------------------
  /// Deep obsidian — main page background.
  static const Color backgroundDark = Color(0xFF090D16);

  /// Surface card.
  static const Color surfaceDark = Color(0xFF131B2E);

  /// Slate 800 — secondary containers.
  static const Color surfaceContainerDark = Color(0xFF1E293B);

  /// Subtle borders.
  static const Color borderDark = Color(0xFF27354F);

  /// Crisp white — headlines.
  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  /// Slate 400 — subtitles, labels.
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  /// Slate 500 — placeholder, inactive text.
  static const Color textMutedDark = Color(0xFF64748B);

  // --- Derived dark semantic containers ------------------------------------
  // DESIGN.md specifies light-mode badge/semantic containers only; dark-mode
  // equivalents are derived by blending the accent into the dark surface so
  // hue stays on-system. Precomputed (not Color.lerp) to keep const-ness.
  static const Color _roseOnDark = Color(0xFF331222);
  static const Color _emeraldOnDark = Color(0xFF0E2A20);
  static const Color _amberOnDark = Color(0xFF332510);
  static const Color _blueOnDark = Color(0xFF16223E);

  /// Rose-tinted dark container (errorContainer in dark mode).
  static const Color errorContainerDark = _roseOnDark;
  static const Color onErrorContainerDark = Color(0xFFFDA4AF); // rose 300

  /// Emerald-tinted dark container (success toast / verified states).
  static const Color emeraldContainerDark = _emeraldOnDark;
  static const Color onEmeraldContainerDark = Color(0xFF6EE7B7); // emerald 300

  /// Amber-tinted dark container (pending / warning states).
  static const Color amberContainerDark = _amberOnDark;
  static const Color onAmberContainerDark = Color(0xFFFCD34D); // amber 300

  /// Royal-tinted dark container (selected / confirmed states).
  static const Color royalContainerDark = _blueOnDark;
  static const Color onRoyalContainerDark = Color(0xFF93C5FD); // blue 300

  // --- Cambodia payment standard (§2.1) ------------------------------------
  /// Official NBC Bakong KHQR header red.
  static const Color khqrRed = Color(0xFFD32027);

  /// Official KHQR card body.
  static const Color khqrBg = Color(0xFFFFFFFF);
}

/// One entry of the status-badge palette (DESIGN.md §2.2): pastel background
/// + solid 700-level foreground, keyed by the wire name of
/// `orders.status` / `payments.status`.
typedef StatusBadgeColors = ({Color background, Color foreground});

/// Status → badge palette (§2.2). Keyed by wire name so `core` stays free of
/// feature enums (ARCH-05); unknown names fall back to the neutral slate
/// entry. `pending`, `refund_required` and `refunded` are shared by the
/// order and payment lifecycles per the spec table.
Map<String, StatusBadgeColors> get statusBadgePalette => _statusBadgePalette;

const Map<String, StatusBadgeColors> _statusBadgePalette = {
  'pending': (background: Color(0xFFFFFBEB), foreground: Color(0xFFB45309)), // amber
  'confirmed': (background: Color(0xFFEFF6FF), foreground: Color(0xFF1D4ED8)), // blue
  'processing': (background: Color(0xFFEEF2FF), foreground: Color(0xFF4338CA)), // indigo
  'packed': (background: Color(0xFFF0F9FF), foreground: Color(0xFF0369A1)), // sky
  'shipped': (background: Color(0xFFECFEFF), foreground: Color(0xFF0E7490)), // cyan
  'out_for_delivery':
      (background: Color(0xFFF0FDFA), foreground: Color(0xFF0F766E)), // teal
  'delivered':
      (background: Color(0xFFECFDF5), foreground: Color(0xFF047857)), // emerald
  'cancelled': (background: Color(0xFFFFF1F2), foreground: Color(0xFFBE123C)), // rose
  'returned': (background: Color(0xFFFAF5FF), foreground: Color(0xFF7E22CE)), // purple
  'refund_required':
      (background: Color(0xFFFFF1F2), foreground: Color(0xFFBE123C)), // rose
  'refunded': (background: Color(0xFFF1F5F9), foreground: Color(0xFF334155)), // slate
};

/// Neutral fallback for wire names missing from the palette.
const StatusBadgeColors kNeutralBadgeColors =
    (background: Color(0xFFF1F5F9), foreground: Color(0xFF334155));

/// Payment-method → accent (§5.2 gateway distribution, §6.3 step 4).
const Color kCodAccent = Color(0xFF0F766E); // teal 700 — cash handling
const Color kKhqrAccent = Color(0xFFD32027); // KHQR red
