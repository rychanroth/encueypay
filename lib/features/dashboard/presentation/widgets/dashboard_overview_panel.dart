import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/dashboard_controller.dart';

/// Prebuilt wishlist cards for the overview rail — built by the composition
/// root (interactive ProductCards; ARCH-04 keeps features/dashboard away
/// from features/catalog).
typedef DashboardWishlistCards = List<Widget>;

/// The customer account overview (Section 8A): spending hero, a combined
/// orders panel, the wishlist rail, and a cart summary. Embedded in the
/// Profile screen (the account area) — an overview with "view all" jumps,
/// not a duplicate of the full screens.
class DashboardOverviewPanel extends ConsumerWidget {
  const DashboardOverviewPanel({super.key, required this.wishlistCards});

  final DashboardWishlistCards wishlistCards;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardControllerProvider);
    final theme = Theme.of(context);

    return summaryAsync.maybeWhen(
      data: (summary) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Spending hero — money that actually contributed (cancelled and
          // returned orders excluded, §8A).
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total spending',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer)),
                  Text(
                    Money(summary.totalSpendingMinor).format(),
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${summary.totalOrders} orders · '
                    '${summary.completedOrders} completed · '
                    '${summary.cancelledOrders} cancelled',
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
          ),
          _PanelHeader(
            title: 'Orders',
            actionLabel: 'View all',
            onAction: () => context.goNamed(AppRoutes.orders),
          ),
          if (summary.recentOrders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('No orders yet.'),
            )
          else
            for (final order in summary.recentOrders)
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: Icon(
                  switch (order.state) {
                    'completed' => Icons.check_circle_outline,
                    'cancelled' => Icons.cancel_outlined,
                    _ => Icons.local_shipping_outlined,
                  },
                  size: 20,
                  color: switch (order.state) {
                    'completed' => theme.colorScheme.primary,
                    'cancelled' => theme.colorScheme.error,
                    _ => theme.colorScheme.secondary,
                  },
                ),
                title: Text(Money(order.totalMinor).format()),
                subtitle: Text(
                  '${order.state} · '
                  '${order.createdAt.toLocal().toString().substring(0, 10)}',
                ),
                trailing: const Icon(Icons.chevron_right, size: 18),
                onTap: () => context.pushNamed(
                  AppRoutes.orderDetail,
                  pathParameters: {'id': order.id},
                ),
              ),
          _PanelHeader(
            title: 'Wishlist',
            actionLabel: summary.wishlistCount > wishlistCards.length
                ? 'See all'
                : null,
            onAction: () => context.goNamed(AppRoutes.wishlist),
          ),
          if (wishlistCards.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Your wishlist is empty.'),
            )
          else
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final card in wishlistCards)
                    SizedBox(
                      width: 108,
                      child: card,
                    ),
                ],
              ),
            ),
          _PanelHeader(
            title: 'Cart',
            actionLabel: 'View cart',
            onAction: () => context.goNamed(AppRoutes.cart),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: Text(
                '${summary.cartItemCount} item(s) · '
                '${Money(summary.cartSubtotalMinor).format()}',
              ),
              subtitle: const Text('Ready at checkout'),
            ),
          ),
        ],
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
