import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/failures.dart';
import '../../data/repository/cart_repository_impl.dart';
import '../../domain/entities/cart_coupon.dart';

part 'cart_coupon_controller.g.dart';

/// Cart voucher state (DESIGN.md §5.1.3): locally-held previews validated
/// against the server. Display-only — checkout re-validates authoritatively
/// at order placement (§53), so this state never leaves the cart surface.
@riverpod
class CartCouponController extends _$CartCouponController {
  @override
  List<CartCoupon> build() => const [];

  /// Validates and appends a voucher. Invalid codes are surfaced through
  /// the returned message so the UI can show inline feedback.
  Future<String?> apply(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return 'Enter a voucher code';
    if (state.any((coupon) => coupon.code == trimmed)) {
      return 'Voucher already applied';
    }
    try {
      final preview =
          await ref.read(cartRepositoryProvider).validateCoupon(trimmed);
      if (!preview.valid) {
        return preview.message ?? 'Invalid voucher';
      }
      state = [...state, preview];
      return null;
    } on Failure catch (error) {
      return error.message;
    }
  }

  void remove(String code) {
    state = state.where((coupon) => coupon.code != code).toList();
  }

  /// Sum of applied voucher discounts — a display preview only.
  int get discountMinorTotal =>
      state.fold(0, (sum, coupon) => sum + coupon.discountMinor);
}
