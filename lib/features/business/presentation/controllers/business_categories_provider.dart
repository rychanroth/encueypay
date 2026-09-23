import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/business_repository_impl.dart';
import '../../domain/entities/business_profile.dart';

part 'business_categories_provider.g.dart';

/// Category options for the product form. Plain one-shot fetch (DOMAIN-03).
@riverpod
Future<List<CategoryOption>> businessCategories(Ref ref) async {
  return ref.watch(businessRepositoryProvider).fetchCategoryOptions();
}
