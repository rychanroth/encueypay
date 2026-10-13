import 'package:flutter/material.dart';

/// Design tokens — spatial rhythm, radii, elevation (DESIGN.md §4).
///
/// Every layout constant in the app resolves to a named token here; raw
/// numbers in feature code are allowed only for intrinsic icon/image sizes.
abstract final class AppSpacing {
  /// 4dp — badge internal margins, icon–label gap.
  static const double xs = 4;

  /// 8dp — tight item spacing, chip padding, form row spacing.
  static const double sm = 8;

  /// 16dp — standard screen margins, card padding, form field gaps.
  static const double md = 16;

  /// 24dp — section vertical gaps, modal header padding.
  static const double lg = 24;

  /// 32dp — hero section gaps, modal dialog padding.
  static const double xl = 32;

  /// 48dp — top/bottom clearance, empty-state illustration margins.
  static const double xxl = 48;
}

abstract final class AppRadii {
  /// 8dp — buttons, filter chips, status badges.
  static const double r8 = 8;

  /// 12dp — text fields, small cards, notification tiles.
  static const double r12 = 12;

  /// 16dp — product cards, order items, bottom-sheet cards.
  static const double r16 = 16;

  /// 24dp — bottom sheets, modal dialogs, hero containers.
  static const double r24 = 24;

  /// 999dp — avatars, pill tags, quantity steppers.
  static const double full = 999;

  static const BorderRadius br8 = BorderRadius.all(Radius.circular(r8));
  static const BorderRadius br12 = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius br16 = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius br24 = BorderRadius.all(Radius.circular(r24));
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));
}

abstract final class AppElevation {
  /// Navy-tinted shadow ink shared by all levels (§4.3).
  static const Color shadowInk = Color(0x000F172A);

  /// Elevation 1 — card default: `0x080F172A`, blur 8, offset (0, 2).
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x080F172A),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Elevation 2 — floating action dock: `0x120F172A`, blur 16, offset (0, -4).
  static const List<BoxShadow> dock = [
    BoxShadow(
      color: Color(0x120F172A),
      blurRadius: 16,
      offset: Offset(0, -4),
    ),
  ];

  /// Elevation 3 — KHQR modal / bottom sheet: `0x240F172A`, blur 24, offset (0, 8).
  static const List<BoxShadow> sheet = [
    BoxShadow(
      color: Color(0x240F172A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}

abstract final class AppTargets {
  /// Minimum interactive target edge, dp (§1.5 touch ergonomics).
  static const double minimum = 48;
}
