import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../domain/entities/cart_item.dart';

/// One cart line, Taobao-style: tick circle, thumbnail, title + variant chip,
/// an availability warning (low stock / sold out), the line price and the
/// stock-capped quantity stepper. Swipe-to-delete is confirmed by the server
/// (PRES-03): the row only leaves the list after the mutation resolves.
class CartLineTile extends StatelessWidget {
  const CartLineTile({
    super.key,
    required this.item,
    required this.selected,
    required this.onToggle,
    required this.onRemove,
    required this.onTap,
    required this.onQuantityChanged,
  });

  final CartItem item;
  final bool selected;
  final VoidCallback onToggle;
  final Future<bool> Function() onRemove;
  final VoidCallback onTap;
  final ValueChanged<int> onQuantityChanged;

  /// Product-wide stock (Section 6) caps the stepper.
  int get _stockCap => item.stock < 0 ? 0 : item.stock;
  bool get _selectable => item.stock > 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey('cart-line-${item.id}'),
      direction: DismissDirection.endToStart,
      // Delete only after the repository confirms; a failure leaves the row
      // in place (the screen surfaces the error via snackbar).
      confirmDismiss: (_) => onRemove(),
      background: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: AppRadii.br16,
        ),
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: AppRadii.br16,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.35)
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: InkWell(
          borderRadius: AppRadii.br16,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SelectionCircle(
                  selected: selected,
                  enabled: _selectable,
                  onTap: onToggle,
                ),
                const SizedBox(width: AppSpacing.xs),
                SizedBox(
                  width: 76,
                  height: 88,
                  child: ClipRRect(
                    borderRadius: AppRadii.br12,
                    child: MonogramImage(
                      imageUrl: item.imageUrl,
                      name: item.productName,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      if (item.variantName != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            borderRadius: AppRadii.br8,
                          ),
                          child: Text(
                            item.variantName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                      if (!_selectable)
                        Text(
                          'Unavailable — remove it to continue',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else if (item.stock <= 5)
                        Text(
                          'Only ${item.stock} left',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.accentAmber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Money(
                                    item.effectiveUnitPriceMinor,
                                  ).formatUsd(),
                                  style: AppTypography.priceHighlight.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                if (item.hasSale)
                                  Text(
                                    Money(item.unitPriceMinor).formatUsd(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          _QuantityStepper(
                            quantity: item.quantity,
                            canDecrease: item.quantity > 1,
                            canIncrease: item.quantity < _stockCap,
                            onChanged: onQuantityChanged,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round tick target (Taobao's radio on each line). Sold-out lines stay
/// unticked and cannot be selected.
class _SelectionCircle extends StatelessWidget {
  const _SelectionCircle({
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = !enabled
        ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
        : selected
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;
    return Semantics(
      selected: selected,
      enabled: enabled,
      label: 'Select item',
      child: InkResponse(
        onTap: enabled ? onTap : null,
        radius: 24,
        child: SizedBox(
          width: 40,
          height: 44,
          child: Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 22,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.canDecrease,
    required this.canIncrease,
    required this.onChanged,
  });

  final int quantity;
  final bool canDecrease;
  final bool canIncrease;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadii.brFull,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            tooltip: 'Decrease quantity',
            onPressed: canDecrease ? () => onChanged(quantity - 1) : null,
          ),
          SizedBox(
            width: 24,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium,
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            tooltip: 'Increase quantity',
            onPressed: canIncrease ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onPressed,
        radius: 18,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(
            icon,
            size: 16,
            color: onPressed == null
                ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
