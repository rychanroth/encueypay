/// Single source of route names (ROUTE-01). Navigation always goes through
/// `context.goNamed(AppRoutes.x)` with parameters — never raw path strings
/// (ROUTE-02). Raw paths appear only inside route *definitions*.
///
/// Section 9 (codebase cleanup): the business-portal, driver-portal and
/// role-application routes were removed with their features — the living
/// spec's removal record lists where they lived.
abstract final class AppRoutes {
  // Auth — full-screen overlay, outside the shell (ROUTE-03).
  static const login = 'login';

  // Customer tabs.
  static const home = 'home';
  static const cart = 'cart';
  static const orders = 'orders';

  // Checkout (nested under Cart).
  static const checkout = 'checkout';
  static const orderPlaced = 'orderPlaced';

  // Orders (nested under Orders tab).
  static const orderDetail = 'orderDetail';
  static const returnRequest = 'returnRequest';
  static const reviewCompose = 'reviewCompose';

  // Admin (nested under Admin dashboard).
  static const adminAudit = 'adminAudit';
  static const adminSettings = 'adminSettings';

  // Catalog (nested under Home).
  static const products = 'products';
  static const productDetail = 'productDetail';
  static const notifications = 'notifications';
  static const discovery = 'discovery';

  // Shared tab (all roles).
  static const profile = 'profile';
  static const profileEdit = 'profileEdit';
  static const addresses = 'addresses';
  static const addressEdit = 'addressEdit';
  static const wishlist = 'wishlist';
  static const settings = 'settings';
  static const dashboard = 'dashboard';

  // Admin tabs.
  static const adminDashboard = 'adminDashboard';
  static const adminCategories = 'adminCategories';
  static const adminPromotions = 'adminPromotions';

  // Admin products (Section 2b — nested under the Products tab).
  static const adminProducts = 'adminProducts';
  static const adminProductForm = 'adminProductForm';
  static const adminBrands = 'adminBrands';

  // Admin orders (Section 3 — nested under the Orders tab).
  static const adminOrders = 'adminOrders';
  static const adminOrderDetail = 'adminOrderDetail';
}
