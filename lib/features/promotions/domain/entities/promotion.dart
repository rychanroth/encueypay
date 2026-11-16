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

    /// Set only by the dedicated archive action (`admin_set_sale_archived`).
    DateTime? archivedAt,
  }) = _ManagedSale;

  const ManagedSale._();

  /// `ends_at` is inclusive in SQL; at the boundary the sale no longer prices
  /// anything, so equal-to-now counts as expired.
  bool isExpiredAt(DateTime now) =>
      endsAt != null && !endsAt!.toUtc().isAfter(now.toUtc());

  /// Archived = deliberately retired. Disabling a sale is NOT archiving: a
  /// disabled sale stays in the admin list and can be switched back on.
  bool isArchivedAt(DateTime now) => archivedAt != null;

  /// The one word the admin list shows: Archived | Ended | Disabled |
  /// Scheduled | Live.
  String statusLabel(DateTime now) {
    if (archivedAt != null) return 'Archived';
    if (isExpiredAt(now)) return 'Ended';
    if (!active) return 'Disabled';
    if (startsAt != null && startsAt!.toUtc().isAfter(now.toUtc())) {
      return 'Scheduled';
    }
    return 'Live';
  }

  /// Dimmed when it is not currently pricing anything.
  bool isLiveAt(DateTime now) =>
      active && !isExpiredAt(now) &&
      (startsAt == null || !startsAt!.toUtc().isAfter(now.toUtc()));
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

    /// Set only by the dedicated archive action (`admin_set_coupon_archived`).
    DateTime? archivedAt,
  }) = _ManagedCoupon;

  /// `ends_at` is inclusive in SQL; at the boundary the code is no longer
  /// usable, so equal-to-now counts as expired.
  bool isExpiredAt(DateTime now) =>
      endsAt != null && !endsAt!.toUtc().isAfter(now.toUtc());

  /// Archived = deliberately retired. Disabling a code is NOT archiving: a
  /// disabled coupon stays in the admin list and can be switched back on.
  bool isArchivedAt(DateTime now) => archivedAt != null;

  /// The one word the admin list shows: Archived | Expired | Disabled |
  /// Scheduled | Live.
  String statusLabel(DateTime now) {
    if (archivedAt != null) return 'Archived';
    if (isExpiredAt(now)) return 'Expired';
    if (!active) return 'Disabled';
    if (startsAt != null && startsAt!.toUtc().isAfter(now.toUtc())) {
      return 'Scheduled';
    }
    return 'Live';
  }
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
