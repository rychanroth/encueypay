import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/business_orders_controller.dart';

/// Business tab 3 — Orders (spec §2.2). Realtime incoming orders arrive in
/// Phase 11; pull-to-refresh until then.
class BusinessOrdersScreen extends ConsumerWidget {
  const BusinessOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(businessOrdersControllerProvider);

    ref.listen(businessOrdersControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Incoming orders')),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () =>
                    ref.invalidate(businessOrdersControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(businessOrdersControllerProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      '${order.customerName} · ${Money(order.subtotalMinor).format()}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${order.createdAt.toLocal().toString().substring(0, 16)}'
                      ' · ${order.items.length} item(s) · ${order.status.name}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.pushNamed(
                      AppRoutes.businessOrderDetail,
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
