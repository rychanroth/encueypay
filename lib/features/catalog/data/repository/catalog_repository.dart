import '../../domain/entities/banner.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/business_detail.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_sort.dart';

/// Catalog discovery contract (spec §32, §58 Catalog ops) (DATA-03).
abstract interface class ICatalogRepository {
  Future<List<Category>> fetchCategories();

  Future<List<Business>> fetchBusinesses({int limit = 10});

  /// Search/filter/sort with offset pagination (server-authoritative —
  /// the client never trusts previously fetched prices/stock at checkout).
  Future<List<Product>> fetchProducts({
    String? query,
    String? categoryId,
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
