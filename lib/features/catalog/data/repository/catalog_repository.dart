import '../../domain/entities/banner.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_detail.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_sort.dart';

/// Catalog discovery contract (spec §32, §58 Catalog ops) (DATA-03).
abstract interface class ICatalogRepository {
  Future<List<Category>> fetchCategories();

  /// Active brands for discovery filters (assignment §2).
  Future<List<Brand>> fetchBrands();

  Future<List<Business>> fetchBusinesses({int limit = 10});

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
  });

  Future<ProductDetail> fetchProductDetail(String productId);

  Future<List<Product>> fetchRelatedProducts({
    required String categoryId,
    required String excludeProductId,
    int limit = 6,
  });

  Future<BusinessDetail> fetchBusinessDetail(String businessId);

  /// Approved banner feed for the home screen (§27).
  Future<List<CatalogBanner>> fetchApprovedBanners({int limit = 5});
}
