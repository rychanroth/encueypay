import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_orders_controller.dart';
import '../widgets/admin_lifecycle_chip.dart';
import '../widgets/admin_order_item_card.dart';

/// Fulfillment view for one order (Section 3): the one-step lifecycle
/// transitions, cancellation with reason, and the payment summary. The
/// order is looked up from the shared controller state so mutations
/// refresh the view in place.
class AdminOrderDetailScreen extends ConsumerWidget {
  const AdminOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailProvider = adminOrderDetailControllerProvider(orderId);
    final orderAsync = ref.watch(detailProvider);
    final loadedOrder = orderAsync.value;
    final theme = Theme.of(context);

    ref.listen(detailProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar(content: Text(userMessageFor(error))));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedOrder == null ? 'Order' : 'Order #${_shortId(loadedOrder.id)}',
        ),
      ),
      body: orderAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(userMessageFor(error))),
        data: (order) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SummaryCard(order: order),
              const SizedBox(height: 16),
              // Section 7A: one-step lifecycle transition. Pending/confirmed
              // orders can instead be cancelled with a reason (rejection
              // equivalent).
              if (order.nextTransition != null)
                FilledButton(
                  onPressed: () => ref
                      .read(detailProvider.notifier)
                      .transition(status: order.nextTransition!.wireName),
                  child: Text(
                      'Move to ${order.nextTransition!.wireName.replaceAll('_', ' ')}'),
                ),
              if (order.cancellable)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    onPressed: () => _cancel(context, ref, order.id),
                    child: const Text('Cancel order'),
                  ),
                ),
              if (order.canMarkCodPaid)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FilledButton.icon(
                    onPressed: () => _markCodPaid(context, ref, order.id),
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Mark cash payment received'),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Items',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              for (final item in order.items)
                AdminOrderItemCard(item: item),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.order});

  final AdminOrderSummary order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(order.customerName,
                      style: theme.textTheme.titleMedium),
                ),
                const SizedBox(width: AppSpacing.sm),
                AdminLifecycleChip(
                  wireName: order.status.wireName,
                  label: _statusLabel(order.status.wireName),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Order #${_shortId(order.id)} · ${_timestamp(order.createdAt)}',
              style: theme.textTheme.bodySmall,
            ),
            if (order.deliveredAt != null)
              Text(
                'Delivered at ${_timestamp(order.deliveredAt!)}',
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(height: 8),
            _Row('Subtotal', Money(order.subtotalMinor).format()),
            _Row('Discount', '-${Money(order.discountMinor).format()}'),
            _Row('Delivery fee', Money(order.deliveryFeeMinor).format()),
            const Divider(),
            _Row('Total', Money(order.totalMinor).format(), bold: true),
            if (order.paymentMethod != null)
              _Row('Payment', '${order.paymentMethod} · ${order.paymentStatus}'),
            if (order.shippingLine1.isNotEmpty ||
                order.shippingCity.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Deliver to', style: theme.textTheme.labelMedium),
              const SizedBox(height: 2),
              Text(
                [
                  order.shippingRecipientName,
                  order.shippingPhone,
                  [
                    order.shippingLine1,
                    order.shippingLine2 ?? '',
                    order.shippingCity,
                  ].where((part) => part.isNotEmpty).join(', '),
                ].where((part) => part.isNotEmpty).join('\n'),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: bold ? FontWeight.bold : null,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

String _shortId(String id) => id.length <= 8 ? id : id.substring(0, 8);

String _statusLabel(String wireName) {
  final words = wireName.replaceAll('_', ' ');
  return words.isEmpty
      ? words
      : '${words[0].toUpperCase()}${words.substring(1)}';
}

String _timestamp(DateTime value) =>
    value.toLocal().toString().split('.').first;

Future<void> _markCodPaid(
  BuildContext context,
  WidgetRef ref,
  String orderId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Mark cash payment received?'),
      content: const Text(
        'This records the cash payment for this delivered order.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Mark paid'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await ref
      .read(adminOrderDetailControllerProvider(orderId).notifier)
      .markCodPaid();
}

Future<void> _cancel(
  BuildContext context,
  WidgetRef ref,
  String orderId,
) async {
  final reasonController = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Cancel order?'),
      content: TextField(
        controller: reasonController,
        decoration: const InputDecoration(labelText: 'Reason (required)'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Keep order'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Cancel order'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await ref
      .read(adminOrderDetailControllerProvider(orderId).notifier)
      .transition(
        status: 'cancelled',
        reason: reasonController.text.trim(),
      );
}



