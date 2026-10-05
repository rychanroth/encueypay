import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/promotions_repository_impl.dart';
import '../../domain/entities/promotion.dart';

part 'admin_promotions_controller.g.dart';

@riverpod
class AdminPromotionsController extends _$AdminPromotionsController {
  @override
  Future<List<MyPromotion>> build() async {
    return ref.watch(promotionsRepositoryProvider).fetchAllPromotions();
  }

  Future<void> createPlatformPromotion({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    int minOrderAmountMinor = 0,
    DateTime? startsAt,
    DateTime? endsAt,
    String? brandId,
  }) async {
    final current = state.value ?? const <MyPromotion>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).createPlatformPromotion(
            name: name,
            description: description,
            discountType: discountType,
            discountValue: discountValue,
            code: code,
            minOrderAmountMinor: minOrderAmountMinor,
            startsAt: startsAt,
            endsAt: endsAt,
            brandId: brandId,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  /// Coupon kill switch (Section 5b): the manual status toggle; date-window
  /// expiry is derived server-side at validation time.
  Future<void> toggleCoupon({
    required String couponId,
    required bool active,
  }) async {
    final current = state.value ?? const <MyPromotion>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(promotionsRepositoryProvider)
          .setCouponActive(couponId: couponId, active: active);
      ref.invalidateSelf();
      return current;
    });
  }
}

/// Banner moderation list (Section 5b — banners are their own table).
@riverpod
class AdminBannersController extends _$AdminBannersController {
  @override
  Future<List<ManagedBanner>> build() async {
    return ref.watch(promotionsRepositoryProvider).fetchAllBanners();
  }

  Future<void> moderate({
    required String bannerId,
    required String action,
  }) async {
    final current = state.value ?? const <ManagedBanner>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).moderateBanner(
            promotionId: bannerId,
            action: action,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}

/// Active brands for the coupon-scope picker (Section 2d).
@riverpod
Future<List<PromoBrandRef>> promoBrands(Ref ref) async {
  return ref.watch(promotionsRepositoryProvider).fetchActiveBrands();
}
