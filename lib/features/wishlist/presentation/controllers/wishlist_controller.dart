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

  Future<void> add({required String productId}) async {
    final current = state.value ?? const <WishlistItem>[];
    state = await AsyncValue.guard(() async {
      await ref.read(wishlistRepositoryProvider).addItem(productId: productId);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> remove({required String productId}) async {
    final current = state.value ?? const <WishlistItem>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(wishlistRepositoryProvider)
          .removeItem(productId: productId);
      ref.invalidateSelf();
      return current;
    });
  }
}
