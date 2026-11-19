import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/order.dart';
import '../controllers/order_detail_controller.dart';
import 'order_status_timeline.dart';

/// §7C tracking presentation for the order detail screen: the real order
/// id and status timeline consolidated into one card. The customer default
/// is the compact exact track (all seven §7A stages as dots); a toggle
/// reveals the labels and the logged transition times. No courier entity or
/// delivery estimate exists server-side, so neither is fabricated here — the
/// admin advances the order and the realtime stream re-renders this card.
class OrderTrackingCard extends ConsumerStatefulWidget {
  const OrderTrackingCard({super.key, required this.order});

  final CustomerOrder order;

  @override
  ConsumerState<OrderTrackingCard> createState() => _OrderTrackingCardState();
}

class _OrderTrackingCardState extends ConsumerState<OrderTrackingCard> {
  bool _showExactStatus = false;

  CustomerOrder get order => widget.order;

  /// Still able to move — headline/timeline rows are hidden once the order
  /// is delivered/cancelled (the exact timeline renders its own callout).
  bool get _inFlight =>
      order.status != OrderStatus.delivered &&
      order.status != OrderStatus.cancelled;

  /// Friendly demo copy per in-flight status; null for terminal ones where
  /// the timeline (or the delivered all-checks state) speaks for itself.
  String? get _headline {
    final payment = order.payment;
    if (order.status == OrderStatus.pending &&
        payment != null &&
        payment.method == PaymentMethodKind.qr) {
      return payment.status == PaymentStatusState.transactionVerified
          ? 'Payment received'
          : 'Awaiting payment';
    }
    return switch (order.status) {
      OrderStatus.pending => "We've received your order",
      OrderStatus.confirmed => 'Order confirmed',
      OrderStatus.processing => 'Preparing your items',
      OrderStatus.packed => 'Packed and ready to ship',
      OrderStatus.shipped => 'Shipped — on its way',
      OrderStatus.outForDelivery => 'Out for delivery — arriving soon',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = ref
            .watch(orderStatusHistoryControllerProvider(order.id))
            .value ??
        const <OrderStatusEvent>[];
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
              'Order #${order.id.substring(0, 8).toUpperCase()}',
              style: caption,
            ),
            // The exact §7A lifecycle as one row of dots; expanding it adds
            // the selected labels and the server-logged transition times.
            const SizedBox(height: AppSpacing.sm),
            OrderStatusTimeline(
              status: order.status,
              history: history,
              showDetails: _showExactStatus || !_inFlight,
            ),
            if (_inFlight)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () =>
                      setState(() => _showExactStatus = !_showExactStatus),
                  icon: Icon(_showExactStatus
                      ? Icons.unfold_less
                      : Icons.unfold_more),
                  label: Text(_showExactStatus
                      ? 'Hide status details'
                      : 'Show status details'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
