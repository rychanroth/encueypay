import '../../domain/entities/promotion.dart';

/// Promotions contract (spec §58 Promotions ops; §5b redesign) (DATA-03).
abstract interface class IPromotionsRepository {
  /// Own promotions (business or admin creator).
  Future<List<MyPromotion>> fetchMyPromotions();

  /// All promotions — admin only, enforced server-side (§35.4).
  Future<List<MyPromotion>> fetchAllPromotions();

  /// Own banners (business submission tracking; Section 5b table).
  Future<List<ManagedBanner>> fetchMyBanners();

  /// All banners — admin moderation view.
  Future<List<ManagedBanner>> fetchAllBanners();

  /// Active brands for the coupon-scope picker (Section 2d).
  Future<List<PromoBrandRef>> fetchActiveBrands();

  Future<void> createCouponPromotion({
    required String name,
    required String description,
    required PromoDiscountType discountType,
    required int discountValue,
    required String code,
    DateTime? expiresAt,
  });

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
