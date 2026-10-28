import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/coupon_preview.dart';
import '../../data/repository/checkout_repository_impl.dart';
import 'checkout_controller.dart';
import '../../domain/entities/discount_preview.dart';

part 'discount_preview_provider.g.dart';

/// Authoritative discount preview for the checkout summary: the manually
/// entered codes plus the single best eligible campaign coupon, which
/// applies automatically at placement (no code entry — user decision
/// 2026-10-28). Rebuilt whenever the applied coupons change; the placement
/// RPC re-validates everything server-side regardless.
@riverpod
Future<DiscountPreview> discountPreview(Ref ref) async {
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
      .previewCartDiscounts(couponCodes: codes);
}
