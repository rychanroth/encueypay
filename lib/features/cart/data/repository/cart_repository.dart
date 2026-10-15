import '../../domain/entities/cart_item.dart';

/// Cart contract (spec §8, §58 Shopping ops) (DATA-03). Quantity
/// arithmetic and cart get-or-create happen server-side via RPCs.
/// Coupon validation lives in checkout (step 5 of the §6 sequence).
abstract interface class ICartRepository {
  Future<List<CartItem>> fetchMyCart();

  Future<void> addItem({required String variantId, required int quantity});

  Future<void> updateQuantity({required String itemId, required int quantity});

  Future<void> removeItem({required String itemId});

  Future<void> clear();
}
