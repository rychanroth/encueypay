import 'package:freezed_annotation/freezed_annotation.dart';

import 'coupon_preview.dart';

part 'order_totals_preview.freezed.dart';

/// Server-authoritative preview of the order the cart produces: the
/// sale-applied subtotal (sales live in the line prices), the stacked code
/// discounts — codes are the only order-level discounts — the delivery fee
/// and the grand total. The placement RPC recomputes the same numbers, so
/// the summary the customer approves is the summary they are charged.
@freezed
abstract class OrderTotalsPreview with _$OrderTotalsPreview {
  const factory OrderTotalsPreview({
    @Default([]) List<CouponPreview> manual,

    /// Codes that no longer qualify after a cart edit — surfaced at checkout
    /// instead of being silently skipped by the preview.
    @Default([]) List<CouponPreview> rejected,
    @Default(0) int subtotalMinor,
    @Default(0) int totalDiscountMinor,
    @Default(0) int deliveryFeeMinor,
    @Default(0) int totalMinor,
  }) = _OrderTotalsPreview;
}
