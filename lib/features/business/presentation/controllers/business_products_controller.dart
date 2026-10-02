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
    Map<String, VariantDraft> variantEdits = const {},
    List<VariantDraft> newVariants = const [],
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
      // If a variant/image step fails after the product update, the error
      // surfaces via the guard; the product (and earlier steps) persist and
      // can be fixed through the edit form.
      for (final entry in variantEdits.entries) {
        await repository.updateProductVariant(
          variantId: entry.key,
          name: entry.value.name,
          priceMinor: entry.value.priceMinor,
        );
      }
      for (final draft in newVariants) {
        await repository.addProductVariant(
          productId: productId,
          name: draft.name,
          priceMinor: draft.priceMinor,
        );
      }
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

  /// Renames/reprices an existing variant and refreshes the list. A failure
  /// surfaces through the guard (e.g. duplicate variant name).
  Future<void> updateVariant({
    required String variantId,
    required String name,
    required int? priceMinor,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).updateProductVariant(
            variantId: variantId,
            name: name,
            priceMinor: priceMinor,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  /// Replaces a variant's image and refreshes the list. Returns the stored
  /// path + public URL so the caller can update local state in place; null
  /// on failure (surfaces through the guard/SnackBar). The previous image
  /// object is removed best-effort.
  Future<(String, String)?> updateVariantImage({
    required String variantId,
    required String filePath,
    required String fileName,
    String? previousPath,
  }) async {
    final current = state.value ?? const <BusinessProduct>[];
    (String, String)? updated;
    state = await AsyncValue.guard(() async {
      updated = await ref.read(businessRepositoryProvider).updateVariantImage(
            variantId: variantId,
            filePath: filePath,
            fileName: fileName,
            previousPath: previousPath,
          );
      ref.invalidateSelf();
      return current;
    });
    return updated;
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
