import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/category.dart';

part 'categories_provider.g.dart';

/// Top-level categories for the home strip. Plain one-shot fetch consumed
/// directly by the controller (DOMAIN-03).
@riverpod
Future<List<Category>> categories(Ref ref) async {
  return ref.watch(catalogRepositoryProvider).fetchCategories();
}
