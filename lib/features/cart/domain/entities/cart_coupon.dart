import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_coupon.freezed.dart';

/// Client-side voucher preview for the cart screen (DESIGN.md §5.1.3).
/// Mirrors the `validate_coupon` RPC result — the server stays authoritative
/// and recomputes every amount at checkout.
@freezed
abstract class CartCoupon with _$CartCoupon {
  const factory CartCoupon({
    required String code,
    required bool valid,
    @Default(0) int discountMinor,
    String? message,

    /// `'Platform'` or `'Brand'` — scope recognition chip (§5.1.3). The RPC
    /// returns the raw promotion scope; anything non-brand acts cart-wide in
    /// the 2-role prototype and renders as Platform.
    @Default('Platform') String scopeLabel,
  }) = _CartCoupon;
}
