import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/failures.dart';
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
    state = AsyncData(
      current.copyWith(selectedAddressId: addressId, placementError: null),
    );
  }

  void setMethod(PaymentMethod method) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(method: method, placementError: null));
  }

  void setNote(String note) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(note: note, placementError: null));
  }

  /// Validates a code and replaces/append its server preview. Returns null
  /// only when the code is already applied **and valid**; a previously
  /// rejected code is re-validated so the admin/user can fix a cart and try
  /// again.
  Future<CouponPreview?> applyCoupon(String code) async {
    final current = state.value;
    if (current == null) return null;
    final normalized = code.trim().toUpperCase();
    if (current.coupons.any(
      (coupon) => coupon.code.toUpperCase() == normalized && coupon.valid,
    )) {
      return null;
    }
    final preview = await ref
        .read(checkoutRepositoryProvider)
        .validateCoupon(code);
    final coupons = [
      for (final coupon in current.coupons)
        if (coupon.code.toUpperCase() != normalized) coupon,
      preview,
    ];
    state = AsyncData(current.copyWith(coupons: coupons, placementError: null));
    return preview;
  }

  /// Refreshes the address list after the inline address form returns,
  /// preserving note/coupons/payment. Keeps the current selection when it
  /// still exists; otherwise selects the first (default) address.
  Future<Object?> refreshAddresses() async {
    final current = state.value;
    if (current == null) return null;
    final result = await AsyncValue.guard(
      () => ref.read(checkoutRepositoryProvider).fetchMyAddressOptions(),
    );
    if (result.hasError) return result.error;
    final addresses = result.value;
    if (addresses == null) return null;
    final selected = addresses.any(
      (address) => address.id == current.selectedAddressId,
    )
        ? current.selectedAddressId
        : addresses.isEmpty
            ? null
            : addresses.first.id;
    state = AsyncData(
      current.copyWith(
        addresses: addresses,
        selectedAddressId: selected,
        placementError: null,
      ),
    );
    return null;
  }

  /// Removes a code (valid or rejected) and lets the totals preview refetch
  /// without it.
  void removeCoupon(String code) {
    final current = state.value;
    if (current == null) return;
    final normalized = code.trim().toUpperCase();
    state = AsyncData(
      current.copyWith(
        coupons: [
          for (final coupon in current.coupons)
            if (coupon.code.toUpperCase() != normalized) coupon,
        ],
        placementError: null,
      ),
    );
  }

  /// Returns the new order id, or null when placement failed. A placement
  /// failure keeps the form state alive and records a transient
  /// [CheckoutState.placementError] — never an AsyncError that would replace
  /// the whole checkout and discard the note/coupons/address choices.
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
    state = AsyncData(current.copyWith(isPlacing: true, placementError: null));
    String? orderId;
    final result = await AsyncValue.guard(() async {
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
      return latest.copyWith(isPlacing: false, placementError: null);
    });
    if (result.hasError) {
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(
          isPlacing: false,
          placementError: userMessageFor(result.error!),
        ),
      );
      return null;
    }
    state = result;
    return orderId;
  }
}
