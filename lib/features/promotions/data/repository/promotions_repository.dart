import '../../domain/entities/promotion.dart';

/// Promotions contract (spec §58 Promotions ops; §5b redesign) (DATA-03).
abstract interface class IPromotionsRepository {
  /// All promotions — admin only, enforced server-side (§35.4).
  Future<List<MyPromotion>> fetchAllPromotions();

  /// All banners — admin moderation view.
  Future<List<ManagedBanner>> fetchAllBanners();

  /// Active brands for the coupon-scope picker (Section 2d).
  Future<List<PromoBrandRef>> fetchActiveBrands();

  /// Atomic admin creation (Section 5b): the promotion (rule + scope) and
  /// its first coupon (code, min order, window) in one call. Platform-wide
  /// when [brandId] is null, brand-wide otherwise.
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
  });

  Future<void> moderateBanner({
    required String promotionId,
    required String action,
  });

  Future<void> setCouponActive({required String couponId, required bool active});
}
