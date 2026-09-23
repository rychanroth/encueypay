import '../../domain/entities/admin.dart';

/// Admin management contract (spec §2.4/§35.4/§58) (DATA-03). Admin
/// authority is explicit — no operational order/delivery overrides.
abstract interface class IAdminRepository {
  Future<List<AdminApplication>> fetchPendingApplications();

  Future<void> reviewApplication({
    required String applicationId,
    required bool approve,
    String? reason,
  });

  Future<List<AdminCategory>> fetchCategories();

  Future<void> createCategory({required String name, String? parentId});

  Future<void> renameCategory({
    required String categoryId,
    required String name,
  });

  Future<void> deleteCategory({required String categoryId});

  Future<List<AuditEntry>> fetchAuditLogs();

  Future<PlatformAnalyticsReport> fetchPlatformReport();

  Future<PlatformSettings> fetchPlatformSettings();

  Future<void> updatePlatformSettings(PlatformSettings settings);
}
