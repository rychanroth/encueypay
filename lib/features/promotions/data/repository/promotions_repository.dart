import '../../domain/entities/promotion.dart';

/// Admin surface for sales, coupon codes and banners (spec §58 Promotions
/// ops) (DATA-03).
abstract interface class IPromotionsRepository {
  /// All sales — admin only, enforced server-side (§35.4).
  Future<List<ManagedSale>> fetchSales();

  /// All standalone coupon codes — admin only.
  Future<List<ManagedCoupon>> fetchCoupons();

  /// All banners — admin moderation view.
  Future<List<ManagedBanner>> fetchBanners();

  /// Active brands for the sale-scope picker (Section 2d).
  Future<List<PromoBrandRef>> fetchActiveBrands();

  /// All categories for the sale-scope picker (Section 9). Categories carry
  /// no status — the picker offers every row.
  Future<List<PromoCategoryRef>> fetchCategories();

  /// Create a group sale via `admin_create_sale`. When an image is given,
  /// the same call also registers an approved Home banner linked to the
  /// sale (the one-step campaign UX); otherwise the sale ships bannerless.
  Future<void> createSale({
    required String name,
    required String description,
    required SaleScope scope,
    required PromoDiscountType discountType,
    required int discountValue,
    DateTime? startsAt,
    DateTime? endsAt,
    String? brandId,
    String? categoryId,
    String? filePath,
    String? fileName,
  });

  /// Sale kill switch: deactivates the sale (chips, struck prices and
  /// linked banners stop rendering).
  Future<void> setSaleActive({required String saleId, required bool active});

  /// Create a standalone coupon code via `admin_create_coupon` — cart-wide,
  /// stacks on sale prices at checkout.
  Future<void> createCoupon({
    required String name,
    required String code,
    required PromoDiscountType discountType,
    required int discountValue,
    int minOrderAmountMinor = 0,
    DateTime? startsAt,
    DateTime? endsAt,
  });

  /// Section 9: display-only home banner (no sale link — inert imagery).
  /// Uploads the image, then registers it via the admin RPC.
  Future<void> createBanner({
    required String name,
    required String description,
    required String filePath,
    required String fileName,
  });

  Future<void> moderateBanner({
    required String bannerId,
    required String action,
  });

  Future<void> setCouponActive({required String couponId, required bool active});
}
