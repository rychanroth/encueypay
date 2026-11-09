import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/picked_file.dart';

part 'admin.freezed.dart';

@freezed
abstract class AdminCategory with _$AdminCategory {
  const factory AdminCategory({
    required String id,
    required String name,
    String? imageUrl,

    /// Raw storage reference (catalog_assets path or http passthrough) —
    /// passed back on edit so the display URL is never re-persisted.
    String? imagePath,

    /// Parent category id — null for top-level (Section 2c, 2-level
    /// taxonomy).
    String? parentId,
  }) = _AdminCategory;
}

/// Brand management read model (living spec Part B §2/§8, Section 2b):
/// admin-managed catalog brands (assignment §2/§3). [imageUrl] is a full
/// public URL (Section 2c, banner convention); [imagePath] is the raw
/// catalog_assets reference carried for round-trip edits.
@freezed
abstract class AdminBrand with _$AdminBrand {
  const factory AdminBrand({
    required String id,
    required String name,
    @Default('') String description,
    String? imageUrl,
    String? imagePath,
    @Default(AdminCatalogStatus.active) AdminCatalogStatus status,
  }) = _AdminBrand;
}

/// Product row for the admin catalog view (spec §8 "manages Products",
/// Section 2b): all statuses, with display names resolved server-side.
/// Category/brand ids ride along so the edit form can preselect
/// its dropdowns.
@freezed
abstract class AdminProductSummary with _$AdminProductSummary {
  const factory AdminProductSummary({
    required String id,
    required String name,
    required String categoryId,
    required String categoryName,
    required int basePriceMinor,
    required int variantCount,
    required int stock,
    @Default('') String description,
    @Default(AdminCatalogStatus.active) AdminCatalogStatus status,
    String? brandId,
    String? brandName,
    @Default([]) List<AdminProductImageRef> images,

    /// Active variants for the edit form's variant editor (Section 2b).
    /// Archived variants stay server-side — they are unreachable for
    /// purchase and cannot be resurrected from the form.
    @Default([]) List<AdminProductVariantRef> variants,
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

/// Existing active priced variant on a product, for the edit form
/// (Section 2b). The null-price single-price placeholder is filtered out by
/// the repository — it is not an admin-managed option.
@freezed
abstract class AdminProductVariantRef with _$AdminProductVariantRef {
  const AdminProductVariantRef._();

  const factory AdminProductVariantRef({
    required String id,
    required String name,

    /// Null tracks the product's base price (server rule §1.2).
    int? priceMinor,

    /// Raw `product_variants.image_path` (sent back untouched on save) and
    /// its resolved public URL for the row's image preview.
    String? imagePath,
    String? imageUrl,
  }) = _AdminProductVariantRef;

  bool get isBasePricePlaceholder => priceMinor == null;
}

/// Form input for creating/updating a product (Section 2b). [id] is null for
/// creation; [brandId] is nullable — a product may be brand-less. [stock] is
/// product-wide (Section 2d): purchasing any variant deducts it.
@freezed
abstract class AdminProductDraft with _$AdminProductDraft {
  const factory AdminProductDraft({
    String? id,

    /// Null on create — the server resolves (or provisions) the singleton
    /// prototype business (DESIGN.md §1.1); edits carry the product's
    /// existing business.
    required String categoryId,
    String? brandId,
    required String name,
    @Default('') String description,
    @Default(0) int stock,

    /// Every product needs at least one explicit variant. Rows with an
    /// [AdminProductVariantDraft.id] update in place, id-less rows are
    /// inserted, and missing active variants are archived server-side. The
    /// server derives `products.base_price_minor` from the cheapest row.
    @Default([]) List<AdminProductVariantDraft> variants,
  }) = _AdminProductDraft;
}

/// One variant row authored in the product form. [id] is null for new rows
/// (fresh authoring on create or edit); non-null rows update the existing
/// variant in place. [imagePath] is the variant's existing storage path
/// (kept on save when no fresh pick replaces it); [imagePick] is a fresh pick
/// awaiting upload — the controller uploads it and resolves the final path
/// before the RPC call.
@freezed
abstract class AdminProductVariantDraft with _$AdminProductVariantDraft {
  const factory AdminProductVariantDraft({
    String? id,
    required String name,

    /// Required for authored variants. The form never sends the null-price
    /// single-price placeholder (the server manages it).
    int? priceMinor,
    String? imagePath,
    PickedFile? imagePick,
  }) = _AdminProductVariantDraft;
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
    @Default('') String customerPhone,
    @Default('') String shippingRecipientName,
    @Default('') String shippingPhone,
    @Default('') String shippingLine1,
    String? shippingLine2,
    @Default('') String shippingCity,
  }) = _AdminOrderSummary;

  const AdminOrderSummary._();

  /// Total units across all line items (not the number of distinct lines).
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

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

  /// Cash is collected on delivery, so the admin can only record it after
  /// the order reaches the terminal delivered state.
  bool get canMarkCodPaid =>
      status == AdminOrderStatus.delivered &&
      paymentMethod == 'cod' &&
      paymentStatus != null &&
      paymentStatus != 'transaction_verified';
}

/// Historical order line for the admin view (§19 snapshots).
@freezed
abstract class AdminOrderItem with _$AdminOrderItem {
  const factory AdminOrderItem({
    required String productName,
    required int quantity,
    required int lineTotalMinor,
    String? variantName,
    int? unitPriceMinor,
    int? discountMinor,
    String? imageUrl,
  }) = _AdminOrderItem;
}

/// Filter/sort parameters for the admin order search (Section 3). Empty sets
/// mean "any"; `from`/`to` are inclusive local days; [excludeCancelled] backs
/// the dashboard Total-sales deep link (the KPI sums non-cancelled orders).
@freezed
abstract class AdminOrderQuery with _$AdminOrderQuery {
  const factory AdminOrderQuery({
    @Default('') String search,
    DateTime? from,
    DateTime? to,
    @Default(<String>{}) Set<String> statuses,
    @Default(<String>{}) Set<String> paymentStatuses,
    @Default(<String>{}) Set<String> paymentMethods,
    String? brandId,
    String? categoryId,
    int? minTotalMinor,
    int? maxTotalMinor,
    @Default(false) bool excludeCancelled,
    @Default(false) bool needsAttention,
    @Default(AdminOrderSort.newest) AdminOrderSort sort,
  }) = _AdminOrderQuery;

  const AdminOrderQuery._();

  /// True when anything narrows the result (used for the no-match empty
  /// state vs "no orders yet").
  bool get hasFilters =>
      search.isNotEmpty ||
      from != null ||
      to != null ||
      statuses.isNotEmpty ||
      paymentStatuses.isNotEmpty ||
      paymentMethods.isNotEmpty ||
      brandId != null ||
      categoryId != null ||
      minTotalMinor != null ||
      maxTotalMinor != null ||
      excludeCancelled ||
      needsAttention;
}

/// One page of the admin order search plus the full matching totals.
@freezed
abstract class AdminOrderPage with _$AdminOrderPage {
  const factory AdminOrderPage({
    @Default(<AdminOrderSummary>[]) List<AdminOrderSummary> orders,
    @Default(0) int totalCount,
    @Default(0) int totalMinor,
  }) = _AdminOrderPage;
}

enum AdminOrderSort {
  newest,
  oldest,
  totalDesc,
  totalAsc;

  String get wireName => switch (this) {
        AdminOrderSort.totalDesc => 'total_desc',
        AdminOrderSort.totalAsc => 'total_asc',
        _ => name,
      };
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

  static AdminOrderStatus fromName(String? name) {
    if (name == null) return AdminOrderStatus.pending;
    // Wire values are snake_case ('out_for_delivery') while enum `.name` is
    // camelCase — match both, or multi-word statuses collapse to the
    // fallback and the admin UI offers illegal transitions.
    for (final value in AdminOrderStatus.values) {
      if (value.name == name || value.wireName == name) return value;
    }
    return AdminOrderStatus.pending;
  }

  /// Wire value (snake_case on the wire).
  String get wireName => switch (this) {
        AdminOrderStatus.outForDelivery => 'out_for_delivery',
        _ => name,
      };
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
    // DESIGN.md §5.2.4 executive extras (additive RPC keys).
    @Default(0) int netSettledMinor,
    @Default(0) int inventoryValuationMinor,
    @Default(AdminPaymentSplit()) AdminPaymentSplit paymentSplit,
    @Default([]) List<AdminBrandRevenue> brandRevenue,
  }) = _AdminSalesReport;
}

/// Payment gateway distribution (§5.2.4) over realized orders.
@freezed
abstract class AdminPaymentSplit with _$AdminPaymentSplit {
  const factory AdminPaymentSplit({
    @Default(0) int qrCount,
    @Default(0) int codCount,
    @Default(0) int qrAmountMinor,
    @Default(0) int codAmountMinor,
  }) = _AdminPaymentSplit;
}

/// Brand revenue ranking row (§5.2.4).
@freezed
abstract class AdminBrandRevenue with _$AdminBrandRevenue {
  const factory AdminBrandRevenue({
    required String name,
    required int revenueMinor,
    String? imageUrl,
  }) = _AdminBrandRevenue;
}

@freezed
abstract class AdminCategoryUnits with _$AdminCategoryUnits {
  const factory AdminCategoryUnits({
    required String name,
    required int units,
    String? imageUrl,
  }) = _AdminCategoryUnits;
}

@freezed
abstract class AdminCustomerFrequency with _$AdminCustomerFrequency {
  const factory AdminCustomerFrequency({
    required String name,
    required int orders,
    String? imageUrl,
  }) = _AdminCustomerFrequency;
}

@freezed
abstract class AdminBestSeller with _$AdminBestSeller {
  const factory AdminBestSeller({
    required String name,
    required int units,
    // Product detail deep-link + thumbnail (dashboard Top Sellers).
    String? productId,
    String? imageUrl,
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
    required String paymentAccount,
  }) = _PlatformSettings;
}
