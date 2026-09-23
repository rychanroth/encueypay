import '../../domain/entities/address_option.dart';
import '../../domain/entities/checkout_summary.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/payment_method.dart';

/// Immutable checkout state (PRES-02).
class CheckoutState {
  const CheckoutState({
    required this.addresses,
    required this.method,
    this.selectedAddressId,
    this.summary,
    this.coupons = const [],
  });

  final List<AddressOption> addresses;
  final String? selectedAddressId;
  final CheckoutSummary? summary;
  final PaymentMethod method;
  final List<CouponPreview> coupons;

  int get discountPreviewMinor => coupons
      .where((coupon) => coupon.valid)
      .fold<int>(0, (sum, coupon) => sum + coupon.discountMinor);

  int get totalPreviewMinor {
    final summary = this.summary;
    if (summary == null) return 0;
    return summary.totalMinor - discountPreviewMinor;
  }

  CheckoutState copyWith({
    List<AddressOption>? addresses,
    String? selectedAddressId,
    CheckoutSummary? summary,
    PaymentMethod? method,
    List<CouponPreview>? coupons,
  }) {
    return CheckoutState(
      addresses: addresses ?? this.addresses,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      summary: summary ?? this.summary,
      method: method ?? this.method,
      coupons: coupons ?? this.coupons,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutState &&
          other.selectedAddressId == selectedAddressId &&
          other.method == method &&
          other.addresses.length == addresses.length &&
          other.coupons.length == coupons.length &&
          other.summary?.items.length == summary?.items.length;

  @override
  int get hashCode => Object.hash(selectedAddressId, method, addresses.length,
      coupons.length, summary?.items.length);
}
