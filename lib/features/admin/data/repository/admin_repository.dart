import '../../domain/entities/admin.dart';

/// Admin management contract (spec §2.4/§35.4/§58) (DATA-03). Admin
/// authority is explicit — no operational order/delivery overrides.
///
/// Section 2b adds brand + product catalog management (assignment §2/§3/§8;
/// living spec ledger L-08 removal). Brand writes go straight through RLS
/// (`brands_admin_*` policies); product mutations go through the
/// admin-guarded RPCs of migration `20261005000029`.
abstract interface class IAdminRepository {
  Future<List<AdminApplication>> fetchPendingApplications();

  Future<void> reviewApplication({
    required String applicationId,
    required bool approve,
    String? reason,
  });

  Future<List<AdminCategory>> fetchCategories();

  Future<void> createCategory({
    required String name,
    String? parentId,
    String? imageUrl,
  });

  Future<void> renameCategory({
    required String categoryId,
    required String name,
    String? imageUrl,
  });

  Future<void> deleteCategory({required String categoryId});

  // ------------------------------------------------------- brands (2b)
  Future<List<AdminBrand>> fetchBrands();

  Future<void> createBrand({
    required String name,
    String? description,
    String? imageUrl,
  });

  Future<void> updateBrand({
    required String brandId,
    required String name,
    String? description,
    String? imageUrl,
  });

  Future<void> setBrandArchived({
    required String brandId,
    required bool archived,
  });

  Future<void> deleteBrand({required String brandId});

  // ------------------------------------------------------ products (2b)
  Future<List<AdminProductSummary>> fetchProducts({String? query});

  Future<List<AdminBusinessRef>> fetchActiveBusinesses();

  Future<String> createProduct(AdminProductDraft draft);

  Future<void> updateProduct(AdminProductDraft draft);

  Future<void> setProductArchived({
    required String productId,
    required bool archived,
  });

  /// Uploads the file into `product_images` under the owning business's path
  /// convention, then registers the reference via the admin RPC. The file
  /// name is derived from [filePath].
  Future<void> addProductImage({
    required String productId,
    required String filePath,
  });

  Future<void> removeProductImage({
    required String imageId,
    required String storagePath,
  });

  // -------------------------------------------------------- orders (§3)
  Future<List<AdminOrderSummary>> fetchOrders();

  /// Mirrors transition_business_order with admin authority (L-07):
  /// pending→accepted/rejected, accepted→preparing, preparing→ready.
  Future<void> transitionBusinessOrder({
    required String businessOrderId,
    required String target,
    String? reason,
  });

  /// Mirrors complete_pickup_stop + mark_delivered: completes all pickup
  /// stops and business parts, delivers, verifies COD.
  Future<void> completeOrder({required String orderId});

  /// Mirrors process_return with admin authority.
  Future<void> processReturn({
    required String returnId,
    required bool approve,
  });

  // -------------------------------------------------------- audit/report
  Future<List<AuditEntry>> fetchAuditLogs();

  Future<PlatformAnalyticsReport> fetchPlatformReport();

  /// Assignment §8 dashboard KPIs (Section 4, `get_admin_kpis`).
  Future<AdminKpis> fetchAdminKpis();

  Future<PlatformSettings> fetchPlatformSettings();

  Future<void> updatePlatformSettings(PlatformSettings settings);
}
