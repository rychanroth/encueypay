import 'package:freezed_annotation/freezed_annotation.dart';

import 'coupon_preview.dart';

part 'discount_preview.freezed.dart';

/// Server-authoritative preview of everything that will be discounted at
/// placement: the manually entered codes plus the single best eligible
/// campaign coupon, applied automatically (no code entry needed — the
/// selection mirrors create_order_from_cart).
@freezed
abstract class DiscountPreview with _$DiscountPreview {
  const factory DiscountPreview({
    @Default([]) List<CouponPreview> manual,
    CouponPreview? auto,
    @Default(0) int totalDiscountMinor,
  }) = _DiscountPreview;
}
