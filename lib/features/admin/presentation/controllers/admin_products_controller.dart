import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/picked_file.dart';
import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_products_controller.freezed.dart';
part 'admin_products_controller.g.dart';

/// Applied filter/sort state for the Products tab (PRES-02). Kept separate
/// from the list controller so the screen (and the URL codec) own one source
/// of truth and changing a filter rebuilds exactly one fetch.
@Riverpod(keepAlive: true)
class AdminProductsQueryController extends _$AdminProductsQueryController {
  @override
  AdminProductQuery build() => const AdminProductQuery();

  void update(AdminProductQuery query) {
    if (state == query) return;
    state = query;
  }

  void reset() => update(const AdminProductQuery());
}

/// One page of products plus the full matching totals and the query that
/// produced it.
@freezed
abstract class AdminProductsState with _$AdminProductsState {
  const factory AdminProductsState({
    required AdminProductQuery query,
    @Default(<AdminProductSummary>[]) List<AdminProductSummary> products,
    @Default(0) int totalCount,
    @Default(0) int totalStockValueMinor,
    @Default(false) bool loadingMore,
  }) = _AdminProductsState;

  const AdminProductsState._();

  bool get hasMore => products.length < totalCount;
}

/// Admin product catalog (Section 2b, spec §8 "manages Products"):
/// server-side filtered/sorted/paginated search over every status, with the
/// draft mutations backing the product form.
@riverpod
class AdminProductsController extends _$AdminProductsController {
  static const _pageSize = 25;

  @override
  Future<AdminProductsState> build() async {
    final query = ref.watch(adminProductsQueryControllerProvider);
    final page = await ref
        .read(adminRepositoryProvider)
        .searchProducts(query, limit: _pageSize);
    return AdminProductsState(
      query: query,
      products: page.products,
      totalCount: page.totalCount,
      totalStockValueMinor: page.totalStockValueMinor,
    );
  }

  void refresh() => ref.invalidateSelf();

  /// Appends the next page. On failure the already-loaded rows stay visible
  /// (the screen surfaces the error as a snackbar).
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.loadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page = await ref
          .read(adminRepositoryProvider)
          .searchProducts(
            current.query,
            limit: _pageSize,
            offset: current.products.length,
          );
      final seen = <String>{};
      final merged = [
        for (final product in [...current.products, ...page.products])
          if (seen.add(product.id)) product,
      ];
      state = AsyncData(
        current.copyWith(
          products: merged,
          totalCount: page.totalCount,
          totalStockValueMinor: page.totalStockValueMinor,
          loadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      // Keep the already-loaded rows; the screen surfaces the failure. The
      // error is rethrown so the caller can show a snackbar.
      state = AsyncData(current.copyWith(loadingMore: false));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  /// Every matching product (not just the loaded page) for CSV export.
  Future<List<AdminProductSummary>> fetchAllForExport() async {
    final query = ref.read(adminProductsQueryControllerProvider);
    final page = await ref
        .read(adminRepositoryProvider)
        .searchProducts(query, limit: 5000);
    return page.products;
  }

  /// Fresh read for the edit form. The list row can be stale (an image edit
  /// invalidates asynchronously), and the form seeds its image/variant state
  /// from this snapshot — a plain one-shot fetch (DOMAIN-04).
  Future<AdminProductSummary> fetchProduct(String productId) =>
      ref.read(adminRepositoryProvider).fetchProduct(productId);

  /// Archives/restores each selected product, skipping rows already in the
  /// requested state. Persist-then-invalidate (PRES-03); returns the number
  /// actually changed so the screen can report it.
  Future<int> setArchivedSelected(Set<String> productIds, bool archived) async {
    final products = state.value?.products ?? const <AdminProductSummary>[];
    final repository = ref.read(adminRepositoryProvider);
    var changed = 0;
    for (final product in products) {
      if (!productIds.contains(product.id)) continue;
      final isArchived = product.status == AdminCatalogStatus.archived;
      if (isArchived == archived) continue;
      await repository.setProductArchived(
        productId: product.id,
        archived: archived,
      );
      changed++;
    }
    if (changed > 0) ref.invalidateSelf();
    return changed;
  }

  /// Quick inline stock adjustment (§5.2.2) — persist-then-invalidate
  /// (PRES-03); the server rejects negatives. Returns the failure instead of
  /// replacing the loaded list with an AsyncError, so one network blip does
  /// not wipe the inventory screen.
  Future<Object?> adjustStock({
    required String productId,
    required int newStock,
  }) async {
    final result = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .adjustProductStock(productId: productId, newStock: newStock);
      ref.invalidateSelf();
    });
    return result.hasError ? result.error : null;
  }

  /// Archive/restore keeps the list visible on failure (same rule as stock).
  Future<Object?> setArchived({
    required String productId,
    required bool archived,
  }) async {
    final result = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .setProductArchived(productId: productId, archived: archived);
      ref.invalidateSelf();
    });
    return result.hasError ? result.error : null;
  }

  /// Creates the product and then registers each picked image. Variant
  /// image picks upload first — the create payload carries their storage
  /// paths.
  Future<void> createWithImages({
    required AdminProductDraft draft,
    required List<PickedFile> imagePicks,
  }) async {
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final resolvedVariants = <AdminProductVariantDraft>[];
      for (final variant in draft.variants) {
        final pick = variant.imagePick;
        if (pick == null) {
          resolvedVariants.add(variant);
          continue;
        }
        final imagePath = await repo.uploadVariantImage(image: pick);
        resolvedVariants.add(
          variant.copyWith(imagePath: imagePath, imagePick: null),
        );
      }
      final productId = await repo.createProduct(
        draft.copyWith(variants: resolvedVariants),
      );
      for (final pick in imagePicks) {
        await repo.addProductImage(productId: productId, image: pick);
      }
    });
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return;
    }
    // Persist-then-invalidate (PRES-03). Invalidate only after the mutation
    // settles: assigning a stale state afterwards would shadow the refetch
    // and leave the list (or a just-uploaded image) visually unchanged.
    ref.invalidateSelf();
  }

  Future<void> updateWithImages({
    required AdminProductDraft draft,
    required List<PickedFile> newImagePicks,
  }) async {
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminRepositoryProvider);
      final resolvedVariants = <AdminProductVariantDraft>[];
      for (final variant in draft.variants) {
        final pick = variant.imagePick;
        if (pick == null) {
          resolvedVariants.add(variant);
          continue;
        }
        final imagePath = await repo.uploadVariantImage(image: pick);
        resolvedVariants.add(
          variant.copyWith(imagePath: imagePath, imagePick: null),
        );
      }
      await repo.updateProduct(draft.copyWith(variants: resolvedVariants));
      for (final pick in newImagePicks) {
        await repo.addProductImage(productId: draft.id!, image: pick);
      }
    });
    if (result.hasError) {
      state = AsyncError(result.error!, result.stackTrace!);
      return;
    }
    // Same persist-then-invalidate rule as createWithImages.
    ref.invalidateSelf();
  }

  Future<Object?> removeImage({
    required String imageId,
    required String storagePath,
  }) async {
    final result = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .removeProductImage(imageId: imageId, storagePath: storagePath);
      ref.invalidateSelf();
    });
    return result.hasError ? result.error : null;
  }
}
