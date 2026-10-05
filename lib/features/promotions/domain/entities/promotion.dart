import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion.freezed.dart';

/// The discount RULE (Section 5b convention): scope + mechanic. Coupons are
/// the redemption instruments referencing it; banners are a separate
/// advertising surface ([ManagedBanner]). [active] is the admin kill switch;
/// the date window lives on the coupon (assignment §5 lists dates on the
/// coupon) and is derived at validation time — no scheduled jobs.
@freezed
abstract class MyPromotion with _$MyPromotion {
  const factory MyPromotion({
    required String id,
    required String name,
    @Default('') String description,
    required PromotionScope scope,
    required PromoDiscountType discountType,
    required int discountValue,
    @Default(true) bool active,
    String? brandName,
    @Default([]) List<MyCoupon> coupons,
  }) = _MyPromotion;
}

/// The redemption instrument (assignment §5 attribute set): code, minimum
/// order amount, start/end window, status. Window violations are derived at
/// validation time.
@freezed
abstract class MyCoupon with _$MyCoupon {
  const factory MyCoupon({
    required String id,
    required String code,
    required bool active,
    @Default(0) int minOrderAmountMinor,
    DateTime? startsAt,
    DateTime? endsAt,
  }) = _MyCoupon;
}

/// A promotional banner (Section 5b): the advertising surface, moderation
/// status, and display window. Carries no discount.
@freezed
abstract class ManagedBanner with _$ManagedBanner {
  const factory ManagedBanner({
    required String id,
    required String name,
    required String imageUrl,
    required BannerStatus status,
    DateTime? startsAt,
    DateTime? endsAt,
  }) = _ManagedBanner;
}

/// Slim brand reference for the coupon-scope picker (Section 2d):
/// platform-wide coupons carry no brand; brand-wide ones target one.
@freezed
abstract class PromoBrandRef with _$PromoBrandRef {
  const factory PromoBrandRef({required String id, required String name})
      = _PromoBrandRef;
}

enum PromotionScope {
  business,
  platform,
  brand;

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
