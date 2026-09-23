import 'package:flutter/material.dart';

/// Contracted ThemeData location (THEME-03). `MaterialApp` wires
/// `theme:`/`darkTheme:` from here.
abstract final class AppTheme {
  /// Placeholder brand seed — replace when visual design lands.
  static const _seedColor = Color(0xFF00897B);

  static ThemeData get light => _theme(Brightness.light);

  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seedColor,
        brightness: brightness,
      ),
    );
  }
}
