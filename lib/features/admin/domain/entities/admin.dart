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
  const factory AdminCategory({required String id, required String name})
      = _AdminCategory;
}

/// Brand management read model (living spec Part B §2/§8, Section 2b):
/// admin-managed catalog brands (assignment §2/§3).
@freezed
abstract class AdminBrand with _$AdminBrand {
  const factory AdminBrand({
    required String id,
    required String name,
    @Default('') String description,
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
/// creation; [brandId] is nullable — a product may be brand-less.
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
  }) = _AdminProductDraft;
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

/// The singleton platform configuration (spec §47).
@freezed
abstract class PlatformSettings with _$PlatformSettings {
  const factory PlatformSettings({
    required int deliveryFeeMinor,
    required int platformCommissionPercent,
    required int driverCommissionPercent,
    required String paymentAccount,
  }) = _PlatformSettings;
}
