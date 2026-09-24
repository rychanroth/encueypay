import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion.freezed.dart';

/// Promotions & coupons (spec §24–§27). Business coupons need no approval;
/// banners require admin moderation. Slim management view.
@freezed
abstract class MyPromotion with _$MyPromotion {
  const factory MyPromotion({
    required String id,
    required String name,
    @Default('') String description,
    required PromotionScope scope,
    required PromoDiscountType discountType,
    required int discountValue,
    required bool isBanner,
    required BannerStatus bannerStatus,
    required List<MyCoupon> coupons,
    String? bannerUrl,
    DateTime? endsAt,
  }) = _MyPromotion;
}

@freezed
abstract class MyCoupon with _$MyCoupon {
  const factory MyCoupon({
    required String id,
    required String code,
    required bool active,
    DateTime? expiresAt,
  }) = _MyCoupon;
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
