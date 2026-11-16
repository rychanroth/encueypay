import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/money.dart';

part 'coupon_preview.freezed.dart';

enum CouponDiscountType {
  fixed,
  percent;

  static CouponDiscountType? fromName(String? name) =>
      CouponDiscountType.values.asNameMap()[name];
}

/// Result of the server-side coupon validation/preview (§25). The server is
/// authoritative; the client renders the offer, requirements and the
/// resulting cart discount from these fields.
@freezed
abstract class CouponPreview with _$CouponPreview {
  const factory CouponPreview({
    required String code,
    required bool valid,
    @Default(0) int discountMinor,
    String? message,
    @Default('') String name,
    CouponDiscountType? discountType,
    @Default(0) int discountValue,
    @Default(0) int minOrderAmountMinor,
    DateTime? startsAt,
    DateTime? endsAt,
    @Default(0) int subtotalMinor,

    /// Structured failure code (`not_found`, `inactive`, `not_started`,
    /// `expired`, `min_order_not_met`, `empty_cart`, `not_authenticated`).
    String? reason,
  }) = _CouponPreview;

  const CouponPreview._();

  /// The offer as configured, independent of the current cart amount.
  String get offerLabel => switch (discountType) {
    CouponDiscountType.percent => '$discountValue% off',
    CouponDiscountType.fixed => '${Money(discountValue).formatUsd()} off',
    null => '',
  };

  /// One row of the applied-coupon bar.
  ///
  /// `validate_coupon` is authoritative for validity, name and the offer
  /// details. `preview_order_totals` only reports `{code, discount_minor}`
  /// for codes that still qualify, so only the money is refreshed from it —
  /// replacing the whole preview with a totals row rendered an applied
  /// coupon as failed (its `valid` flag is absent from that payload).
  ///
  /// [discountMinor] is null when the preview has no row for this code:
  /// either the totals are still loading ([previewLoaded] false — keep the
  /// validated preview) or the code stopped qualifying after a cart edit.
  CouponPreview withPreviewDiscount(
    int? discountMinor, {
    required bool previewLoaded,
  }) {
    if (discountMinor != null) return copyWith(discountMinor: discountMinor);
    if (!previewLoaded) return this;
    return copyWith(valid: false, reason: null, message: null);
  }
}
