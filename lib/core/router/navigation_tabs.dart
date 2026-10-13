import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_role.dart';
import 'app_routes.dart';
import 'branches/admin_dashboard_branch.dart';
import 'branches/admin_orders_branch.dart';
import 'branches/admin_products_branch.dart';
import 'branches/admin_reports_branch.dart';
import 'branches/cart_branch.dart';
import 'branches/discovery_branch.dart';
import 'branches/home_branch.dart';
import 'branches/orders_branch.dart';
import 'branches/profile_branch.dart';

// 2-Role product direction (Section 9 cleanup): the Business Owner and
// Driver portals and the role-application flow were REMOVED with their
// features (living spec removal record) — only customer and admin tab sets
// exist. Roles other than customer/admin in the DB fall back to the
// customer surface.
//
// Shell structure follows DESIGN.md §5: customer 5-tab (Home, Discover,
// Cart, Orders, Profile), admin 4-tab executive shell (Dashboard, Products,
// Orders, Reports). Categories/Promotions/Profile management moved into
// Dashboard quick actions (their routes are nested under the dashboard
// branch, ROUTE-04).

final List<NavigationTab> _customerTabs = [
  NavigationTab(
    id: 'home',
    branch: homeBranch,
    icon: Icons.storefront_outlined,
    selectedIcon: Icons.storefront,
    label: 'Home',
  ),
  NavigationTab(
    id: 'discovery',
    branch: discoveryBranch,
    icon: Icons.travel_explore_outlined,
    selectedIcon: Icons.travel_explore,
    label: 'Discover',
  ),
  NavigationTab(
    id: 'cart',
    branch: cartBranch,
    icon: Icons.shopping_cart_outlined,
    selectedIcon: Icons.shopping_cart,
    label: 'Cart',
  ),
  NavigationTab(
    id: 'orders',
    branch: ordersBranch,
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    label: 'Orders',
  ),
  NavigationTab(
    id: 'profile',
    branch: profileBranch,
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Profile',
  ),
];

final List<NavigationTab> _adminTabs = [
  NavigationTab(
    id: 'dashboard',
    branch: adminDashboardBranch,
    icon: Icons.admin_panel_settings_outlined,
    selectedIcon: Icons.admin_panel_settings,
    label: 'Dashboard',
  ),
  // Section 2b — spec §8 "manages Products" (branded catalog management).
  NavigationTab(
    id: 'adminProducts',
    branch: adminProductsBranch,
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    label: 'Products',
  ),
  // Section 3 — spec §8 "manages Orders" (administrative fulfillment).
  NavigationTab(
    id: 'adminOrders',
    branch: adminOrdersBranch,
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
    label: 'Orders',
  ),
  NavigationTab(
    id: 'adminReports',
    branch: adminReportsBranch,
    icon: Icons.query_stats_outlined,
    selectedIcon: Icons.query_stats,
    label: 'Reports',
  ),
];

/// Single source of truth for tab order per role. BOTH the router's branch
/// list and the shell's NavigationBar derive from this mapping — that is
/// what keeps ROUTE-05 (branch order == NavigationBar order) satisfied.
class NavigationTab {
  const NavigationTab({
    required this.id,
    required this.branch,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  /// Stable identifier for shell-level decorations (e.g. the Cart badge).
  final String id;
  final StatefulShellBranch branch;
  final IconData icon;
  final IconData selectedIcon;
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
