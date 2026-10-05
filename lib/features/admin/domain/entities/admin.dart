import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin.freezed.dart';

@freezed
abstract class AdminCategory with _$AdminCategory {
  const factory AdminCategory({
    required String id,
    required String name,
    String? imageUrl,
  }) = _AdminCategory;
}

/// Brand management read model (living spec Part B §2/§8, Section 2b):
/// admin-managed catalog brands (assignment §2/§3). [imageUrl] is a full
/// public URL (Section 2c, banner convention).
@freezed
abstract class AdminBrand with _$AdminBrand {
  const factory AdminBrand({
    required String id,
    required String name,
    @Default('') String description,
    String? imageUrl,
    @Default(AdminCatalogStatus.active) AdminCatalogStatus status,
  }) = _AdminBrand;
}

/// Product row for the admin catalog view (spec §8 "manages Products",
/// Section 2b): all statuses, with display names resolved server-side.
/// Category/business/brand ids ride along so the edit form can preselect
/// its dropdowns.
@freezed
abstract class AdminProductSummary with _$AdminProductSummary {
  const factory AdminProductSummary({
    required String id,
    required String name,
    required String categoryId,
    required String businessId,
    required String categoryName,
    required String businessName,
    required int basePriceMinor,
    required int variantCount,
    required int stock,
    @Default('') String description,
    @Default(AdminCatalogStatus.active) AdminCatalogStatus status,
    String? brandId,
    String? brandName,
    @Default([]) List<AdminProductImageRef> images,
  }) = _AdminProductSummary;
}

/// Shared status vocabulary for admin-managed catalog rows (`product_status`
/// on the wire). Unknown values fall back to [archived] — the safe default
/// for moderation.
enum AdminCatalogStatus {
  active,
  archived;

  static AdminCatalogStatus fromName(String? name) =>
      AdminCatalogStatus.values.asNameMap()[name] ??
      AdminCatalogStatus.archived;
}

/// Product image reference for admin editing (Section 2b).
@freezed
abstract class AdminProductImageRef with _$AdminProductImageRef {
  const factory AdminProductImageRef({
    required String id,
    required String storagePath,
    required String url,
  }) = _AdminProductImageRef;
}

/// Slim business reference for the product form's store picker (Section 2b).
@freezed
abstract class AdminBusinessRef with _$AdminBusinessRef {
  const factory AdminBusinessRef({required String id, required String name})
      = _AdminBusinessRef;
}

/// Form input for creating/updating a product (Section 2b). [id] is null for
/// creation; [brandId] is nullable — a product may be brand-less. [stock] is
/// product-wide (Section 2d): purchasing any variant deducts it.
@freezed
abstract class AdminProductDraft with _$AdminProductDraft {
  const factory AdminProductDraft({
    String? id,
    required String businessId,
    required String categoryId,
    String? brandId,
    required String name,
    @Default('') String description,
    required int basePriceMinor,
    @Default(0) int stock,
  }) = _AdminProductDraft;
}

/// Order oversight read model (Section 7A): the order's SINGLE lifecycle
/// (`orders.status`, assignment vocabulary) with its items and return
/// requests. The admin transitions the machine directly.
@freezed
abstract class AdminOrderSummary with _$AdminOrderSummary {
  const factory AdminOrderSummary({
    required String id,
    required String customerName,
    required int subtotalMinor,
    required int discountMinor,
    required int deliveryFeeMinor,
    required int totalMinor,
    required DateTime createdAt,
    required AdminOrderStatus status,
    @Default('') String cancellationReason,
    String? paymentMethod,
    String? paymentStatus,
    @Default([]) List<AdminOrderItem> items,
    @Default([]) List<AdminReturnRequest> returns,
  }) = _AdminOrderSummary;

  const AdminOrderSummary._();

  /// The next step of the lifecycle, or null when terminal/not yet
  /// cancellable. Pending/confirmed orders can instead be cancelled with a
  /// reason (the rejection equivalent).
  AdminOrderStatus? get nextTransition => switch (status) {
        AdminOrderStatus.pending => AdminOrderStatus.confirmed,
        AdminOrderStatus.confirmed => AdminOrderStatus.processing,
        AdminOrderStatus.processing => AdminOrderStatus.packed,
        AdminOrderStatus.packed => AdminOrderStatus.shipped,
        AdminOrderStatus.shipped => AdminOrderStatus.outForDelivery,
        AdminOrderStatus.outForDelivery => AdminOrderStatus.delivered,
        _ => null,
      };

  bool get cancellable =>
      status == AdminOrderStatus.pending ||
      status == AdminOrderStatus.confirmed;
}

/// Historical order line for the admin view (§19 snapshots).
@freezed
abstract class AdminOrderItem with _$AdminOrderItem {
  const factory AdminOrderItem({
    required String productName,
    required int quantity,
    required int lineTotalMinor,
    @Default('') String businessName,
    String? variantName,
  }) = _AdminOrderItem;
}

/// The order lifecycle (mirrors the `order_status` wire enum, Section 7A).
enum AdminOrderStatus {
  pending,
  confirmed,
  processing,
  packed,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned;

  static AdminOrderStatus fromName(String? name) =>
      AdminOrderStatus.values.asNameMap()[name] ?? AdminOrderStatus.pending;

  /// Wire value (snake_case on the wire).
  String get wireName => switch (this) {
        AdminOrderStatus.outForDelivery => 'out_for_delivery',
        _ => name,
      };
}

/// A customer return request on the order (pending → admin decision).
@freezed
abstract class AdminReturnRequest with _$AdminReturnRequest {
  const factory AdminReturnRequest({
    required String id,
    required String status,
    @Default('') String reason,
  }) = _AdminReturnRequest;
}

@freezed
abstract class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    required String id,
    required String action,
    required String targetType,
    required DateTime createdAt,
    String? actor,
    String? targetId,
  }) = _AuditEntry;
}

/// Platform-wide report for admins (spec §2.4) — server-computed.
@freezed
abstract class PlatformAnalyticsReport with _$PlatformAnalyticsReport {
  const factory PlatformAnalyticsReport({
    required int orderCount,
    required int gmvMinor,
    required int deliveryFeesMinor,
    required int activeBusinesses,
    required int activeProducts,
  }) = _PlatformAnalyticsReport;
}

/// Assignment §8 admin dashboard KPIs (Section 4) — server-computed by
/// `get_admin_kpis` (0034). Low-stock is back since stock returned (2d).
@freezed
abstract class AdminKpis with _$AdminKpis {
  const factory AdminKpis({
    required int totalProducts,
    required int activeProducts,
    required int totalOrders,
    required int totalCustomers,
    required int totalSalesMinor,
    required int lowStockProducts,
    required int outOfStockProducts,
    @Default([]) List<AdminBestSeller> bestSellers,
    @Default([]) List<AdminTrendPoint> salesTrend,
  }) = _AdminKpis;
}

/// Date-range sales report (Section 8C, assignment §8 reporting).
@freezed
abstract class AdminSalesReport with _$AdminSalesReport {
  const factory AdminSalesReport({
    required DateTime from,
    required DateTime to,
    required int totalOrders,
    required int completedOrders,
    required int cancelledOrders,
    required int totalSalesMinor,
    required int averageOrderValueMinor,
    required int lowStockProducts,
    required int outOfStockProducts,
    @Default([]) List<AdminBestSeller> bestSellers,
    @Default([]) List<AdminCategoryUnits> topCategories,
    @Default([]) List<AdminCustomerFrequency> purchaseFrequency,
  }) = _AdminSalesReport;
}

@freezed
abstract class AdminCategoryUnits with _$AdminCategoryUnits {
  const factory AdminCategoryUnits({
    required String name,
    required int units,
  }) = _AdminCategoryUnits;
}

@freezed
abstract class AdminCustomerFrequency with _$AdminCustomerFrequency {
  const factory AdminCustomerFrequency({
    required String name,
    required int orders,
  }) = _AdminCustomerFrequency;
}

@freezed
abstract class AdminBestSeller with _$AdminBestSeller {
  const factory AdminBestSeller({
    required String name,
    required int units,
  }) = _AdminBestSeller;
}

@freezed
abstract class AdminTrendPoint with _$AdminTrendPoint {
  const factory AdminTrendPoint({
    required DateTime day,
    required int orders,
    required int salesMinor,
  }) = _AdminTrendPoint;
}

/// The singleton platform configuration (spec §47).
@freezed
abstract class PlatformSettings with _$PlatformSettings {
  const factory PlatformSettings({
    required int deliveryFeeMinor,
    required int platformCommissionPercent,
    required int driverCommissionPercent,
    required String paymentAccount,

    /// Bakong account receiving QR payments (Section 6b; '' = unconfigured).
    @Default('') String qrAccountId,
  }) = _PlatformSettings;
}
