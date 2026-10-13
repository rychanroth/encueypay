import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Order/payment status chip (DESIGN.md §2.2). Keyed by the wire name of
/// `orders.status` / `payments.status` so `core` stays free of feature
/// enums (ARCH-05); unknown names render the neutral slate entry.
///
/// Light mode uses the spec's pastel `50`-level background + solid `700`
/// foreground pairs; dark mode inverts to a translucent foreground tint with
/// a lightened foreground so badges stay legible on obsidian surfaces.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.wireName,
    required this.label,
    this.icon,
    this.dense = false,
  });

  /// DB enum text, e.g. `out_for_delivery` / `refund_required`.
  final String wireName;
  final String label;
  final IconData? icon;

  /// `true` drops the horizontal padding for inline contexts.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final palette =
        statusBadgePalette[wireName] ?? kNeutralBadgeColors;

    final Color background;
    final Color foreground;
    if (isLight) {
      background = palette.background;
      foreground = palette.foreground;
    } else {
      background = Color.alphaBlend(
        palette.foreground.withValues(alpha: 0.18),
        theme.colorScheme.surfaceContainerLowest,
      );
      foreground = Color.lerp(palette.foreground, Colors.white, 0.45)!;
    }

    return Container(
      padding: dense
          ? const EdgeInsets.symmetric(horizontal: AppSpacing.xs + 2, vertical: 2)
          : const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.br8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
