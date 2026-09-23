import 'package:flutter/material.dart';

/// Material 3 window size classes (RESP-02). All width branching goes through
/// `context.screenSize` (RESP-03) — no scattered raw MediaQuery comparisons,
/// no scaling packages (RESP-04).
enum ScreenSize { compact, medium, expanded }

extension ScreenSizeX on BuildContext {
  /// Material 3 window size classes.
  ScreenSize get screenSize {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= 840) return ScreenSize.expanded;
    if (width >= 600) return ScreenSize.medium;
    return ScreenSize.compact;
  }
}
