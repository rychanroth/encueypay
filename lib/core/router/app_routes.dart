/// Single source of route names (ROUTE-01). Navigation always goes through
/// `context.goNamed(AppRoutes.x)` with parameters — never raw path strings
/// (ROUTE-02). Raw paths appear only inside route *definitions*.
abstract final class AppRoutes {
  // Auth — full-screen overlay, outside the shell (ROUTE-03).
  static const login = 'login';

  // Customer tabs.
  static const home = 'home';
  static const cart = 'cart';
  static const orders = 'orders';

  // Shared tab (all roles).
  static const profile = 'profile';
  static const profileEdit = 'profileEdit';
  static const addresses = 'addresses';
  static const addressEdit = 'addressEdit';
  static const settings = 'settings';

  // Business tabs.
  static const businessDashboard = 'businessDashboard';
  static const businessProducts = 'businessProducts';
  static const businessOrders = 'businessOrders';

  // Driver tabs.
  static const driverAvailable = 'driverAvailable';
  static const driverDeliveries = 'driverDeliveries';

  // Admin tabs.
  static const adminDashboard = 'adminDashboard';
  static const adminApplications = 'adminApplications';
  static const adminCategories = 'adminCategories';
  static const adminPromotions = 'adminPromotions';
}
