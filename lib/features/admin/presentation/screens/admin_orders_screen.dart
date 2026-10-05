import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/admin_orders_controller.dart';
import '../widgets/admin_lifecycle_chip.dart';

/// Admin Orders tab (Section 3, spec §8 "manages Orders"): every order with
/// its coarse lifecycle; tap through to the fulfillment view.
class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersControllerProvider);

    ref.listen(adminOrdersControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

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
                onPressed: () => ref.invalidate(adminOrdersControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    '${order.customerName} · ${Money(order.totalMinor).format()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${order.createdAt.toLocal().toString().split('.').first}'
                    ' · ${order.items.length} item(s)'
                    '${order.paymentStatus == null ? '' : ' · ${order.paymentStatus}'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: AdminLifecycleChip(label: order.status.wireName),
                  onTap: () => context.pushNamed(
                    AppRoutes.adminOrderDetail,
                    pathParameters: {'id': order.id},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
