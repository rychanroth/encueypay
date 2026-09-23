import '../../domain/entities/promotion.dart';
import '../dtos/promotion_dtos.dart';

extension PromotionDtoX on PromotionDto {
  MyPromotion toDomain({String? bannerUrl}) {
    return MyPromotion(
      id: id,
      name: name,
      description: description,
      scope: PromotionScope.fromName(scope),
      discountType: PromoDiscountType.fromName(discountType),
      discountValue: discountValue,
      isBanner: bannerImagePath != null,
      bannerStatus: BannerStatus.fromName(bannerStatus),
      bannerUrl: bannerUrl,
      endsAt: endsAt,
      coupons: coupons
          .map((coupon) => MyCoupon(
                id: coupon.id,
                code: coupon.code,
                active: coupon.active,
                expiresAt: coupon.expiresAt,
              ))
          .toList(),
    );
  }
}
