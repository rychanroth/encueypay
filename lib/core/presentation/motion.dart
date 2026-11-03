import 'package:flutter/material.dart';

/// Shared motion vocabulary (HANDOFF-UX-VISUAL §3): fast, soft, deliberate.
/// Motion explains state changes and always yields to reduced-motion.
abstract final class AppMotion {
  /// 160ms — press/selection feedback.
  static const Duration press = Duration(milliseconds: 160);

  /// 240ms — enter transitions.
  static const Duration enter = Duration(milliseconds: 240);

  /// 200ms — exit transitions.
  static const Duration exit = Duration(milliseconds: 200);

  /// 360ms — staggered grid entrance (one controller per screen).
  static const Duration stagger = Duration(milliseconds: 360);

  static const Curve enterCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve layoutCurve = Curves.easeInOutCubic;

  /// `MediaQuery.disableAnimations` / platform reduced-motion.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  /// Collapses [duration] to zero when reduced motion is requested.
  static Duration duration(BuildContext context, Duration duration) =>
      reduced(context) ? Duration.zero : duration;
}
