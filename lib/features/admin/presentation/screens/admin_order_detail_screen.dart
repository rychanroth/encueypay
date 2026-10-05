import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_orders_controller.dart';

/// Fulfillment view for one order (Section 3): per-business lifecycle
/// transitions (accept/reject → preparing → ready), one-shot administrative
/// delivery completion, and return decisions. The order is looked up from
/// the shared controller state so mutations refresh the view in place.
class AdminOrderDetailScreen extends ConsumerWidget {
  const AdminOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersControllerProvider);
    final theme = Theme.of(context);

    ref.listen(adminOrdersControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (orders) {
          final order = orders.where((order) => order.id == orderId).firstOrNull;
          if (order == null) {
            return const Center(child: Text('Order not found.'));
          }
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
                      .read(adminOrdersControllerProvider.notifier)
                      .transition(
                        orderId: order.id,
                        status: order.nextTransition!.wireName,
                      ),
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
              // Dev-only simulation of the gateway webhook (QR flow).
              if (order.paymentMethod == 'qr' &&
                  order.paymentStatus == 'pending')
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FilledButton.tonal(
                    onPressed: () => ref
                        .read(adminOrdersControllerProvider.notifier)
                        .simulateQrPayment(orderId: order.id),
                    child: const Text('Simulate QR payment'),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Items',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              for (final item in order.items)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.variantName == null
                        ? '${item.productName} × ${item.quantity}'
                        : '${item.productName} (${item.variantName}) × ${item.quantity}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: item.businessName.isEmpty
                      ? null
                      : Text(item.businessName),
                  trailing: Text(Money(item.lineTotalMinor).format()),
                ),
              const SizedBox(height: 16),
              Text('Return requests',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              if (order.returns.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No return requests.'),
                )
              else
                for (final request in order.returns)
                  _ReturnTile(returnRequest: request),
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
                Text(
                  order.createdAt.toLocal().toString().split('.').first,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _Row('Subtotal', Money(order.subtotalMinor).format()),
            _Row('Discount', '-${Money(order.discountMinor).format()}'),
            _Row('Delivery fee', Money(order.deliveryFeeMinor).format()),
            const Divider(),
            _Row('Total', Money(order.totalMinor).format(), bold: true),
            if (order.paymentMethod != null)
              _Row('Payment', '${order.paymentMethod} · ${order.paymentStatus}'),
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
  await ref.read(adminOrdersControllerProvider.notifier).transition(
        orderId: orderId,
        status: 'cancelled',
        reason: reasonController.text.trim(),
      );
}

class _ReturnTile extends ConsumerWidget {
  const _ReturnTile({required this.returnRequest});

  final AdminReturnRequest returnRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPending = returnRequest.status == 'pending';
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: ListTile(
        title: Text('Return · ${returnRequest.status}'),
        subtitle: returnRequest.reason.isEmpty
            ? null
            : Text(returnRequest.reason, maxLines: 2),
        trailing: isPending
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.tonal(
                    onPressed: () => ref
                        .read(adminOrdersControllerProvider.notifier)
                        .decideReturn(returnId: returnRequest.id, approve: true),
                    child: const Text('Approve'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: () => ref
                        .read(adminOrdersControllerProvider.notifier)
                        .decideReturn(
                            returnId: returnRequest.id, approve: false),
                    child: const Text('Reject'),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
