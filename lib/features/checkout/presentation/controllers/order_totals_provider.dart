import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/checkout_repository_impl.dart';
import '../../domain/entities/coupon_preview.dart';
import '../../domain/entities/order_totals_preview.dart';
import 'checkout_controller.dart';

part 'order_totals_provider.g.dart';

/// Authoritative order totals for the checkout summary: the sale-applied
/// subtotal plus the manually entered codes. Rebuilt whenever the applied
/// coupons change; the placement RPC re-validates everything server-side
/// regardless.
@riverpod
Future<OrderTotalsPreview> orderTotalsPreview(Ref ref) async {
  // Watching the whole controller: the preview refetches on any checkout
  // state emit (cheap RPC; the placement re-validates authoritatively).
  final coupons = ref.watch(checkoutControllerProvider).value?.coupons ??
      const <CouponPreview>[];
  final codes = coupons
      .where((coupon) => coupon.valid)
      .map((coupon) => coupon.code)
      .toList();
  return ref
      .watch(checkoutRepositoryProvider)
      .previewOrderTotals(couponCodes: codes);
}
