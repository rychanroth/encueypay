/// Result of the server-side coupon preview (§25). The client may preview;
/// the final amount is recalculated during checkout.
class CouponPreview {
  const CouponPreview({
    required this.code,
    required this.valid,
    this.discountMinor = 0,
    this.message,
  });

  final String code;
  final bool valid;
  final int discountMinor;
  final String? message;
}
