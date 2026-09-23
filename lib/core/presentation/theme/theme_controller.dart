import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_controller.g.dart';

/// Single source of truth for theme state (THEME-01). The theme mode is the
/// only sanctioned local persistence in the app (THEME-02, the one exception
/// to CORE-05).
@riverpod
class ThemeController extends _$ThemeController {
  static const _prefsKey = 'app.themeMode';

  @override
  ThemeMode build() => ThemeMode.system;

  /// Called once at startup, before runApp (THEME-04 — no theme flash).
  Future<void> hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = ThemeMode.values.asNameMap()[prefs.getString(_prefsKey)];
    if (mode != null) state = mode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}
