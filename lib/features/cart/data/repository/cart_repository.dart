import '../../domain/entities/cart_coupon.dart';
import '../../domain/entities/cart_item.dart';

/// Cart contract (spec §8, §58 Shopping ops) (DATA-03). Quantity
/// arithmetic and cart get-or-create happen server-side via RPCs.
abstract interface class ICartRepository {
  Future<List<CartItem>> fetchMyCart();

  Future<void> addItem({required String variantId, required int quantity});

  Future<void> updateQuantity({required String itemId, required int quantity});

  Future<void> removeItem({required String itemId});

  Future<void> clear();

  /// Cart voucher preview (DESIGN.md §5.1.3): server validation of the
  /// code against the live cart — never throws for a logically invalid
  /// coupon; the result carries `valid`/`message`/scope.
  Future<CartCoupon> validateCoupon(String code);
}
