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
