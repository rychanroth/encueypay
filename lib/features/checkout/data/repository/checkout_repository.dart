import '../../domain/entities/address_option.dart';
import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/payment_method.dart';

/// Checkout contract (spec §23, §58 Checkout/Coupons/Payment ops) (DATA-03).
abstract interface class ICheckoutRepository {
  Future<List<AddressOption>> fetchMyAddressOptions();

  Future<CheckoutSummary> fetchMySummary();

  /// Server-side coupon preview — never throws for a logically invalid
  /// coupon; the result carries `valid`/`message` (§25).
  Future<CouponPreview> validateCoupon(String code);

  /// Atomic checkout via the create_order_from_cart RPC. Returns the new
  /// order id; throws [Failure] only (§51 — no partial checkout).
  Future<String> placeOrder({
    required String addressId,
    required PaymentMethod method,
    required List<String> couponCodes,
  });
}
