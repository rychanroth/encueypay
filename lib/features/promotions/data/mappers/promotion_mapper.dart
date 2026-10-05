import '../../domain/entities/promotion.dart';
import '../dtos/promotion_dtos.dart';

extension PromotionDtoX on PromotionDto {
  MyPromotion toDomain() {
    return MyPromotion(
      id: id,
      name: name,
      description: description,
      scope: PromotionScope.fromName(scope),
      discountType: PromoDiscountType.fromName(discountType),
      discountValue: discountValue,
      active: active,
      brandName: brands?.name,
      coupons: coupons
          .map((coupon) => MyCoupon(
                id: coupon.id,
                code: coupon.code,
                active: coupon.active,
                minOrderAmountMinor: coupon.minOrderAmountMinor,
                startsAt: coupon.startsAt,
                endsAt: coupon.endsAt,
              ))
          .toList(),
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
