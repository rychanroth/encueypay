import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/active_sale.dart';

String _day(DateTime value) => value.toLocal().toString().substring(0, 10);

/// Bottom sheet describing the live sale behind a product's discount.
///
/// Sales are pricing: they apply automatically and carry no code or minimum
/// spend (ACTION-03). Coupon codes are standalone checkout concepts, so they
/// are intentionally not rendered here.
Future<void> showSaleDetailSheet(BuildContext context, ActiveSale sale) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _SaleDetailSheet(sale: sale),
  );
}

class _SaleDetailSheet extends StatelessWidget {
  const _SaleDetailSheet({required this.sale});

  final ActiveSale sale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = sale.name.isEmpty ? sale.scopeLabel : sale.name;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.promotionCoral.withValues(alpha: 0.12),
                    borderRadius: AppRadii.br12,
                  ),
                  child: const Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.promotionCoral,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleLarge),
                      Text(
                        sale.scopeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (sale.description.isNotEmpty) ...[
              Text(sale.description, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
            ],
            _SaleRow(
              label: 'Discount type',
              value: sale.discountType == CatalogSaleType.percent
                  ? 'Percent off'
                  : 'Fixed amount off',
            ),
            _SaleRow(label: 'Offer', value: sale.offerLabel),
            _SaleRow(
              label: 'Starts',
              value: sale.startsAt == null ? 'Always on' : _day(sale.startsAt!),
            ),
            _SaleRow(
              label: 'Ends',
              value: sale.endsAt == null ? 'No end date' : _day(sale.endsAt!),
            ),
            _SaleRow(label: 'Minimum spend', value: 'None'),
            _SaleRow(label: 'Scope', value: sale.scopeLabel),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: AppRadii.br12,
              ),
              child: Text(
                'This sale price applies automatically. No code or minimum '
                'spend is required.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleRow extends StatelessWidget {
  const _SaleRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 116,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
