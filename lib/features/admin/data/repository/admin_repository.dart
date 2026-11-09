import '../../../../core/domain/picked_file.dart';
import '../../../../core/domain/stream_result.dart';
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
    String? parentId,
  });

  /// Uploads brand/category imagery into the public `catalog_assets` bucket
  /// (DESIGN.md imagery pipeline) and returns the stored path (or an
  /// http(s) reference passthrough). Admin-write RLS applies.
  Future<String> uploadCatalogImage({required PickedFile image});

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

  Future<String> createProduct(AdminProductDraft draft);

  Future<void> updateProduct(AdminProductDraft draft);

  Future<void> setProductArchived({
    required String productId,
    required bool archived,
  });

  /// Quick inline stock adjustment (DESIGN.md §5.2.2) through the
  /// admin-guarded RPC — server-authoritative (§1.2).
  Future<void> adjustProductStock({
    required String productId,
    required int newStock,
  });

  /// Uploads the file into `product_images` under the owning business's path
  /// convention, then registers the reference via the admin RPC. The file
  /// name is derived from [image].
  Future<void> addProductImage({
    required String productId,
    required PickedFile image,
  });

  /// Uploads a variant image pick into `product_images` (variants/ folder)
  /// and returns the storage path — the variant row references it directly
  /// (no product_images row; the customer-facing embed resolves the public
  /// URL).
  Future<String> uploadVariantImage({required PickedFile image});

  Future<void> removeProductImage({
    required String imageId,
    required String storagePath,
  });

  // -------------------------------------------------------- orders (§3)
  /// One filtered/sorted page plus the full matching count and gross total.
  Future<AdminOrderPage> searchOrders(
    AdminOrderQuery query, {
    int limit = 25,
    int offset = 0,
  });

  /// One order by id (the detail screen owns its own fetch so filters and
  /// pagination on the list cannot make the order "disappear").
  Future<AdminOrderSummary> fetchOrder(String orderId);

  /// Realtime sync signal for the admin order feed. Fires on both order
  /// lifecycle changes and payment changes so the list/detail stay fresh.
  Stream<StreamResult<bool>> watchOrderFeedChanges();

  /// Section 7A: advances the order's single lifecycle one step (or
  /// cancels a not-yet-shipped order with a reason).
  Future<void> transitionOrder({
    required String orderId,
    required String status,
    String? reason,
  });

  /// Records a cash-on-delivery payment after the order is delivered.
  Future<void> markCodPaid(String orderId);

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
