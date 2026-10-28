import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_products_controller.freezed.dart';
part 'admin_products_controller.g.dart';

/// Catalog inventory filter chips (DESIGN.md §5.2.2).
enum AdminProductsFilter { all, lowStock, outOfStock }

/// UI filter state for the admin products list (PRES-02) — the list itself
/// is capped at prototype scale, so filtering is client-side.
@freezed
abstract class AdminProductsState with _$AdminProductsState {
  const factory AdminProductsState({
    @Default(AdminProductsFilter.all) AdminProductsFilter filter,
  }) = _AdminProductsState;
}

@riverpod
class AdminProductsFilterController extends _$AdminProductsFilterController {
  @override
  AdminProductsState build() => const AdminProductsState();

  void setFilter(AdminProductsFilter filter) =>
      state = state.copyWith(filter: filter);
}

/// Admin product catalog (Section 2b, spec §8 "manages Products"): all
/// statuses, name search, archive/activate, and the draft mutations backing
/// the product form. List is capped at 100 rows — prototype scale.
@riverpod
class AdminProductsController extends _$AdminProductsController {
  @override
  Future<List<AdminProductSummary>> build(String? query) async {
    return ref.watch(adminRepositoryProvider).fetchProducts(query: query);
  }

  /// Quick inline stock adjustment (§5.2.2) — persist-then-invalidate
  /// (PRES-03); the server rejects negatives.
  Future<void> adjustStock({
    required String productId,
    required int newStock,
  }) async {
    final current = state.value ?? const <AdminProductSummary>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .adjustProductStock(productId: productId, newStock: newStock);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> setArchived({
    required String productId,
    required bool archived,
  }) async {
    final current = state.value ?? const <AdminProductSummary>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .setProductArchived(productId: productId, archived: archived);
      ref.invalidateSelf();
      return current;
    });
  }

  /// Creates the product and then registers each picked image. Variant
  /// image picks upload first — the create payload carries their storage
  /// paths. Returns the new product id (the caller navigates or resets).
  Future<void> createWithImages({
    required AdminProductDraft draft,
    required List<String> imageFilePaths,
  }) async {
    final current = state.value ?? const <AdminProductSummary>[];
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final resolvedVariants = <AdminProductVariantDraft>[];
      for (final variant in draft.variants) {
        final local = variant.imageLocalPath;
        if (local == null) {
          resolvedVariants.add(variant);
          continue;
        }
        final imagePath = await repo.uploadVariantImage(filePath: local);
        resolvedVariants.add(
            variant.copyWith(imagePath: imagePath, imageLocalPath: null));
      }
      final productId = await repo
          .createProduct(draft.copyWith(variants: resolvedVariants));
      for (final path in imageFilePaths) {
        await repo.addProductImage(productId: productId, filePath: path);
      }
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> updateWithImages({
    required AdminProductDraft draft,
    required List<String> newImageFilePaths,
  }) async {
    final current = state.value ?? const <AdminProductSummary>[];
    state = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final resolvedVariants = <AdminProductVariantDraft>[];
      for (final variant in draft.variants) {
        final local = variant.imageLocalPath;
        if (local == null) {
          resolvedVariants.add(variant);
          continue;
        }
        final imagePath = await repo.uploadVariantImage(filePath: local);
        resolvedVariants.add(
            variant.copyWith(imagePath: imagePath, imageLocalPath: null));
      }
      await repo.updateProduct(draft.copyWith(variants: resolvedVariants));
      for (final path in newImageFilePaths) {
        await repo.addProductImage(productId: draft.id!, filePath: path);
      }
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> removeImage({
    required String imageId,
    required String storagePath,
  }) async {
    final current = state.value ?? const <AdminProductSummary>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).removeProductImage(
            imageId: imageId,
            storagePath: storagePath,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}

