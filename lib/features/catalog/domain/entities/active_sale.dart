import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/domain/money.dart';

part 'active_sale.freezed.dart';

/// Where a sale applies (catalog-local vocabulary — the promotions
/// feature's entities never leave their feature, ARCH-04).
enum CatalogSaleScope { platform, brand, category }

/// How a sale discounts: percent off, or a fixed minor-unit amount per
/// unit (`discount_type` on the wire).
enum CatalogSaleType { percent, fixed }

/// A live group sale — the pricing layer (Section 9). A sale is what a
/// product costs, not a cart modifier: no code, no minimum order, no
/// stacking. Display mirrors the server's `best_sale_price_minor()` —
/// placement re-prices authoritatively.
@freezed
abstract class ActiveSale with _$ActiveSale {
  const factory ActiveSale({
    required CatalogSaleScope scope,
    required CatalogSaleType discountType,
    required int discountValue,
    String? brandId,
    String? categoryId,
  }) = _ActiveSale;

  const ActiveSale._();

  /// The price one unit costs under this sale, matching the SQL helper's
  /// integer math: percent truncates ((price × value) / 100), fixed floors
  /// at zero.
  int priceMinorFor(int priceMinor) => switch (discountType) {
        CatalogSaleType.percent =>
          priceMinor - (priceMinor * discountValue) ~/ 100,
        CatalogSaleType.fixed => priceMinor - discountValue < 0
            ? 0
            : priceMinor - discountValue,
      };

  /// Chip label — `15% OFF` or `$3.00 OFF`.
  String get chipLabel => switch (discountType) {
        CatalogSaleType.percent => '$discountValue% OFF',
        CatalogSaleType.fixed => '${Money(discountValue).formatUsd()} OFF',
      };
}
