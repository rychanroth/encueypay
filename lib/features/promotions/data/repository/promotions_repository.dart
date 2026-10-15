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

  /// Section 9: with the business portal removed the admin creates home
  /// banners directly (pending on creation, approved via moderation).
  /// Uploads the image, then registers it via the admin RPC. [targetKind]
  /// selects the Discovery deep-link destination ('none' = inert banner);
  /// brand/category targets must carry a [targetId].
  Future<void> createBanner({
    required String name,
    required String description,
    required String filePath,
    required String fileName,
    DateTime? endsAt,
    BannerTargetKind targetKind = BannerTargetKind.none,
    String? targetId,
    String? targetName,
  });

  Future<void> moderateBanner({
    required String promotionId,
    required String action,
  });

  Future<void> setCouponActive({required String couponId, required bool active});
}
