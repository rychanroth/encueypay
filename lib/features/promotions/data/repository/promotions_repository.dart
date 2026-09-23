import '../../domain/entities/promotion.dart';

/// Promotions contract (spec §58 Promotions ops) (DATA-03).
abstract interface class IPromotionsRepository {
  /// Own promotions (business or admin creator).
  Future<List<MyPromotion>> fetchMyPromotions();

  /// All promotions — admin only, enforced server-side (§35.4).
  Future<List<MyPromotion>> fetchAllPromotions();

  Future<void> createCouponPromotion({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    DateTime? expiresAt,
  });

  Future<void> createPlatformPromotion({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    DateTime? expiresAt,
  });

  /// Uploads the banner image, then submits for approval (§27).
  Future<void> submitBanner({
    required String name,
    required String description,
    required String filePath,
    required String fileName,
    DateTime? endsAt,
  });

  Future<void> moderateBanner({
    required String promotionId,
    required String action,
  });

  Future<void> setCouponActive({required String couponId, required bool active});
}
