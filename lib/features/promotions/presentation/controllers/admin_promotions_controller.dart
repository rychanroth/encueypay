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

  Future<void> moderate({
    required String promotionId,
    required String action,
  }) async {
    final current = state.value ?? const <MyPromotion>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).moderateBanner(
            promotionId: promotionId,
            action: action,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> createPlatformPromotion({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    DateTime? expiresAt,
  }) async {
    final current = state.value ?? const <MyPromotion>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).createPlatformPromotion(
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
}
