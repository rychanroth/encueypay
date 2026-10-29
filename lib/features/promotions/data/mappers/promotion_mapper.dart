import '../../domain/entities/promotion.dart';
import '../dtos/promotion_dtos.dart';

extension SaleDtoX on SaleDto {
  ManagedSale toDomain() {
    return ManagedSale(
      id: id,
      name: name,
      description: description,
      scope: SaleScope.fromName(scope),
      discountType: PromoDiscountType.fromName(discountType),
      discountValue: discountValue,
      active: active,
      startsAt: startsAt,
      endsAt: endsAt,
      brandName: brands?.name,
      categoryName: categories?.name,
    );
  }
}

extension CouponDtoX on CouponDto {
  ManagedCoupon toDomain() {
    return ManagedCoupon(
      id: id,
      name: name,
      code: code,
      discountType: PromoDiscountType.fromName(discountType),
      discountValue: discountValue,
      minOrderAmountMinor: minOrderAmountMinor,
      active: active,
      startsAt: startsAt,
      endsAt: endsAt,
    );
  }
}

extension BannerDtoX on BannerDto {
  ManagedBanner toDomain({required String imageUrl}) {
    return ManagedBanner(
      id: id,
      name: name,
      imageUrl: imageUrl,
      status: BannerStatus.fromName(status),
      startsAt: startsAt,
      endsAt: endsAt,
    );
  }
}
