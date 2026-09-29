import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/failures.dart';
import '../../domain/entities/managed_business_order.dart';
import '../controllers/business_orders_controller.dart';
import '../widgets/managed_order_items_list.dart';
import '../widgets/managed_order_status_chip.dart';

/// Business order processing (spec §11/§13): accept/reject/preparing/ready.
/// Transitions are validated server-side; rejection requires a reason and
/// requires a reason.
class ManagedOrderDetailScreen extends ConsumerWidget {
  const ManagedOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject order?'),
        content: TextField(
          controller: reasonController,
          decoration:
              const InputDecoration(labelText: 'Reason (required)'),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final reason = reasonController.text.trim();
    if (reason.isEmpty) return;
    await ref.read(businessOrdersControllerProvider.notifier).transition(
          businessOrderId: orderId,
          target: ManagedOrderStatus.rejected,
          reason: reason,
        );
  }

  Future<void> _transition(
    BuildContext context,
    WidgetRef ref,
    ManagedOrderStatus target,
  ) async {
    await ref.read(businessOrdersControllerProvider.notifier).transition(
          businessOrderId: orderId,
          target: target,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(businessOrdersControllerProvider);
    final theme = Theme.of(context);

    ref.listen(businessOrdersControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Business order')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (orders) {
          final order = orders.where((o) => o.id == orderId).firstOrNull;
          if (order == null) {
            return const Center(child: Text('Order not found.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.customerName,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ManagedOrderStatusChip(status: order.status),
                ],
              ),
              Text(
                order.createdAt.toLocal().toString().substring(0, 16),
                style: theme.textTheme.bodySmall,
              ),
              if (order.rejectionReason != null)
                Text(
                  'Reason: ${order.rejectionReason}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              const SizedBox(height: 16),
              ManagedOrderItemsList(order: order),
              const Divider(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery & payment',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(order.shippingRecipientName),
                      Text(order.shippingLine1),
                      if (order.shippingLine2 != null)
                        Text(order.shippingLine2!),
                      Text(order.shippingCity),
                      Text(order.shippingPhone,
                          style: theme.textTheme.bodySmall),
                      if (order.paymentMethod != null)
                        Text(
                          'Payment: ${order.paymentMethod!.replaceAll('_', ' ')}'
                          '${order.paymentStatus == null ? '' : ' · ${order.paymentStatus!.replaceAll('_', ' ')}'}',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (order.canAccept)
                FilledButton(
                  onPressed: () =>
                      _transition(context, ref, ManagedOrderStatus.accepted),
                  child: const Text('Accept order'),
                ),
              if (order.canReject)
                OutlinedButton.icon(
                  onPressed: () => _reject(context, ref),
                  icon: Icon(Icons.cancel_outlined,
                      color: theme.colorScheme.error),
                  label: const Text('Reject'),
                ),
              if (order.canPrepare)
                FilledButton(
                  onPressed: () =>
                      _transition(context, ref, ManagedOrderStatus.preparing),
                  child: const Text('Start preparing'),
                ),
              if (order.canMarkReady)
                FilledButton(
                  onPressed: () =>
                      _transition(context, ref, ManagedOrderStatus.ready),
                  child: const Text('Mark ready'),
                ),
              if (order.status == ManagedOrderStatus.ready)
                const Text(
                  'Ready for driver pickup.',
                  textAlign: TextAlign.center,
                ),
            ],
          );
        },
      ),
    );
  }
}
