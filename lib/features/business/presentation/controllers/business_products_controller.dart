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
    required List<VariantDraft> variants,
    required List<ImagePickDraft> images,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      final repository = ref.read(businessRepositoryProvider);
      final productId = await repository.createProduct(
            categoryId: categoryId,
            name: name,
            description: description,
            basePriceMinor: basePriceMinor,
            variants: variants,
          );
      // If an image step fails after the product exists, the error surfaces
      // via the guard; the product (and earlier images) persist and can be
      // fixed through the edit form.
      for (final image in images) {
        await repository.addProductImage(
          productId: productId,
          filePath: image.filePath,
          fileName: image.fileName,
        );
      }
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
    required List<BusinessProductImage> removedImages,
    required List<ImagePickDraft> newImages,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      final repository = ref.read(businessRepositoryProvider);
      await repository.updateProduct(
            productId: productId,
            categoryId: categoryId,
            name: name,
            description: description,
            basePriceMinor: basePriceMinor,
          );
      for (final image in removedImages) {
        await repository.removeProductImage(
          imageId: image.id,
          storagePath: image.storagePath,
        );
      }
      for (final image in newImages) {
        await repository.addProductImage(
          productId: productId,
          filePath: image.filePath,
          fileName: image.fileName,
        );
      }
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

  /// Adds a variant to an existing product and refreshes the list. A failure
  /// surfaces through the guard (e.g. duplicate variant name).
  Future<void> addVariant({
    required String productId,
    required String name,
    required int? priceMinor,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).addProductVariant(
            productId: productId,
            name: name,
            priceMinor: priceMinor,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  /// Replaces a variant's image (or clears it) and refreshes the list. A
  /// failure surfaces through the guard; the previous image stays if the
  /// swap itself failed.
  Future<void> updateVariantImage({
    required String variantId,
    required String filePath,
    required String fileName,
    String? previousPath,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).updateVariantImage(
            variantId: variantId,
            filePath: filePath,
            fileName: fileName,
            previousPath: previousPath,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> clearVariantImage({
    required String variantId,
    required String previousPath,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).clearVariantImage(
            variantId: variantId,
            previousPath: previousPath,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}
