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

  // Checkout (nested under Cart).
  static const checkout = 'checkout';
  static const orderPlaced = 'orderPlaced';

  // Orders (nested under Orders tab).
  static const orderDetail = 'orderDetail';
  static const returnRequest = 'returnRequest';
  static const reviewCompose = 'reviewCompose';

  // Business (nested under Business dashboard).
  static const businessReturns = 'businessReturns';
  static const businessPromotions = 'businessPromotions';

  // Admin (nested under Admin dashboard).
  static const adminAudit = 'adminAudit';
  static const adminSettings = 'adminSettings';

  // Catalog (nested under Home).
  static const products = 'products';
  static const productDetail = 'productDetail';
  static const businessDetail = 'businessDetail';
  static const notifications = 'notifications';

  // Shared tab (all roles).
  static const profile = 'profile';
  static const profileEdit = 'profileEdit';
  static const addresses = 'addresses';
  static const addressEdit = 'addressEdit';
  static const wishlist = 'wishlist';
  static const settings = 'settings';
  static const roleApplication = 'roleApplication';

  // Business tabs.
  static const businessDashboard = 'businessDashboard';
  static const businessProducts = 'businessProducts';
  static const businessProductForm = 'businessProductForm';
  static const businessOrders = 'businessOrders';
  static const businessOrderDetail = 'businessOrderDetail';

  // Driver tabs.
  static const driverAvailable = 'driverAvailable';
  static const driverDeliveries = 'driverDeliveries';

  // Admin tabs.
  static const adminDashboard = 'adminDashboard';
  static const adminApplications = 'adminApplications';
  static const adminCategories = 'adminCategories';
  static const adminPromotions = 'adminPromotions';
}
