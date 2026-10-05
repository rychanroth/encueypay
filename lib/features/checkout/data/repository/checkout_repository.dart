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
    String note = '',
  });

  // -------------------------------------------------- QR payment (§6b)
  /// The admin-configured Bakong account that receives QR payments
  /// ('' when unconfigured — the checkout shows QR as unavailable).
  Future<String> fetchQrAccountId();

  /// Registers the generated KHQR payload against the order's pending QR
  /// payment (the MD5 key is computed server-side from the payload).
  Future<void> registerQrPayment({
    required String orderId,
    required String payload,
  });

  /// Realtime stream of the order's payment row (status/QR payload) —
  /// `payments` is a publication member (0038).
  Stream<Map<String, dynamic>?> streamOrderPayment(String orderId);

  /// Asks the `bakong-check` Edge Function to check the transaction (the
  /// Bakong confirmation path — polling, not push). Returns null when the
  /// function is unreachable.
  Future<bool?> checkBakongPayment(String orderId);
}
