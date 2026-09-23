import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_sort.dart';

part 'home_feed_providers.g.dart';

/// Home feed sections (newest products + businesses). Plain one-shot
/// fetches — controllers MAY call the repository directly (DOMAIN-03).
@riverpod
Future<List<Product>> homeProducts(Ref ref) async {
  return ref
      .watch(catalogRepositoryProvider)
      .fetchProducts(sort: ProductSort.newest, limit: 10, offset: 0);
}

@riverpod
Future<List<Business>> homeBusinesses(Ref ref) async {
  return ref.watch(catalogRepositoryProvider).fetchBusinesses(limit: 10);
}
