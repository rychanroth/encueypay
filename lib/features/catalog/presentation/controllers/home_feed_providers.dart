import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_sort.dart';

part 'home_feed_providers.g.dart';

/// Home feed sections (banners, newest products). Plain
/// one-shot fetches — controllers MAY call the repository directly
/// (DOMAIN-03).
@riverpod
Future<List<CatalogBanner>> homeBanners(Ref ref) async {
  return ref.watch(catalogRepositoryProvider).fetchApprovedBanners();
}

/// New arrivals (DESIGN.md §5.1.1): the qualification rule is a 14-day
/// recency window, active status, and positive stock — merchandising-
/// eligible products only (§2d keeps the Unavailable badge for catalog
/// surfaces). Deterministic: newest first with an id tiebreak (repo).
@riverpod
Future<List<Product>> homeProducts(Ref ref) async {
  return ref.watch(catalogRepositoryProvider).fetchProducts(
        sort: ProductSort.newest,
        limit: 8,
        offset: 0,
        createdAfter: DateTime.now().toUtc().subtract(const Duration(days: 14)),
        activeOnly: true,
        inStockOnly: true,
      );
}

