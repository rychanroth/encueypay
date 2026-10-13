import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Button system (DESIGN.md §8 `encue_button.dart`): primary, secondary,
/// outline, destructive. The 48dp minimum target and r8 shape come from the
/// component themes (§1.5/§4.2); this widget exists so call sites pick a
/// *variant*, not raw per-widget styling.
enum EncueButtonVariant { primary, secondary, outline, destructive }

class EncueButton extends StatelessWidget {
  const EncueButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = EncueButtonVariant.primary,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final EncueButtonVariant variant;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final ButtonStyle Function() styleFor = switch (variant) {
      // Royal fill — the default CTA.
      EncueButtonVariant.primary => () => FilledButton.styleFrom(),
      // Subtle royal-tinted container.
      EncueButtonVariant.secondary => () => FilledButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
          ),
      // Hairline border, ink label.
      EncueButtonVariant.outline => () => OutlinedButton.styleFrom(),
      // Rose fill — cancel/remove/refund actions.
      EncueButtonVariant.destructive => () => FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
    };

    final Widget child = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(label),
            ],
          );

    final style = styleFor().copyWith(
      minimumSize: const WidgetStatePropertyAll(
        Size(64, AppTargets.minimum),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
      textStyle: const WidgetStatePropertyAll(AppTypography.labelLarge),
    );

    final Widget button = switch (variant) {
      EncueButtonVariant.outline => OutlinedButton(
          style: style,
          onPressed: onPressed,
          child: child,
        ),
      _ => FilledButton(
          style: style,
          onPressed: onPressed,
          child: child,
        ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
