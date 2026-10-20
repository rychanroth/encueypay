import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../domain/entities/order.dart';

/// One purchased line on the order detail screen (Section 7A, §19): the
/// product's current thumbnail, title, variant + unit price × quantity,
/// and the line total — tappable through to the product's detail page
/// (the card navigates by route name; orders never imports catalog,
/// ARCH-04).
class OrderItemCard extends StatelessWidget {
  const OrderItemCard({super.key, required this.item, this.onTap});

  final OrderItemSnapshot item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.br16,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.sm + 2),
            decoration: BoxDecoration(
              borderRadius: AppRadii.br16,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 56,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.variantName == null
                            ? '${Money(item.unitPriceMinor).formatUsd()} × ${item.quantity}'
                            : '${item.variantName} · '
                                '${Money(item.unitPriceMinor).formatUsd()} × ${item.quantity}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Money(item.lineTotalMinor).formatUsd(),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
