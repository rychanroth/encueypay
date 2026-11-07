import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../domain/entities/admin.dart';

/// Structured order line for the admin fulfillment view (Section 3). Mirrors
/// the customer OrderItemCard's information hierarchy without importing the
/// orders feature (ARCH-04): thumbnail, product name, variant, explicit
/// quantity × unit price, item discount, and line total.
class AdminOrderItemCard extends StatelessWidget {
  const AdminOrderItemCard({super.key, required this.item});

  final AdminOrderItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unitPrice = item.unitPriceMinor;
    final discount = item.discountMinor ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: AppRadii.br16,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 64,
              height: 64,
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
                  if (item.variantName != null &&
                      item.variantName!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: AppRadii.br12,
                      ),
                      child: Text(
                        item.variantName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    unitPrice == null
                        ? 'Qty ${item.quantity}'
                        : 'Qty ${item.quantity} × '
                            '${Money(unitPrice).formatUsd()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (discount > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Item discount −${Money(discount).formatUsd()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              Money(item.lineTotalMinor).formatUsd(),
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
