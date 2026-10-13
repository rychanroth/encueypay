import 'package:flutter/material.dart';

/// Design tokens — typography (DESIGN.md §3). Plus Jakarta Sans, bundled as
/// static instances in `pubspec.yaml` (deterministic offline rendering).
abstract final class AppTypography {
  static const String fontFamily = 'Plus Jakarta Sans';

  /// 32 / w800 / -0.8 / 1.2 — hero numerals & splash headlines.
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.2,
  );

  /// 24 / w700 / -0.5 / 1.25 — screen headlines.
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.25,
  );

  /// 20 / w600 / -0.3 / 1.3 — section titles.
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  /// 16 / w600 / -0.2 / 1.35 — card titles, list item titles.
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.35,
  );

  /// 16 / w400 / 0 / 1.5 — lead paragraphs.
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );

  /// 14 / w400 / 0 / 1.45 — default copy.
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.45,
  );

  /// 14 / w600 / 0.1 / 1.2 — buttons & prominent labels.
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );

  /// 11 / w600 / 0.2 / 1.2 — badges, chips, captions.
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.2,
  );

  /// 18 / w700 / tabular figures / -0.4 — prices (exact minor-unit copy,
  /// spec §1.4: tabular figures keep aligned columns free of drift jitter).
  static const TextStyle priceHighlight = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: -0.4,
  );

  // --- Interpolated slots (not named in §3 but consumed by M3 components) ---
  // Derived by holding the nearest named scale step's rhythm so the whole
  // TextTheme stays on-system.

  /// 22 / w700 / -0.4 — AppBar titles, dialog headlines.
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.25,
  );

  /// 14 / w600 / -0.1 — dense card titles, list trailing values.
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.3,
  );

  /// 12 / w400 / 0 / 1.4 — supporting copy.
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  /// 12 / w600 / 0.15 — secondary badges, tab labels.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.2,
  );

  /// Material 3 `TextTheme` mapping. [brightness] picks ink colors; the
  /// geometry is identical for light and dark.
  static TextTheme textTheme(Brightness brightness) {
    final Color primary;
    final Color secondary;
    switch (brightness) {
      case Brightness.light:
        primary = const Color(0xFF0F172A); // textPrimaryLight
        secondary = const Color(0xFF64748B); // textSecondaryLight
      case Brightness.dark:
        primary = const Color(0xFFF8FAFC); // textPrimaryDark
        secondary = const Color(0xFF94A3B8); // textSecondaryDark
    }
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: primary),
      displayMedium: displayLarge.copyWith(fontSize: 28, color: primary),
      displaySmall: displayLarge.copyWith(fontSize: 26, color: primary),
      headlineLarge: headlineMedium.copyWith(fontSize: 28, color: primary),
      headlineMedium: headlineMedium.copyWith(color: primary),
      headlineSmall: headlineSmall.copyWith(color: primary),
      titleLarge: titleLarge.copyWith(color: primary),
      titleMedium: titleMedium.copyWith(color: primary),
      titleSmall: titleSmall.copyWith(color: primary),
      bodyLarge: bodyLarge.copyWith(color: primary),
      bodyMedium: bodyMedium.copyWith(color: primary),
      bodySmall: bodySmall.copyWith(color: secondary),
      labelLarge: labelLarge.copyWith(color: primary),
      labelMedium: labelMedium.copyWith(color: secondary),
      labelSmall: labelSmall.copyWith(color: secondary),
    );
  }
}
