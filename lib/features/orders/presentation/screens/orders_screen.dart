import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/order.dart';
import '../controllers/orders_controller.dart';

/// Customer tab 3 — My orders (spec §58 GetMyOrders). Overall status shown
/// is derived from the independent business/payment/delivery states
/// (spec §10/§52).
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  Color _statusColor(BuildContext context, CustomerOrderStatus status) {
    switch (status) {
      case CustomerOrderStatus.pending:
        return Theme.of(context).colorScheme.secondary;
      case CustomerOrderStatus.cancelled:
      case CustomerOrderStatus.refundRequired:
        return Theme.of(context).colorScheme.error;
      case CustomerOrderStatus.delivered:
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(ordersControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }
          return NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter < 400) {
                ref.read(ordersControllerProvider.notifier).loadMore();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = orders[index];
                final status = order.derivedStatus;
                return Card(
                  child: ListTile(
                    title: Text(
                      'Order ${order.id.substring(0, 8)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${order.createdAt.toLocal().toString().substring(0, 16)}'
                      ' · ${Money(order.totalMinor).format()}',
                    ),
                    trailing: Chip(
                      label: Text(
                        status.name,
                        style: TextStyle(
                          color: _statusColor(context, status),
                          fontSize: 12,
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(color: _statusColor(context, status)),
                      backgroundColor: Colors.transparent,
                    ),
                    onTap: () => context.pushNamed(
                      AppRoutes.orderDetail,
                      pathParameters: {'id': order.id},
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
