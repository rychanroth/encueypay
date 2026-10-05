import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard.freezed.dart';

/// Aggregated customer dashboard (assignment §1, Section 5): recent orders,
/// active orders, wishlist count, cart items, total spending — one
/// server-side aggregation (`get_customer_dashboard`, 0035).
@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required int activeOrders,
    required int wishlistCount,
    required int cartItemCount,
    required int cartSubtotalMinor,
    required int totalSpendingMinor,
    required int completedOrders,
    required int cancelledOrders,
    required int totalOrders,
    @Default([]) List<DashboardOrder> recentOrders,
  }) = _DashboardSummary;
}

/// Slim recent-order row for the dashboard. [state] is a coarse
/// bucket — 'active', 'completed', or 'cancelled' — derived server-side
/// from the business-order lifecycle (the customer-facing fine-grained
/// lifecycle lives in features/orders).
@freezed
abstract class DashboardOrder with _$DashboardOrder {
  const factory DashboardOrder({
    required String id,
    required int totalMinor,
    required DateTime createdAt,
    @Default('active') String state,
  }) = _DashboardOrder;
}
