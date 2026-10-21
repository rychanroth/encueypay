import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/order.dart';
import 'order_status_timeline.dart';

/// §7C tracking presentation for the order detail screen: the requirement's
/// courier details / mock tracking number / ETA / step indicators
/// consolidated into one card. Everything except the status itself is
/// presentation-only mock — no courier entity exists server-side, and the
/// UI never flips states on its own: the admin advances the order and the
/// realtime stream re-renders this card.
class OrderTrackingCard extends StatelessWidget {
  const OrderTrackingCard({super.key, required this.order});

  final CustomerOrder order;

  /// MOCK courier identity (§7C "courier details") — a fixed stand-in,
  /// deliberately non-interactive (no url_launcher dependency for a
  /// decorative link).
  static const _courierLine =
      'EncueYPay Express · Rider Sok Dara · +855 12 345 678';

  /// Still able to move — headline/ETA/courier rows are hidden once the
  /// order is delivered/cancelled/returned (the timeline renders its own
  /// callout for the last two).
  bool get _inFlight =>
      order.status != OrderStatus.delivered &&
      order.status != OrderStatus.cancelled &&
      order.status != OrderStatus.returned;

  /// Friendly demo copy per in-flight status; null for terminal ones where
  /// the timeline (or the delivered all-checks state) speaks for itself.
  String? get _headline => switch (order.status) {
        OrderStatus.pending => "We've received your order",
        OrderStatus.confirmed => 'Order confirmed',
        OrderStatus.processing => 'Preparing your items',
        OrderStatus.packed => 'Packed and ready to ship',
        OrderStatus.shipped => 'Shipped — on its way',
        OrderStatus.outForDelivery => 'Out for delivery — arriving soon',
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final caption = theme.textTheme.bodySmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    return Material(
      color: theme.colorScheme.surfaceContainerLowest,
      borderRadius: AppRadii.br16,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: AppRadii.br16,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_inFlight)
              Text(
                _headline!,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tracking #${order.id.substring(0, 8).toUpperCase()}',
              style: caption,
            ),
            if (_inFlight) ...[
              Text(
                'Estimated delivery '
                '${order.createdAt.toLocal().add(const Duration(days: 3)).toString().substring(0, 10)}',
                style: caption,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: Text(_courierLine, style: caption)),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            OrderStatusTimeline(status: order.status),
          ],
        ),
      ),
    );
  }
}
