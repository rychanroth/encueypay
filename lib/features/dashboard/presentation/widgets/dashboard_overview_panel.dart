import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/status_badge.dart';
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
          // Spending hero (DESIGN.md §5.1.5): money that actually
          // contributed (cancelled and returned orders excluded, §8A) over
          // the royal gradient, with status-tinted order count badges.
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: AppRadii.br24,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total spending',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  Money(summary.totalSpendingMinor).formatUsd(),
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '≈ ${Money(summary.totalSpendingMinor).formatKhr()}',
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _CountBadge(
                        wireName: 'confirmed',
                        label: '${summary.totalOrders} active-ish'),
                    const SizedBox(width: AppSpacing.sm),
                    _CountBadge(
                        wireName: 'delivered',
                        label: '${summary.completedOrders} done'),
                    const SizedBox(width: AppSpacing.sm),
                    _CountBadge(
                        wireName: 'cancelled',
                        label: '${summary.cancelledOrders} cancelled'),
                  ],
                ),
              ],
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
                title: Text(
                  Money(order.totalMinor).formatUsd(),
                  style: theme.textTheme.titleSmall,
                ),
                subtitle: Text(
                  '${order.createdAt.toLocal().toString().substring(0, 10)}'
                  ' · ≈ ${Money(order.totalMinor).formatKhr()}',
                ),
                // §2.2 badge: wire name falls back to the derived state for
                // dashboard rows (completed/cancelled map directly).
                trailing: StatusBadge(
                  wireName: switch (order.state) {
                    'completed' => 'delivered',
                    'cancelled' => 'cancelled',
                    _ => 'processing',
                  },
                  label: order.state,
                  dense: true,
                ),
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
                '${Money(summary.cartSubtotalMinor).formatUsd()}'
                ' · ≈ ${Money(summary.cartSubtotalMinor).formatKhr()}',
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
              style: Theme.of(context).textTheme.titleMedium,
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


/// Status-tinted order count badge (§5.1.5 / §2.2 palette).
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.wireName, required this.label});

  final String wireName;
  final String label;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(wireName: wireName, label: label, dense: true);
  }
}
