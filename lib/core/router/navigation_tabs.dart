import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_role.dart';
import 'app_routes.dart';
import 'branches/admin_applications_branch.dart';
import 'branches/admin_categories_branch.dart';
import 'branches/admin_dashboard_branch.dart';
import 'branches/admin_promotions_branch.dart';
import 'branches/business_dashboard_branch.dart';
import 'branches/business_orders_branch.dart';
import 'branches/business_products_branch.dart';
import 'branches/business_transactions_branch.dart';
import 'branches/cart_branch.dart';
import 'branches/driver_available_branch.dart';
import 'branches/driver_deliveries_branch.dart';
import 'branches/driver_transactions_branch.dart';
import 'branches/home_branch.dart';
import 'branches/orders_branch.dart';
import 'branches/profile_branch.dart';

/// Single source of truth for tab order per role. BOTH the router's branch
/// list and the shell's NavigationBar derive from this mapping — that is
/// what keeps ROUTE-05 (branch order == NavigationBar order) satisfied.
class NavigationTab {
  const NavigationTab({
    required this.branch,
    required this.icon,
    required this.label,
  });

  final StatefulShellBranch branch;
  final IconData icon;
  final String label;
}

List<NavigationTab> tabsForRole(UserRole role) {
  return switch (role) {
    UserRole.customer => [
        NavigationTab(
          branch: homeBranch,
          icon: Icons.storefront,
          label: 'Home',
        ),
        NavigationTab(
          branch: cartBranch,
          icon: Icons.shopping_cart_outlined,
          label: 'Cart',
        ),
        NavigationTab(
          branch: ordersBranch,
          icon: Icons.receipt_long_outlined,
          label: 'Orders',
        ),
        NavigationTab(
          branch: profileBranch,
          icon: Icons.person_outline,
          label: 'Profile',
        ),
      ],
    UserRole.business => [
        NavigationTab(
          branch: businessDashboardBranch,
          icon: Icons.storefront,
          label: 'Dashboard',
        ),
        NavigationTab(
          branch: businessProductsBranch,
          icon: Icons.inventory_2_outlined,
          label: 'Products',
        ),
        NavigationTab(
          branch: businessOrdersBranch,
          icon: Icons.receipt_long_outlined,
          label: 'Orders',
        ),
        NavigationTab(
          branch: businessTransactionsBranch,
          icon: Icons.payments_outlined,
          label: 'Transactions',
        ),
        NavigationTab(
          branch: profileBranch,
          icon: Icons.person_outline,
          label: 'Profile',
        ),
      ],
    UserRole.driver => [
        NavigationTab(
          branch: driverAvailableBranch,
          icon: Icons.local_shipping_outlined,
          label: 'Available',
        ),
        NavigationTab(
          branch: driverDeliveriesBranch,
          icon: Icons.route_outlined,
          label: 'My deliveries',
        ),
        NavigationTab(
          branch: driverTransactionsBranch,
          icon: Icons.payments_outlined,
          label: 'Transactions',
        ),
        NavigationTab(
          branch: profileBranch,
          icon: Icons.person_outline,
          label: 'Profile',
        ),
      ],
    UserRole.admin => [
        NavigationTab(
          branch: adminDashboardBranch,
          icon: Icons.admin_panel_settings_outlined,
          label: 'Dashboard',
        ),
        NavigationTab(
          branch: adminApplicationsBranch,
          icon: Icons.approval_outlined,
          label: 'Applications',
        ),
        NavigationTab(
          branch: adminCategoriesBranch,
          icon: Icons.category_outlined,
          label: 'Categories',
        ),
        NavigationTab(
          branch: adminPromotionsBranch,
          icon: Icons.campaign_outlined,
          label: 'Promotions',
        ),
        NavigationTab(
          branch: profileBranch,
          icon: Icons.person_outline,
          label: 'Profile',
        ),
      ],
  };
}

/// Default landing route after sign-in, per role (ROUTE-10).
String defaultRouteForRole(UserRole role) {
  return switch (role) {
    UserRole.customer => AppRoutes.home,
    UserRole.business => AppRoutes.businessDashboard,
    UserRole.driver => AppRoutes.driverAvailable,
    UserRole.admin => AppRoutes.adminDashboard,
  };
}
