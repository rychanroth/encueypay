import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/checkout_repository_impl.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/place_order.dart';
import '../states/checkout_state.dart';

part 'checkout_controller.g.dart';

/// Single-page checkout: the page renders cart review, address, payment,
/// coupon, note and summary together. Selection state is presentation state
/// (no optimistic persistence); placement stays an atomic use case
/// (DOMAIN-02).
@riverpod
class CheckoutController extends _$CheckoutController {
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

  /// Validates a code and appends the server preview. Returns null when the
  /// code is already applied; otherwise the preview carries the offer, the
  /// exact failure reason, and the resulting cart discount.
  Future<CouponPreview?> applyCoupon(String code) async {
    final current = state.value;
    if (current == null) return null;
    if (current.coupons.any((coupon) => coupon.code == code)) {
      return null;
    }
    final preview = await ref
        .read(checkoutRepositoryProvider)
        .validateCoupon(code);
    final coupons = List<CouponPreview>.from(current.coupons)..add(preview);
    state = AsyncData(current.copyWith(coupons: coupons));
    return preview;
  }

  /// Returns the new order id, or null when validation/place failed
  /// (failure surfaces via the state's AsyncError for the screen to show).
  Future<String?> placeOrder() async {
    final current = state.value;
    if (current == null ||
        current.selectedAddressId == null ||
        current.isPlacing) {
      return null;
    }
    // Set the guard before awaiting: AsyncValue.guard's loading state only
    // lands after the RPC completes, so without this a double tap could
    // create two orders.
    state = AsyncData(current.copyWith(isPlacing: true));
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
      final latest = state.value ?? current;
      return latest.copyWith(isPlacing: false);
    });
    return orderId;
  }
}
