/// Promotions & coupons (spec §24–§27). Business coupons need no approval;
/// banners require admin moderation. Slim management view.
class MyPromotion {
  const MyPromotion({
    required this.id,
    required this.name,
    required this.description,
    required this.scope,
    required this.discountType,
    required this.discountValue,
    required this.isBanner,
    required this.bannerStatus,
    required this.coupons,
    this.bannerUrl,
    this.endsAt,
  });

  final String id;
  final String name;
  final String description;
  final PromotionScope scope;
  final PromoDiscountType discountType;
  final int discountValue;

  /// Banner promotions carry an image and an approval workflow; coupon
  /// promotions carry coupons.
  final bool isBanner;
  final BannerStatus bannerStatus;
  final String? bannerUrl;
  final DateTime? endsAt;
  final List<MyCoupon> coupons;
}

class MyCoupon {
  const MyCoupon({
    required this.id,
    required this.code,
    required this.active,
    this.expiresAt,
  });

  final String id;
  final String code;
  final bool active;
  final DateTime? expiresAt;
}

enum PromotionScope {
  business,
  platform;

  static PromotionScope fromName(String? name) =>
      PromotionScope.values.asNameMap()[name] ?? PromotionScope.business;
}

enum PromoDiscountType {
  fixed,
  percent;

  String get wireName => name;

  static PromoDiscountType fromName(String? name) =>
      PromoDiscountType.values.asNameMap()[name] ?? PromoDiscountType.fixed;
}

enum BannerStatus {
  none,
  pending,
  approved,
  rejected,
  disabled;

  static BannerStatus fromName(String? name) =>
      BannerStatus.values.asNameMap()[name] ?? BannerStatus.none;
}
