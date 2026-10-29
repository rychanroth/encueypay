import '../../domain/entities/active_promo.dart';
import '../dtos/active_promo_dto.dart';

extension ActivePromoDtoX on ActivePromoDto {
  /// Unknown wire values fall back to nothing — the caller skips them.
  /// [minOrderMinor] comes from the bound coupon (checked in the repository
  /// alongside the window); the promotion row itself carries no gate.
  ActivePromo? toDomain({int minOrderMinor = 0}) {
    final scope = switch (this.scope) {
      'platform' => CatalogPromoScope.platform,
      'brand' => CatalogPromoScope.brand,
      _ => null,
    };
    final type = switch (discountType) {
      'percent' => CatalogPromoType.percent,
      'fixed' => CatalogPromoType.fixed,
      _ => null,
    };
    if (scope == null || type == null) return null;
    return ActivePromo(
      scope: scope,
      discountType: type,
      discountValue: discountValue,
      brandId: brandId,
      minOrderMinor: minOrderMinor,
    );
  }
}
