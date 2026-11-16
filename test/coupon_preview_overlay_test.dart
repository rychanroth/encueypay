import 'package:encueypay/features/checkout/domain/entities/coupon_preview.dart';
import 'package:flutter_test/flutter_test.dart';

/// The applied-coupon bar overlays `preview_order_totals` on the validated
/// preview. `preview_order_totals` reports applied codes as
/// `{code, discount_minor}` only (no `valid` flag), so the overlay must
/// refresh the money and leave validity alone — a successful apply used to
/// render as a failed coupon.
void main() {
  CouponPreview applied() => const CouponPreview(
        code: 'WELCOME10',
        valid: true,
        name: 'Welcome 10',
        discountType: CouponDiscountType.percent,
        discountValue: 10,
        discountMinor: 500,
      );

  test('refreshes the discount without touching validity or metadata', () {
    final merged =
        applied().withPreviewDiscount(800, previewLoaded: true);

    expect(merged.valid, isTrue);
    expect(merged.discountMinor, 800);
    expect(merged.name, 'Welcome 10');
    expect(merged.offerLabel, '10% off');
  });

  test('keeps the validated preview while totals are loading', () {
    final merged = applied().withPreviewDiscount(null, previewLoaded: false);

    expect(merged, applied());
  });

  test('marks the code invalid only when the loaded preview drops it', () {
    final merged = applied().withPreviewDiscount(null, previewLoaded: true);

    expect(merged.valid, isFalse);
    expect(merged.reason, isNull);
    expect(merged.message, isNull);
    // The code and its offer stay readable for the "not applicable" row.
    expect(merged.code, 'WELCOME10');
    expect(merged.name, 'Welcome 10');
  });
}
