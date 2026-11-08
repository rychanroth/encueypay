import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/picked_file.dart';
import '../../data/repository/promotions_repository_impl.dart';
import '../../domain/entities/promotion.dart';

part 'admin_promotions_controller.g.dart';

/// Admin sales management (Section 9): the group-pricing layer.
@riverpod
class AdminSalesController extends _$AdminSalesController {
  @override
  Future<List<ManagedSale>> build() async {
    return ref.watch(promotionsRepositoryProvider).fetchSales();
  }

  Future<void> createSale({
    required String name,
    required String description,
    required SaleScope scope,
    required PromoDiscountType discountType,
    required int discountValue,
    DateTime? startsAt,
    DateTime? endsAt,
    String? brandId,
    String? categoryId,
    PickedFile? image,
  }) async {
    final current = state.value ?? const <ManagedSale>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).createSale(
            name: name,
            description: description,
            scope: scope,
            discountType: discountType,
            discountValue: discountValue,
            startsAt: startsAt,
            endsAt: endsAt,
            brandId: brandId,
            categoryId: categoryId,
            image: image,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  /// Sale kill switch: chips, struck prices and the linked banner stop
  /// rendering while inactive.
  Future<void> toggleSale({
    required String saleId,
    required bool active,
  }) async {
    final current = state.value ?? const <ManagedSale>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(promotionsRepositoryProvider)
          .setSaleActive(saleId: saleId, active: active);
      ref.invalidateSelf();
      return current;
    });
  }
}

/// Admin standalone coupon codes — cart-wide, stacked on sale prices.
@riverpod
class AdminCouponsController extends _$AdminCouponsController {
  @override
  Future<List<ManagedCoupon>> build() async {
    return ref.watch(promotionsRepositoryProvider).fetchCoupons();
  }

  Future<void> createCoupon({
    required String name,
    required String code,
    required PromoDiscountType discountType,
    required int discountValue,
    int minOrderAmountMinor = 0,
    DateTime? startsAt,
    DateTime? endsAt,
  }) async {
    final current = state.value ?? const <ManagedCoupon>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).createCoupon(
            name: name,
            code: code,
            discountType: discountType,
            discountValue: discountValue,
            minOrderAmountMinor: minOrderAmountMinor,
            startsAt: startsAt,
            endsAt: endsAt,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  /// Code kill switch; date-window expiry is derived server-side.
  Future<void> toggleCoupon({
    required String couponId,
    required bool active,
  }) async {
    final current = state.value ?? const <ManagedCoupon>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(promotionsRepositoryProvider)
          .setCouponActive(couponId: couponId, active: active);
      ref.invalidateSelf();
      return current;
    });
  }

  /// Hard delete an unredeemed code. The server rejects codes referenced by
  /// `order_coupons`; the UI surfaces that as "deactivate instead".
  Future<void> deleteCoupon({required String couponId}) async {
    final current = state.value ?? const <ManagedCoupon>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(promotionsRepositoryProvider)
          .deleteCoupon(couponId: couponId);
      ref.invalidateSelf();
      return current;
    });
  }
}

/// Banner moderation list (Section 5b — banners are their own table).
@riverpod
class AdminBannersController extends _$AdminBannersController {
  @override
  Future<List<ManagedBanner>> build() async {
    return ref.watch(promotionsRepositoryProvider).fetchBanners();
  }

  Future<void> createBanner({
    required String name,
    required String description,
    required PickedFile image,
  }) async {
    final current = state.value ?? const <ManagedBanner>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).createBanner(
            name: name,
            description: description,
            image: image,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> moderate({
    required String bannerId,
    required String action,
  }) async {
    final current = state.value ?? const <ManagedBanner>[];
    state = await AsyncValue.guard(() async {
      await ref.read(promotionsRepositoryProvider).moderateBanner(
            bannerId: bannerId,
            action: action,
          );
      ref.invalidateSelf();
      return current;
    });
  }
}

/// Active brands for the sale-scope picker (Section 2d).
@riverpod
Future<List<PromoBrandRef>> promoBrands(Ref ref) async {
  return ref.watch(promotionsRepositoryProvider).fetchActiveBrands();
}

/// All categories for the sale-scope picker (Section 9).
@riverpod
Future<List<PromoCategoryRef>> promoCategories(Ref ref) async {
  return ref.watch(promotionsRepositoryProvider).fetchCategories();
}
