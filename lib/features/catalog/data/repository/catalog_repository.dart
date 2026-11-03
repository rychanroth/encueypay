import '../../domain/entities/active_sale.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_sort.dart';

/// Catalog discovery contract (spec §32, §58 Catalog ops) (DATA-03).
abstract interface class ICatalogRepository {
  Future<List<Category>> fetchCategories();

  /// Active brands for discovery filters (assignment §2).
  Future<List<Brand>> fetchBrands();

  /// Search/filter/sort with offset pagination (server-authoritative —
  /// the client never trusts previously fetched prices at checkout).
  /// [query] matches product name OR brand name; [brandId] is an exact
  /// brand filter (assignment §2).
  Future<List<Product>> fetchProducts({
    String? query,
    String? categoryId,
    String? brandId,
    ProductSort sort = ProductSort.newest,
    int limit = 20,
    int offset = 0,

    /// New-arrivals qualification (DESIGN.md §5.1.1): only products created
    /// at/after this instant.
    DateTime? createdAfter,

    /// Exclude archived products (they render "Unavailable" in catalog
    /// contexts but a curated shelf is merchandising).
    bool activeOnly = false,

    /// Exclude zero-stock products from curated shelves.
    bool inStockOnly = false,
  });

  Future<ProductDetail> fetchProductDetail(String productId);

  Future<List<Product>> fetchRelatedProducts({
    required String categoryId,
    required String excludeProductId,
    int limit = 6,
  });

  /// Approved banner feed for the home screen (§27).
  Future<List<CatalogBanner>> fetchApprovedBanners({int limit = 5});

  /// Live sales from the `active_sales` view — active and in-window by
  /// definition (the pricing rule lives in SQL). Display mirrors the
  /// server's math; placement re-prices authoritatively.
  Future<List<ActiveSale>> fetchActiveSales();

  /// Platform-wide delivery fee (minor units) from `platform_settings`.
  /// Used by the storefront to state the real fee before checkout.
  Future<int> fetchDeliveryFeeMinor();
}
