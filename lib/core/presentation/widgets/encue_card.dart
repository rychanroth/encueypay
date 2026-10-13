import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// Styled card (DESIGN.md §8 `encue_card.dart`): r16 shape, elevation-1
/// shadow token (§4.3), 1dp hairline border, correct surface per brightness.
/// Tap support is optional — untapped cards stay non-interactive.
class EncueCard extends StatelessWidget {
  const EncueCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.elevated = true,
    this.color,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;

  /// `true` applies the elevation-1 shadow (§4.3); `false` keeps the flat
  /// bordered surface (elevation 0).
  final bool elevated;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        color: color ??
            (isLight ? AppColors.surfaceLight : theme.colorScheme.surfaceLow),
        borderRadius: AppRadii.br16,
        border: Border.fromBorderSide(
          BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        boxShadow: elevated && isLight ? AppElevation.card : null,
      ),
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null && onLongPress == null) return surface;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadii.br16,
        onTap: onTap,
        onLongPress: onLongPress,
        child: surface,
      ),
    );
  }
}

extension on ColorScheme {
  /// `surfaceContainerLowest` — the card surface token (white / surfaceDark).
  Color get surfaceLow => surfaceContainerLowest;
}
