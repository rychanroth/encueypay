import 'package:flutter/material.dart';

import '../../domain/money.dart';
import '../theme/app_typography.dart';
/// Dual-currency price display (DESIGN.md §1.4): USD primary in the
/// tabular-figure price highlight, KHR approximation as the secondary
/// caption pegged at 4,100 KHR/USD. Integer math only — see [Money].
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.money,
    this.showKhr = true,
    this.mainStyle,
    this.secondaryStyle,
    this.alignment = CrossAxisAlignment.start,
  });

  final Money money;
  final bool showKhr;
  final TextStyle? mainStyle;
  final TextStyle? secondaryStyle;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // `priceHighlight` is a named scale step, not a TextTheme slot (§3).
    final main = mainStyle ??
        AppTypography.priceHighlight.copyWith(color: theme.colorScheme.onSurface);
    final secondary = secondaryStyle ??
        theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        Text(money.formatUsd(), style: main),
        if (showKhr) ...[
          const SizedBox(height: 1),
          Text('≈ ${money.formatKhr()}', style: secondary),
        ],
      ],
    );
  }
}
