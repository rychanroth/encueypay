import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/catalog/domain/entities/active_sale.dart';
import 'package:encueypay/features/catalog/presentation/controllers/sale_providers.dart';
import 'package:encueypay/features/checkout/domain/entities/coupon_preview.dart';
import 'package:encueypay/features/promotions/data/dtos/promotion_dtos.dart';
import 'package:encueypay/features/promotions/data/mappers/promotion_mapper.dart';
import 'package:encueypay/features/promotions/domain/entities/promotion.dart';

void main() {
  test('SaleDto tolerates null text fields instead of casting', () {
    final sale = SaleDto.fromJson({
      'id': null,
      'name': null,
      'description': null,
      'scope': 'platform',
      'discount_type': 'percent',
      'discount_value': 15,
      'active': true,
      'starts_at': null,
      'ends_at': null,
      'brands': null,
      'categories': null,
    }).toDomain();

    expect(sale.id, '');
    expect(sale.name, '');
    expect(sale.description, '');
    expect(sale.discountValue, 15);
  });

  test('BannerDto tolerates a null image path', () {
    final banner = BannerDto.fromJson({
      'id': null,
      'name': null,
      'image_path': null,
      'status': null,
      'starts_at': null,
      'ends_at': null,
    });

    expect(banner.id, '');
    expect(banner.name, '');
    expect(banner.imagePath, isNull);
  });

  test('CouponDto tolerates null identity fields', () {
    final coupon = CouponDto.fromJson({
      'id': null,
      'name': null,
      'code': null,
      'discount_type': null,
      'discount_value': null,
      'min_order_amount_minor': null,
      'active': null,
      'starts_at': null,
      'ends_at': null,
    });

    expect(coupon.id, '');
    expect(coupon.name, '');
    expect(coupon.code, '');
    expect(coupon.discountValue, 0);
  });

  test('archive is explicit: disabling or expiring never archives', () {
    final now = DateTime.utc(2026, 11, 2, 12);
    ManagedCoupon coupon({
      bool active = true,
      DateTime? startsAt,
      DateTime? endsAt,
      DateTime? archivedAt,
    }) =>
        ManagedCoupon(
          id: 'coupon-1',
          code: 'CODE',
          discountType: PromoDiscountType.fixed,
          discountValue: 200,
          active: active,
          startsAt: startsAt,
          endsAt: endsAt,
          archivedAt: archivedAt,
        );

    // Live / scheduled / disabled / expired all stay in the admin list.
    final live = coupon(endsAt: now.add(const Duration(days: 1)));
    final scheduled = coupon(startsAt: now.add(const Duration(days: 1)));
    final disabled = coupon(active: false);
    final expired = coupon(endsAt: now.subtract(const Duration(seconds: 1)));
    for (final inList in [live, scheduled, disabled, expired]) {
      expect(inList.isArchivedAt(now), isFalse);
    }

    expect(live.statusLabel(now), 'Live');
    expect(scheduled.statusLabel(now), 'Scheduled');
    expect(disabled.statusLabel(now), 'Disabled');
    expect(expired.statusLabel(now), 'Expired');

    // Only the archive action moves a code out of the list.
    final archived = coupon(active: false, archivedAt: now);
    expect(archived.isArchivedAt(now), isTrue);
    expect(archived.statusLabel(now), 'Archived');
  });

  test('sale lifecycle mirrors coupons, with its own words', () {
    final now = DateTime.utc(2026, 11, 2, 12);
    ManagedSale sale({
      bool active = true,
      DateTime? startsAt,
      DateTime? endsAt,
      DateTime? archivedAt,
    }) =>
        ManagedSale(
          id: 'sale-1',
          name: 'Sale',
          scope: SaleScope.platform,
          discountType: PromoDiscountType.percent,
          discountValue: 10,
          active: active,
          startsAt: startsAt,
          endsAt: endsAt,
          archivedAt: archivedAt,
        );

    // Disabling is a status, not retirement: the sale stays listed.
    final disabled = sale(active: false);
    expect(disabled.isArchivedAt(now), isFalse);
    expect(disabled.statusLabel(now), 'Disabled');
    expect(disabled.isLiveAt(now), isFalse);

    final ended = sale(endsAt: now.subtract(const Duration(seconds: 1)));
    expect(ended.isArchivedAt(now), isFalse);
    expect(ended.statusLabel(now), 'Ended');

    final archived = sale(active: false, archivedAt: now);
    expect(archived.isArchivedAt(now), isTrue);
    expect(archived.statusLabel(now), 'Archived');

    expect(sale().statusLabel(now), 'Live');
    expect(
      sale(startsAt: now.add(const Duration(days: 1))).statusLabel(now),
      'Scheduled',
    );
  });

  test('sale matching picks the lowest final price across scopes', () {
    const platform = ActiveSale(
      id: 'platform',
      scope: CatalogSaleScope.platform,
      discountType: CatalogSaleType.percent,
      discountValue: 10,
    );
    const brand = ActiveSale(
      id: 'brand',
      scope: CatalogSaleScope.brand,
      discountType: CatalogSaleType.fixed,
      discountValue: 300,
      brandId: 'brand-1',
    );

    final sale = saleForIds(
      const [platform, brand],
      brandId: 'brand-1',
      priceMinor: 1000,
    );

    expect(sale?.id, 'brand');
    expect(displayPriceMinor(sale, 1000), 700);
  });

  test('sale matching ignores a different brand', () {
    const brand = ActiveSale(
      id: 'brand',
      scope: CatalogSaleScope.brand,
      discountType: CatalogSaleType.percent,
      discountValue: 20,
      brandId: 'brand-1',
    );

    expect(
      saleForIds(const [brand], brandId: 'brand-2', priceMinor: 1000),
      isNull,
    );
  });

  test('coupon offer label keeps percent and fixed units distinct', () {
    const percent = CouponPreview(
      code: 'P20',
      valid: true,
      discountType: CouponDiscountType.percent,
      discountValue: 20,
    );
    const fixed = CouponPreview(
      code: 'F2',
      valid: true,
      discountType: CouponDiscountType.fixed,
      discountValue: 200,
    );

    expect(percent.offerLabel, '20% off');
    expect(fixed.offerLabel, r'$2.00 off');
  });
}
