import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/dashboard_controller.dart';

/// Customer dashboard (assignment §1, Section 5): active orders, wishlist
/// count, cart items, total spending, and recent orders. Mounted under the
/// Profile tab (`/profile/dashboard`); navigation taps cross to the orders
/// tab via route names (ROUTE-02).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My dashboard')),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(dashboardControllerProvider.future),
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('$error', textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () =>
                          ref.invalidate(dashboardControllerProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          data: (summary) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.local_shipping_outlined,
                      label: 'Active orders',
                      value: '${summary.activeOrders}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.favorite_outline,
                      label: 'Wishlist',
                      value: '${summary.wishlistCount}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.shopping_cart_outlined,
                      label: 'Cart items',
                      value: '${summary.cartItemCount}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.payments_outlined,
                      label: 'Total spending',
                      value: Money(summary.totalSpendingMinor).format(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Recent orders',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              if (summary.recentOrders.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No orders yet.'),
                )
              else
                for (final order in summary.recentOrders)
                  Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: ListTile(
                      leading: Icon(
                        switch (order.state) {
                          'completed' => Icons.check_circle_outline,
                          'cancelled' => Icons.cancel_outlined,
                          _ => Icons.local_shipping_outlined,
                        },
                        color: switch (order.state) {
                          'completed' => theme.colorScheme.primary,
                          'cancelled' => theme.colorScheme.error,
                          _ => theme.colorScheme.secondary,
                        },
                      ),
                      title: Text(Money(order.totalMinor).format()),
                      subtitle: Text(
                        order.createdAt.toLocal().toString().split('.').first,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.pushNamed(
                        AppRoutes.orderDetail,
                        pathParameters: {'id': order.id},
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
