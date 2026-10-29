import '../../domain/entities/address_option.dart';
import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/order_totals_preview.dart';
import '../../domain/entities/payment_method.dart';

/// Checkout contract (spec §23, §58 Checkout/Coupons/Payment ops) (DATA-03).
abstract interface class ICheckoutRepository {
  Future<List<AddressOption>> fetchMyAddressOptions();

  Future<CheckoutSummary> fetchMySummary();

  /// Server-side coupon preview — never throws for a logically invalid
  /// coupon; the result carries `valid`/`message` (§25).
  Future<CouponPreview> validateCoupon(String code);

  /// Authoritative totals for the current cart: the sale-applied subtotal,
  /// the stacked code discounts, delivery fee and grand total — the same
  /// numbers create_order_from_cart produces at placement.
  Future<OrderTotalsPreview> previewOrderTotals({
    required List<String> couponCodes,
  });

  /// Atomic checkout via the create_order_from_cart RPC. Returns the new
  /// order id; throws [Failure] only (§51 — no partial checkout).
  Future<String> placeOrder({
    required String addressId,
    required PaymentMethod method,
    required List<String> couponCodes,
    String note = '',
  });

  // -------------------------------------------------- QR payment (§6b)
  /// Creates the PayWay transaction for the order's pending QR payment via
  /// the `payway-create` Edge Function and returns the KHQR string to
  /// render. The function also stores the payload on the payments row, so
  /// the stream delivers it even if this call's result is lost. Signing
  /// and the PayWay credentials live entirely server-side. Throws
  /// [Failure] only (DATA-05) — the message names the failing stage.
  Future<String> createPaywayQr({required String orderId});

  /// Realtime stream of the order's payment row (status/QR payload) —
  /// `payments` is a publication member (0038).
  Stream<Map<String, dynamic>?> streamOrderPayment(String orderId);

  /// One-shot ground-truth fetch of the order's payment row — the fallback
  /// path the payment screen re-fetches on a timer so confirmation still
  /// converges when Realtime is unavailable (e.g. websocket 401s).
  Future<Map<String, dynamic>?> fetchOrderPayment(String orderId);
}
