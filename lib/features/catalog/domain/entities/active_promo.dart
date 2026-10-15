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
  }) = _ActivePromo;

  const ActivePromo._();

  /// Chip label — `13% OFF` or `$5.00 OFF`.
  String get chipLabel => switch (discountType) {
        CatalogPromoType.percent => '$discountValue% OFF',
        CatalogPromoType.fixed => '${Money(discountValue).formatUsd()} OFF',
      };
}
