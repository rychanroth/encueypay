import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/business_repository_impl.dart';
import '../../domain/entities/business_profile.dart';

part 'business_products_controller.g.dart';

@riverpod
class BusinessProductsController extends _$BusinessProductsController {
  @override
  Future<List<BusinessProduct>> build() async {
    return ref.watch(businessRepositoryProvider).fetchMyProducts();
  }

  Future<void> create({
    required String categoryId,
    required String name,
    required String description,
    required int basePriceMinor,
    required int stock,
    required List<VariantDraft> variants,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).createProduct(
            categoryId: categoryId,
            name: name,
            description: description,
            basePriceMinor: basePriceMinor,
            stock: stock,
            variants: variants,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> updateProduct({
    required String productId,
    required String categoryId,
    required String name,
    required String description,
    required int basePriceMinor,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).updateProduct(
            productId: productId,
            categoryId: categoryId,
            name: name,
            description: description,
            basePriceMinor: basePriceMinor,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> setArchived({
    required String productId,
    required bool archived,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(businessRepositoryProvider)
          .setProductArchived(productId: productId, archived: archived);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> updateStock({
    required String variantId,
    required int stock,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(businessRepositoryProvider)
          .updateVariantStock(variantId: variantId, stock: stock);
      ref.invalidateSelf();
      return current;
    });
  }
}
