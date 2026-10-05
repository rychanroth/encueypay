import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/brand.dart';

part 'brands_provider.g.dart';

/// Active brands for discovery filters (assignment §2). Plain one-shot fetch
/// consumed directly by the controller (DOMAIN-03).
@riverpod
Future<List<Brand>> brands(Ref ref) async {
  return ref.watch(catalogRepositoryProvider).fetchBrands();
}
