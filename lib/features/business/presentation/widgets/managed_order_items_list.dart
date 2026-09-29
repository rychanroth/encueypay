import 'package:flutter/material.dart';

import '../../../../core/domain/money.dart';
import '../../domain/entities/managed_business_order.dart';

/// Order items and totals for a managed business order — one dedicated
/// widget so the detail screen stays declarative.
class ManagedOrderItemsList extends StatelessWidget {
  const ManagedOrderItemsList({super.key, required this.order});

  final ManagedBusinessOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in order.items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (item.variantName != null)
                      Text(item.variantName!, style: theme.textTheme.bodySmall),
                    Text(
                      '${Money(item.lineTotalMinor ~/ item.quantity).format()}'
                      ' × ${item.quantity}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                Money(item.lineTotalMinor).format(),
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 16),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subtotal', style: theme.textTheme.titleSmall),
            Text(
              Money(order.subtotalMinor).format(),
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (order.discountMinor > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount', style: theme.textTheme.bodySmall),
              Text(
                '-${Money(order.discountMinor).format()}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
            ],
          ),
      ],
    );
  }
}
