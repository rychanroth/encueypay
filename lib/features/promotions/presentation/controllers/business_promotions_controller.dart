import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/promotions_repository_impl.dart';
import '../../domain/entities/promotion.dart';

part 'business_promotions_controller.g.dart';

@riverpod
class BusinessPromotionsController extends _$BusinessPromotionsController {
  @override
  Future<List<MyPromotion>> build() async {
    return ref.watch(promotionsRepositoryProvider).fetchMyPromotions();
  }

  Future<void> createCoupon({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    DateTime? expiresAt,
  }) async {
    final current = state.value ?? const <MyPromotion>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).createCouponPromotion(
            name: name,
            description: description,
            discountType: discountType,
            discountValue: discountValue,
            code: code,
            expiresAt: expiresAt,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> submitBanner({
    required String name,
    required String description,
    required String filePath,
    required String fileName,
  }) async {
    final current = state.value ?? const <MyPromotion>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).submitBanner(
            name: name,
            description: description,
            filePath: filePath,
            fileName: fileName,
          );
      ref.invalidateSelf();
      return current;
    });
  }

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

/// The business user's submitted banners (Section 5b — separate table).
@riverpod
Future<List<ManagedBanner>> myBanners(Ref ref) async {
  return ref.watch(promotionsRepositoryProvider).fetchMyBanners();
}
