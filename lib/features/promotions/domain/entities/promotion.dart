import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion.freezed.dart';

/// A group sale — the pricing layer (Section 9): scope-targeted
/// (platform | brand | category), percent or fixed dollar amount, with its
/// own window and kill switch. A sale is what products COST: it needs no
/// code, no minimum order and no stacking; order lines are charged at the
/// sale price server-side.
@freezed
abstract class ManagedSale with _$ManagedSale {
  const factory ManagedSale({
    required String id,
    required String name,
    @Default('') String description,
    required SaleScope scope,
    required PromoDiscountType discountType,
    required int discountValue,
    @Default(true) bool active,
    DateTime? startsAt,
    DateTime? endsAt,
    String? brandName,
    String? categoryName,
  }) = _ManagedSale;

  const ManagedSale._();

  /// `ends_at` is inclusive in SQL; at the boundary the sale no longer prices
  /// anything, so equal-to-now counts as expired.
  bool isExpiredAt(DateTime now) =>
      endsAt != null && !endsAt!.toUtc().isAfter(now.toUtc());

  /// Main admin list = still pricing or scheduled. Archive = switched off or
  /// past its end date. Starting in the future does not archive a sale.
  /// Same lifecycle rule as [ManagedCoupon.isArchivedAt].
  bool isArchivedAt(DateTime now) => !active || isExpiredAt(now);
}

/// A standalone coupon code (assignment §5 attribute set): cart-wide,
/// stacks on top of sale prices at checkout. Carries its own value, window
/// and minimum order — no promotion link.
@freezed
abstract class ManagedCoupon with _$ManagedCoupon {
  const ManagedCoupon._();

  const factory ManagedCoupon({
    required String id,
    @Default('') String name,
    required String code,
    required PromoDiscountType discountType,
    required int discountValue,
    @Default(0) int minOrderAmountMinor,
    @Default(true) bool active,
    DateTime? startsAt,
    DateTime? endsAt,
  }) = _ManagedCoupon;

  /// `ends_at` is inclusive in SQL; at the boundary the code is no longer
  /// usable, so equal-to-now counts as expired.
  bool isExpiredAt(DateTime now) =>
      endsAt != null && !endsAt!.toUtc().isAfter(now.toUtc());

  /// Main admin list = still usable or scheduled. Archive = switched off or
  /// past its end date. Starting in the future does not archive a code.
  bool isArchivedAt(DateTime now) => !active || isExpiredAt(now);
}

/// A promotional banner (Section 5b/§9): the advertising surface and
/// moderation status. A banner may be linked to a sale for its Discovery
/// tap target, but carries no discount of its own.
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

/// Slim brand reference for the sale-scope picker (Section 2d).
@freezed
abstract class PromoBrandRef with _$PromoBrandRef {
  const factory PromoBrandRef({required String id, required String name})
      = _PromoBrandRef;
}

/// Slim category reference for the sale-scope picker (Section 9).
@freezed
abstract class PromoCategoryRef with _$PromoCategoryRef {
  const factory PromoCategoryRef({required String id, required String name})
      = _PromoCategoryRef;
}

enum SaleScope {
  platform,
  brand,
  category;

  String get wireName => name;

  static SaleScope fromName(String? name) =>
      SaleScope.values.asNameMap()[name] ?? SaleScope.platform;
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
