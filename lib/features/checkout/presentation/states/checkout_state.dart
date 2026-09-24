import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/address_option.dart';
import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/payment_method.dart';

part 'checkout_state.freezed.dart';

/// Immutable checkout state (PRES-02; ==/copyWith via freezed).
@freezed
abstract class CheckoutState with _$CheckoutState {
  const factory CheckoutState({
    @Default([]) List<AddressOption> addresses,
    String? selectedAddressId,
    CheckoutSummary? summary,
    @Default(PaymentMethod.cod) PaymentMethod method,
    @Default([]) List<CouponPreview> coupons,
  }) = _CheckoutState;

  const CheckoutState._();

  int get discountPreviewMinor => coupons
      .where((coupon) => coupon.valid)
      .fold<int>(0, (sum, coupon) => sum + coupon.discountMinor);

  int get totalPreviewMinor {
    final summary = this.summary;
    if (summary == null) return 0;
    return summary.totalMinor - discountPreviewMinor;
  }
}
