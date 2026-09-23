import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/checkout_repository_impl.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/place_order.dart';
import '../states/checkout_state.dart';

part 'checkout_controller.g.dart';

@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  Future<CheckoutState> build() async {
    final repository = ref.watch(checkoutRepositoryProvider);
    final addresses = await repository.fetchMyAddressOptions();
    final summary = await repository.fetchMySummary();
    return CheckoutState(
      addresses: addresses,
      selectedAddressId: addresses.isEmpty ? null : addresses.first.id,
      summary: summary,
      method: PaymentMethod.cod,
    );
  }

  void selectAddress(String addressId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(selectedAddressId: addressId));
  }

  void setMethod(PaymentMethod method) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(method: method));
  }

  Future<bool> applyCoupon(String code) async {
    final current = state.value;
    if (current == null) return false;
    if (current.coupons.any((coupon) => coupon.code == code)) {
      return false; // already applied
    }
    final preview = await ref.read(checkoutRepositoryProvider).validateCoupon(code);
    final coupons = List<CouponPreview>.from(current.coupons)..add(preview);
    state = AsyncData(current.copyWith(coupons: coupons));
    return preview.valid;
  }

  /// Returns the new order id, or null when validation/place failed
  /// (failure surfaces via the state's AsyncError for the screen to show).
  Future<String?> placeOrder() async {
    final current = state.value;
    if (current == null || current.selectedAddressId == null) return null;
    String? orderId;
    state = await AsyncValue.guard(() async {
      orderId = await ref.read(placeOrderUseCaseProvider)(
        addressId: current.selectedAddressId!,
        method: current.method,
        couponCodes: current.coupons
            .where((coupon) => coupon.valid)
            .map((coupon) => coupon.code)
            .toList(),
      );
      return current;
    });
    return orderId;
  }
}
