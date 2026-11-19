import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/order.dart';
import '../controllers/order_detail_controller.dart';
import 'order_status_timeline.dart';

/// §7C tracking presentation for the order detail screen: the real order
/// id and status timeline consolidated into one card. The customer default
/// is the simplified four-stage progress (`OrderStatus.label` mapping); a
/// toggle reveals the exact §7A lifecycle. No courier entity or delivery
/// estimate exists server-side, so neither is fabricated here — the admin
/// advances the order and the realtime stream re-renders this card.
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
            if (_inFlight) ...[
              const SizedBox(height: AppSpacing.sm),
              _SimplifiedTimeline(
                currentIndex: _stageIndex,
                labels: order.status == OrderStatus.pending &&
                        order.payment?.method == PaymentMethodKind.qr &&
                        order.payment?.status == PaymentStatusState.pending
                    ? const [
                        'Awaiting payment',
                        'Preparing',
                        'On its way',
                        'Delivered',
                      ]
                    : const ['Placed', 'Preparing', 'On its way', 'Delivered'],
              ),
            ],
            // The exact §7A lifecycle — the reveal target; also the direct
            // presentation for the cancelled callout.
            if (_showExactStatus || !_inFlight) ...[
              const SizedBox(height: AppSpacing.md),
              OrderStatusTimeline(status: order.status, history: history),
            ],
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
                      ? 'Hide exact status'
                      : 'Show exact status'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Index into the simplified stages; only rendered while in flight.
  int get _stageIndex => switch (order.status) {
        OrderStatus.pending => 0,
        OrderStatus.confirmed ||
        OrderStatus.processing ||
        OrderStatus.packed => 1,
        OrderStatus.shipped ||
        OrderStatus.outForDelivery => 2,
        _ => 3,
      };
}

/// Horizontal coarse progress — the simplified customer default. Visual
/// language matches [OrderStatusTimeline]: emerald fill for done stages,
/// primary for the current one, hollow for upcoming.
class _SimplifiedTimeline extends StatelessWidget {
  const _SimplifiedTimeline({required this.labels, required this.currentIndex});

  final List<String> labels;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (i > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i <= currentIndex
                              ? AppColors.accentEmerald
                              : theme.colorScheme.outlineVariant,
                        ),
                      ),
                    _dot(theme, i),
                    if (i < labels.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i < currentIndex
                              ? AppColors.accentEmerald
                              : theme.colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  labels[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: i <= currentIndex
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        i == currentIndex ? FontWeight.w600 : null,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _dot(ThemeData theme, int index) {
    final done = index < currentIndex;
    final current = index == currentIndex;
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done
            ? AppColors.accentEmerald
            : current
                ? theme.colorScheme.primary
                : Colors.transparent,
        border: Border.all(
          width: 2,
          color: done
              ? AppColors.accentEmerald
              : current
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
        ),
      ),
      child: done
          ? const Icon(Icons.check, size: 10, color: Colors.white)
          : current
              ? Container(
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : null,
    );
  }
}
