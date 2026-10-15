import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

/// Contracted ThemeData location (THEME-03). `MaterialApp` wires
/// `theme:`/`darkTheme:` from here.
///
/// Built from the DESIGN.md token files ([AppColors], [AppTypography],
/// [AppSpacing]/[AppRadii]/[AppElevation]) — an explicit `ColorScheme` per
/// brightness (no seed derivation) so light and dark render deterministically
/// from the same palette. Component themes apply the shape/typography system
/// globally; feature widgets restyle through tokens, not overrides.
abstract final class AppTheme {
  static ThemeData get light => _theme(Brightness.light);

  static ThemeData get dark => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final colorScheme = isLight ? _lightScheme : _darkScheme;
    final textTheme = AppTypography.textTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      splashFactory: InkSparkle.splashFactory,
      // --- App bar ---------------------------------------------------------
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      // --- Buttons (r8, 48dp targets, labelLarge — §4.2/§1.5) --------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, AppTargets.minimum),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.br8),
          textStyle: AppTypography.labelLarge,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, AppTargets.minimum),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.br8),
          textStyle: AppTypography.labelLarge,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, AppTargets.minimum),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.br8),
          side: BorderSide(color: colorScheme.onSurfaceVariant),
          foregroundColor: colorScheme.onSurface,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTypography.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.br8),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(AppTargets.minimum, AppTargets.minimum),
          foregroundColor: colorScheme.onSurfaceVariant,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.br16),
        elevation: 0,
      ),
      // --- Inputs (r12 — §4.2) ----------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.br12,
          borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.br12,
          borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.br12,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.br12,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadii.br12,
          borderSide: BorderSide(color: colorScheme.error, width: 1.6),
        ),
      ),
      // --- Cards (r16, flat + hairline border by default — §4.3) -----------
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.br16,
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      ),
      // --- Sheets & dialogs (r24 — §4.2) -----------------------------------
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.r24)),
        ),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.br24),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurface,
        ),
        barrierColor: const Color(0x660F172A),
      ),
      // --- Navigation -------------------------------------------------------
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: isLight
            ? AppColors.primarySubtle
            : AppColors.royalContainerDark,
        labelTextStyle: WidgetStatePropertyAll(
          AppTypography.labelMedium.copyWith(color: colorScheme.onSurface),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.br8),
        side: BorderSide(color: colorScheme.onSurfaceVariant),
        backgroundColor: colorScheme.surfaceContainerLowest,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? AppColors.primaryNavy : AppColors.surfaceContainerDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: isLight ? AppColors.surfaceLight : AppColors.textPrimaryDark,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.br12),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
      ),
      radioTheme: RadioThemeData(fillColor: WidgetStatePropertyAll(colorScheme.primary)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.error,
        textColor: colorScheme.onError,
        textStyle: AppTypography.labelSmall,
      ),
    );
  }

  // --- Light scheme (§2.1 light tokens) ------------------------------------
  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryRoyal,
    onPrimary: AppColors.surfaceLight,
    primaryContainer: AppColors.primarySubtle,
    onPrimaryContainer: AppColors.primaryRoyal,
    secondary: AppColors.primaryNavy,
    onSecondary: AppColors.surfaceLight,
    secondaryContainer: AppColors.surfaceContainerLight,
    onSecondaryContainer: AppColors.textPrimaryLight,
    tertiary: AppColors.accentEmerald,
    onTertiary: AppColors.surfaceLight,
    tertiaryContainer: AppColors.accentEmeraldLight,
    onTertiaryContainer: Color(0xFF047857), // emerald 700
    error: AppColors.accentRose,
    onError: AppColors.surfaceLight,
    errorContainer: AppColors.accentRoseLight,
    onErrorContainer: Color(0xFFBE123C), // rose 700
    surface: AppColors.backgroundLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerLowest: AppColors.surfaceLight,
    surfaceContainerLow: AppColors.backgroundLight,
    surfaceContainer: AppColors.surfaceContainerLight,
    surfaceContainerHigh: AppColors.surfaceContainerLight,
    surfaceContainerHighest: AppColors.borderLight,
    onSurfaceVariant: AppColors.textSecondaryLight,
    outline: AppColors.borderLight,
    outlineVariant: AppColors.borderLight,
    shadow: AppColors.primaryNavy,
    scrim: AppColors.primaryNavy,
    inverseSurface: AppColors.primaryNavy,
    onInverseSurface: AppColors.surfaceLight,
    inversePrimary: Color(0xFF93C5FD), // blue 300
  );

  // --- Dark scheme (§2.1 dark tokens; primary lifts to RoyalHover for
  //     accessible filled CTAs — white labels keep 4.5:1 on it) --------------
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryRoyalHover,
    onPrimary: AppColors.surfaceLight,
    primaryContainer: AppColors.royalContainerDark,
    onPrimaryContainer: AppColors.onRoyalContainerDark,
    secondary: AppColors.textPrimaryDark,
    onSecondary: AppColors.backgroundDark,
    secondaryContainer: AppColors.surfaceContainerDark,
    onSecondaryContainer: AppColors.textPrimaryDark,
    tertiary: Color(0xFF34D399), // emerald 400 — legible success on obsidian
    onTertiary: AppColors.backgroundDark,
    tertiaryContainer: AppColors.emeraldContainerDark,
    onTertiaryContainer: AppColors.onEmeraldContainerDark,
    error: Color(0xFFFB7185), // rose 400 — legible error on obsidian
    onError: AppColors.backgroundDark,
    errorContainer: AppColors.errorContainerDark,
    onErrorContainer: AppColors.onErrorContainerDark,
    surface: AppColors.backgroundDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerLowest: AppColors.surfaceDark,
    surfaceContainerLow: AppColors.surfaceDark,
    surfaceContainer: AppColors.surfaceContainerDark,
    surfaceContainerHigh: AppColors.surfaceContainerDark,
    surfaceContainerHighest: AppColors.borderDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    outline: AppColors.borderDark,
    outlineVariant: AppColors.borderDark,
    shadow: AppColors.backgroundDark,
    scrim: AppColors.backgroundDark,
    inverseSurface: AppColors.textPrimaryDark,
    onInverseSurface: AppColors.backgroundDark,
    inversePrimary: AppColors.primaryRoyal,
  );
}
