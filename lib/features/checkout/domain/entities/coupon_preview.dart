import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_preview.freezed.dart';

/// Result of the server-side coupon preview (§25). The client may preview;
/// the final amount is recalculated during checkout.
@freezed
abstract class CouponPreview with _$CouponPreview {
  const factory CouponPreview({
    required String code,
    required bool valid,
    @Default(0) int discountMinor,
    String? message,

    /// Promotion scope on the wire ('platform' | 'brand') — drives the
    /// scope badge on the applied-coupon tile.
    String? scope,
  }) = _CouponPreview;
}
