import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_role.dart';
import 'app_routes.dart';
import 'branches/admin_categories_branch.dart';
import 'branches/admin_dashboard_branch.dart';
import 'branches/admin_orders_branch.dart';
import 'branches/admin_products_branch.dart';
import 'branches/admin_promotions_branch.dart';
import 'branches/cart_branch.dart';
import 'branches/home_branch.dart';
import 'branches/orders_branch.dart';
import 'branches/profile_branch.dart';

// 2-Role product direction (Section 9 cleanup): the Business Owner and
// Driver portals and the role-application flow were REMOVED with their
// features (living spec removal record) — only customer and admin tab sets
// exist. Roles other than customer/admin in the DB fall back to the
// customer surface.

final List<NavigationTab> _customerTabs = [
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
];

final List<NavigationTab> _adminTabs = [
  NavigationTab(
    branch: adminDashboardBranch,
    icon: Icons.admin_panel_settings_outlined,
    label: 'Dashboard',
  ),
  // Section 3 — spec §8 "manages Orders" (administrative fulfillment).
  NavigationTab(
    branch: adminOrdersBranch,
    icon: Icons.receipt_long_outlined,
    label: 'Orders',
  ),
  // Section 2b — spec §8 "manages Products" (branded catalog management).
  NavigationTab(
    branch: adminProductsBranch,
    icon: Icons.inventory_2_outlined,
    label: 'Products',
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
];

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
    UserRole.customer => _customerTabs,
    UserRole.admin => _adminTabs,
    // Bypassed roles fall back to the customer surface (Part C, L-01/L-02):
    // the DB enum still admits these values, so the switch must handle them,
    // but no operator tab set is mounted in the prototype.
    UserRole.business || UserRole.driver => _customerTabs,
  };
}

/// Default landing route after sign-in, per role (ROUTE-10).
String defaultRouteForRole(UserRole role) {
  return switch (role) {
    UserRole.customer => AppRoutes.home,
    UserRole.admin => AppRoutes.adminDashboard,
    UserRole.business || UserRole.driver => AppRoutes.home,
  };
}
