import '../../domain/entities/wishlist_item.dart';

/// Wishlist contract (spec §38, §58 Shopping ops) (DATA-03).
abstract interface class IWishlistRepository {
  Future<List<WishlistItem>> fetchMyWishlist();

  Future<void> addItem({required String productId});

  Future<void> removeItem({required String productId});
}
