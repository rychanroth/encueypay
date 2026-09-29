import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/entities/business_profile.dart';
import '../../domain/entities/managed_business_order.dart';
import '../../domain/entities/transaction.dart';

/// Business portal contract (spec §58 Business ops) (DATA-03). All
/// authorization is server-side via RLS + RPC ownership checks (§35.2).
abstract interface class IBusinessRepository {
  /// Server-computed analytics for the signed-in business (§58).
  Future<BusinessAnalytics> fetchMyAnalytics();

  /// Realized profit lines (completed orders' net revenue) for [day] —
  /// server-computed, booked at pickup completion (§58).
  Future<List<BusinessTransactionEntry>> fetchBusinessTransactions(DateTime day);

  /// Realtime sync signal (§31/§54): emits whenever this business's orders
  /// change; consumers refetch ground truth.
  Stream<StreamResult<bool>> watchOrderChanges();

  /// null when the business user has not onboarded yet (Phase 6 decision:
  /// onboarding wizard fills the CreateBusiness gap).
  Future<BusinessProfile?> fetchMyBusiness();

  Future<void> createBusiness({
    required String name,
    required String description,
    String? imageUrl,
  });

  Future<void> updateMyBusiness({required String name, required String description});

  /// Uploads a business image and returns its public URL (§48).
  Future<String> uploadBusinessImage({
    required String filePath,
    required String fileName,
  });

  Future<List<CategoryOption>> fetchCategoryOptions();

  Future<List<BusinessProduct>> fetchMyProducts();

  Future<String> createProduct({
    required String categoryId,
    required String name,
    required String description,
    required int basePriceMinor,
    required List<VariantDraft> variants,
  });

  Future<void> updateProduct({
    required String productId,
    required String categoryId,
    required String name,
    required String description,
    required int basePriceMinor,
  });

  Future<void> setProductArchived({required String productId, required bool archived});

  /// Adds a variant to an existing product (edit flow); duplicate names on
  /// the same product are rejected server-side.
  Future<void> addProductVariant({
    required String productId,
    required String name,
    required int? priceMinor,
  });

  /// Renames/reprices an existing variant; duplicate names (excluding the
  /// edited variant) are rejected server-side.
  Future<void> updateProductVariant({
    required String variantId,
    required String name,
    required int? priceMinor,
  });

  /// Uploads the file and sets it as the variant's image (§48); the replaced
  /// object is removed best-effort. Null image → clears the reference.
  Future<void> updateVariantImage({
    required String variantId,
    required String filePath,
    required String fileName,
    String? previousPath,
  });

  Future<void> clearVariantImage({
    required String variantId,
    required String previousPath,
  });

  /// Uploads the file to the product_images bucket and registers a row —
  /// display order is server-computed (append) (§48).
  Future<BusinessProductImage> addProductImage({
    required String productId,
    required String filePath,
    required String fileName,
  });

  /// Deletes the image row, then best-effort removes the storage object.
  Future<void> removeProductImage({
    required String imageId,
    required String storagePath,
  });

  Future<List<ManagedBusinessOrder>> fetchMyBusinessOrders();

  Future<void> transitionBusinessOrder({
    required String businessOrderId,
    required ManagedOrderStatus target,
    String? reason,
  });
}
