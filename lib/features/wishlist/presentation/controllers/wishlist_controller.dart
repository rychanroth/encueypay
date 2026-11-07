import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/wishlist_repository_impl.dart';
import '../../domain/entities/wishlist_item.dart';

part 'wishlist_controller.g.dart';

@riverpod
class WishlistController extends _$WishlistController {
  @override
  Future<List<WishlistItem>> build() async {
    return ref.watch(wishlistRepositoryProvider).fetchMyWishlist();
  }

  /// Optimistic add (PRES-03 ratified exception): the item list updates before
  /// the write so every heart surface reacts immediately. Success reconciles
  /// with server truth; failure restores the previous list and rethrows for
  /// the caller to surface.
  Future<void> add({
    required String productId,
    WishlistItem? optimistic,
  }) async {
    final previous = state.value ?? const <WishlistItem>[];
    if (previous.any((item) => item.productId == productId)) return;

    state = AsyncData([
      optimistic ??
          WishlistItem(
            id: 'optimistic-$productId',
            productId: productId,
            productName: '',
            priceMinor: 0,
            fromPriceMinor: 0,
          ),
      ...previous,
    ]);
    await _mutate(
      () => ref.read(wishlistRepositoryProvider).addItem(productId: productId),
      previous,
    );
  }

  /// Optimistic remove (PRES-03 ratified exception): the row disappears from
  /// every heart surface immediately.
  Future<void> remove({required String productId}) async {
    final previous = state.value ?? const <WishlistItem>[];
    state = AsyncData([
      for (final item in previous)
        if (item.productId != productId) item,
    ]);
    await _mutate(
      () =>
          ref.read(wishlistRepositoryProvider).removeItem(productId: productId),
      previous,
    );
  }

  Future<void> _mutate(
    Future<void> Function() mutation,
    List<WishlistItem> previous,
  ) async {
    try {
      await mutation();
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
