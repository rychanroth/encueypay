import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin.freezed.dart';

/// Admin management read models (spec §2.4/§35.4). Immutable entities
/// (DOMAIN-01, freezed).
@freezed
abstract class AdminApplication with _$AdminApplication {
  const factory AdminApplication({
    required String id,
    required String applicantName,
    required String requestedRole,
    required String status,
    required DateTime createdAt,
  }) = _AdminApplication;
}

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

/// Order oversight read model (Section 3, spec §8 "manages Orders"): the
/// order with its per-business parts, payment, and return requests. Status
/// strings are raw wire values — the admin UI is a management view, not the
/// customer's derived lifecycle.
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
    String? paymentMethod,
    String? paymentStatus,
    @Default('') String deliveryStatus,
    @Default([]) List<AdminBusinessOrderPart> parts,
    @Default([]) List<AdminReturnRequest> returns,
  }) = _AdminOrderSummary;

  const AdminOrderSummary._();

  /// Coarse lifecycle state for the list chip: every part completed →
  /// Completed; any dead part → Rejected; otherwise the "earliest" live
  /// state (pending before accepted before preparing before ready).
  String get lifecycle {
    if (parts.isEmpty) return 'empty';
    if (deliveryStatus == 'delivered') return 'completed';
    if (deliveryStatus == 'delivery_in_progress') return 'out for delivery';
    if (parts.every((part) =>
        part.status == 'completed' ||
        part.status == 'rejected' ||
        part.status == 'cancelled')) {
      return 'completed';
    }
    if (parts.any((part) => part.status == 'rejected')) return 'rejected';
    const order = ['pending', 'accepted', 'preparing', 'ready'];
    var earliest = order.length - 1;
    var hasLive = false;
    for (final part in parts) {
      final index = order.indexOf(part.status);
      if (index != -1) {
        hasLive = true;
        if (index < earliest) earliest = index;
      }
    }
    return hasLive ? order[earliest] : 'completed';
  }

  bool get _allPartsDecided =>
      parts.isNotEmpty && parts.every((part) => part.status != 'pending');

  /// Section 6b: hand over to transport — every part decided, at least one
  /// in the accepted/preparing/ready pipeline, delivery still unclaimed.
  bool get shippable =>
      _allPartsDecided &&
      parts.any((part) =>
          part.status == 'accepted' ||
          part.status == 'preparing' ||
          part.status == 'ready') &&
      deliveryStatus == 'available';

  /// Section 6b: finish the delivery (only after shipping).
  bool get completable => deliveryStatus == 'delivery_in_progress';
}

/// One per-business portion of an order.
@freezed
abstract class AdminBusinessOrderPart with _$AdminBusinessOrderPart {
  const factory AdminBusinessOrderPart({
    required String id,
    required String businessName,
    required String status,
    required int subtotalMinor,
    required int discountMinor,
    String? rejectionReason,
  }) = _AdminBusinessOrderPart;
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
    required int pendingApplications,
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
