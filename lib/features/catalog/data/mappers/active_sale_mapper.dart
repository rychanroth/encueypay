import '../../domain/entities/active_sale.dart';
import '../dtos/active_sale_dto.dart';

extension ActiveSaleDtoX on ActiveSaleDto {
  /// Unknown wire values fall back to nothing — the caller skips them.
  ActiveSale? toDomain() {
    final scope = switch (this.scope) {
      'platform' => CatalogSaleScope.platform,
      'brand' => CatalogSaleScope.brand,
      'category' => CatalogSaleScope.category,
      _ => null,
    };
    final type = switch (discountType) {
      'percent' => CatalogSaleType.percent,
      'fixed' => CatalogSaleType.fixed,
      _ => null,
    };
    if (scope == null || type == null) return null;
    return ActiveSale(
      id: id ?? '',
      scope: scope,
      discountType: type,
      discountValue: discountValue,
      name: name,
      description: description,
      startsAt: startsAt,
      endsAt: endsAt,
      brandId: brandId,
      categoryId: categoryId,
    );
  }
}
