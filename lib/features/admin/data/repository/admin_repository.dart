import '../../domain/entities/admin.dart';

/// Admin management contract (spec §2.4/§35.4/§58) (DATA-03). Admin
/// authority is explicit — no operational order/delivery overrides.
///
/// Section 2b adds brand + product catalog management (assignment §2/§3/§8;
/// living spec ledger L-08 removal). Brand writes go straight through RLS
/// (`brands_admin_*` policies); product mutations go through the
/// admin-guarded RPCs of migration `20261005000029`.
abstract interface class IAdminRepository {
  Future<List<AdminCategory>> fetchCategories();

  Future<void> createCategory({
    required String name,
    String? parentId,
    String? imagePath,
  });

  Future<void> renameCategory({
    required String categoryId,
    required String name,
    String? imagePath,
  });

  /// Uploads brand/category imagery into the public `catalog_assets` bucket
  /// (DESIGN.md imagery pipeline) and returns the stored path (or an
  /// http(s) reference passthrough). Admin-write RLS applies.
  Future<String> uploadCatalogImage({required String filePath});

  Future<void> deleteCategory({required String categoryId});

  // ------------------------------------------------------- brands (2b)
  Future<List<AdminBrand>> fetchBrands();

  Future<void> createBrand({
    required String name,
    String? description,
    String? imagePath,
  });

  Future<void> updateBrand({
    required String brandId,
    required String name,
    String? description,
    String? imagePath,
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

  /// Section 7A: advances the order's single lifecycle one step (or
  /// cancels a not-yet-shipped order with a reason).
  Future<void> transitionOrder({
    required String orderId,
    required String status,
    String? reason,
  });

  /// Section 7D: records the refund on a cancelled order whose payment was
  /// already verified (refund_required → refunded + reference).
  Future<void> markRefunded({
    required String orderId,
    String? reference,
  });

  /// Mirrors process_return with admin authority.
  Future<void> processReturn({
    required String returnId,
    required bool approve,
  });

  /// Section 7E: completes an APPROVED return (the refund-recorded end
  /// state) — an explicit admin action, not automatic.
  Future<void> completeReturn({required String returnId});

  /// Section 6b: dev-only simulation of a confirmed gateway webhook
  /// (admin authority) for the QR payment flow.
  Future<void> simulateQrPayment({required String orderId});

  // -------------------------------------------------------- audit/report
  Future<List<AuditEntry>> fetchAuditLogs();

  Future<PlatformAnalyticsReport> fetchPlatformReport();

  /// Assignment §8 dashboard KPIs (Section 4, `get_admin_kpis`).
  Future<AdminKpis> fetchAdminKpis();

  /// Assignment §8 reporting (Section 8C): date-range sales report;
  /// [from]/[to] are inclusive.
  Future<AdminSalesReport> fetchSalesReport({
    required DateTime from,
    required DateTime to,
  });

  Future<PlatformSettings> fetchPlatformSettings();

  Future<void> updatePlatformSettings(PlatformSettings settings);
}
