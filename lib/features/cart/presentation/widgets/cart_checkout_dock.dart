import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/motion.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';

/// Floating Action Dock (DESIGN.md §6.5) with the Taobao select-all rail:
/// blurred glass, elevation shadow, the tick-all target, the payable total
/// (dual currency, selected lines only) and the one-tap checkout entry.
class CartCheckoutDock extends StatelessWidget {
  const CartCheckoutDock({
    super.key,
    required this.payableMinor,
    required this.selectedCount,
    required this.allSelected,
    required this.onToggleAll,
    required this.onCheckout,
  });

  final int payableMinor;
  final int selectedCount;
  final bool allSelected;
  final VoidCallback onToggleAll;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = Money(payableMinor);
    final canCheckout = selectedCount > 0;

    return ClipRRect(
      borderRadius: AppRadii.br24,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.82),
            borderRadius: AppRadii.br24,
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: AppElevation.dock,
          ),
          child: Row(
            children: [
              Semantics(
                label: 'Select all items',
                checked: allSelected,
                child: InkResponse(
                  onTap: onToggleAll,
                  radius: 28,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          allSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 22,
                          color: theme.colorScheme.primary,
                        ),
                        Text('All', style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCount == 0
                          ? 'Select items to checkout'
                          : '$selectedCount selected',
                      style: theme.textTheme.labelSmall,
                    ),
                    AnimatedSwitcher(
                      duration: AppMotion.duration(context, AppMotion.press),
                      switchInCurve: AppMotion.enterCurve,
                      switchOutCurve: AppMotion.exitCurve,
                      child: Text(
                        money.formatUsd(),
                        key: ValueKey(payableMinor),
                        style: AppTypography.priceHighlight.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      '≈ ${money.formatKhr()}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: canCheckout ? onCheckout : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 14,
                  ),
                ),
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
