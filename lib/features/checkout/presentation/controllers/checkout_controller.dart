import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/checkout_repository_impl.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/place_order.dart';
import '../states/checkout_state.dart';

part 'checkout_controller.g.dart';

/// Multi-step checkout (Section 6b — assignment §6 sequence): Cart review →
/// Address → Shipping method → Payment → Coupon → Order note → Summary.
/// Selection state is presentation state (no optimistic persistence);
/// placement stays an atomic use case (DOMAIN-02).
@riverpod
class CheckoutController extends _$CheckoutController {
  static const _stepCount = 7;

  @override
  Future<CheckoutState> build() async {
    final repository = ref.watch(checkoutRepositoryProvider);
    final addresses = await repository.fetchMyAddressOptions();
    final summary = await repository.fetchMySummary();
    // The first address is the user's default (repository ordering, §6b).
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

  void setNote(String note) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(note: note));
  }

  /// Step navigation. [next] is blocked when the current step is invalid
  /// (e.g. no address chosen) — the screen surfaces the reason.
  void goToStep(int step) {
    final current = state.value;
    if (current == null) return;
    if (step < 0 || step >= _stepCount) return;
    state = AsyncData(current.copyWith(currentStep: step));
  }

  bool canContinue() {
    final current = state.value;
    if (current == null) return false;
    return switch (current.currentStep) {
      // Address step requires a selection.
      1 => current.selectedAddressId != null,
      _ => true,
    };
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
        note: current.note,
      );
      return current;
    });
    return orderId;
  }
}
