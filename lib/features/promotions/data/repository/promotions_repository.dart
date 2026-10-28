import '../../domain/entities/promotion.dart';

/// Promotions contract (spec §58 Promotions ops; §5b redesign) (DATA-03).
abstract interface class IPromotionsRepository {
  /// All promotions — admin only, enforced server-side (§35.4).
  Future<List<MyPromotion>> fetchAllPromotions();

  /// All banners — admin moderation view.
  Future<List<ManagedBanner>> fetchAllBanners();

  /// Active brands for the coupon-scope picker (Section 2d) and the banner
  /// destination picker (Section 9).
  Future<List<PromoBrandRef>> fetchActiveBrands();

  /// All categories for the banner destination picker (Section 9). Categories
  /// carry no status — the picker offers every row; targeting a parent
  /// category includes its children in Discovery.
  Future<List<PromoCategoryRef>> fetchCategories();

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

  /// Section 9: display-only home banner (inert imagery — targeted banners
  /// are campaigns). Uploads the image, then registers it via the admin RPC.
  Future<void> createBanner({
    required String name,
    required String description,
    required String filePath,
    required String fileName,
  });

  /// New campaign (2026-10-28, Option A): one atomic call creating the
  /// promotion, an auto-applied coupon, and the approved Home banner whose
  /// Discovery target derives from the promotion's scope. Uploads the
  /// image, then registers the bundle. Returns the generated coupon code.
  Future<String> createCampaign({
    required String name,
    required String description,
    required String filePath,
    required String fileName,
    required PromoDiscountType discountType,
    required int discountValue,
    int minOrderAmountMinor = 0,
    DateTime? startsAt,
    DateTime? endsAt,
    String? brandId,
  });

  /// Promotion-level kill switch (2026-10-28): deactivates the rule (chip
  /// + auto-apply stop matching); per-coupon control remains separate.
  Future<void> setPromotionActive({
    required String promotionId,
    required bool active,
  });

  Future<void> moderateBanner({
    required String promotionId,
    required String action,
  });

  Future<void> setCouponActive({required String couponId, required bool active});
}
