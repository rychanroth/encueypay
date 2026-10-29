import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/domain/money.dart';

part 'active_promo.freezed.dart';

/// Where an active promotion applies (catalog-local vocabulary — the
/// promotions feature's entities never leave their feature, ARCH-04).
enum CatalogPromoScope { platform, brand }

/// How a promotion discounts: percent off, or a fixed minor-unit amount
/// (`discount_type` on the wire).
enum CatalogPromoType { percent, fixed }

/// An active, coupon-backed promotion surfaced as a merchandising chip
/// (Section 9). Display-only: the order RPCs remain the only discount
/// authority under the coupons-only pricing model.
@freezed
abstract class ActivePromo with _$ActivePromo {
  const factory ActivePromo({
    required CatalogPromoScope scope,
    required CatalogPromoType discountType,
    required int discountValue,
    String? brandId,

    /// The bound coupon's minimum-order gate (0 = none). Display-only: the
    /// chip discloses it; it never gates the rendered price (see
    /// [rendersPerProduct]).
    @Default(0) int minOrderMinor,
  }) = _ActivePromo;

  const ActivePromo._();

  /// Whether a per-product discounted price may be rendered from this promo.
  /// Percent campaigns yes; fixed amounts no — "$5 off" is an order-level
  /// fact no per-product price can carry. Minimum-order campaigns also
  /// render: applicability depends on the whole cart, not the item (a $400
  /// item clears any minimum alone; ten $6 items can too), so a per-item
  /// gate would be wrong in the other direction. Checkout stays the
  /// authority; [chipLabel] discloses the minimum.
  bool get rendersPerProduct => discountType == CatalogPromoType.percent;

  /// Discounted price matching the order RPCs' truncating integer math
  /// ((base * value) / 100). Per-item discounts can sum ±1 minor off the
  /// whole-cart computation — the checkout preview is authoritative.
  int discountedMinor(int priceMinor) =>
      priceMinor - (priceMinor * discountValue) ~/ 100;

  /// Chip label — `13% OFF`, `$5.00 OFF`, with the coupon's minimum appended
  /// when one exists (`15% OFF · min $20.00`) so a gated campaign's badge
  /// carries its own terms.
  String get chipLabel {
    final minSuffix = minOrderMinor > 0
        ? ' · min ${Money(minOrderMinor).formatUsd()}'
        : '';
    return switch (discountType) {
      CatalogPromoType.percent => '$discountValue% OFF$minSuffix',
      CatalogPromoType.fixed => '${Money(discountValue).formatUsd()} OFF',
    };
  }
}
