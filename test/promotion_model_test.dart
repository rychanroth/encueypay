import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/catalog/domain/entities/active_sale.dart';
import 'package:encueypay/features/catalog/presentation/controllers/sale_providers.dart';
import 'package:encueypay/features/checkout/domain/entities/coupon_preview.dart';
import 'package:encueypay/features/promotions/data/dtos/promotion_dtos.dart';
import 'package:encueypay/features/promotions/data/mappers/promotion_mapper.dart';

void main() {
  test('SaleDto tolerates a null description', () {
    final sale = SaleDto.fromJson({
      'id': 'sale-1',
      'name': 'Autumn sale',
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

    expect(sale.description, '');
    expect(sale.discountValue, 15);
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
