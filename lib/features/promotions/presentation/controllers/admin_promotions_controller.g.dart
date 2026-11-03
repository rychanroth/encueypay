// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promotions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Admin sales management (Section 9): the group-pricing layer.

@ProviderFor(AdminSalesController)
final adminSalesControllerProvider = AdminSalesControllerProvider._();

/// Admin sales management (Section 9): the group-pricing layer.
final class AdminSalesControllerProvider
    extends $AsyncNotifierProvider<AdminSalesController, List<ManagedSale>> {
  /// Admin sales management (Section 9): the group-pricing layer.
  AdminSalesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminSalesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminSalesControllerHash();

  @$internal
  @override
  AdminSalesController create() => AdminSalesController();
}

String _$adminSalesControllerHash() =>
    r'5450201cec8e435fa4a132422cd769abb6e4e9f7';

/// Admin sales management (Section 9): the group-pricing layer.

abstract class _$AdminSalesController
    extends $AsyncNotifier<List<ManagedSale>> {
  FutureOr<List<ManagedSale>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ManagedSale>>, List<ManagedSale>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ManagedSale>>, List<ManagedSale>>,
              AsyncValue<List<ManagedSale>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Admin standalone coupon codes — cart-wide, stacked on sale prices.

@ProviderFor(AdminCouponsController)
final adminCouponsControllerProvider = AdminCouponsControllerProvider._();

/// Admin standalone coupon codes — cart-wide, stacked on sale prices.
final class AdminCouponsControllerProvider
    extends
        $AsyncNotifierProvider<AdminCouponsController, List<ManagedCoupon>> {
  /// Admin standalone coupon codes — cart-wide, stacked on sale prices.
  AdminCouponsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminCouponsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminCouponsControllerHash();

  @$internal
  @override
  AdminCouponsController create() => AdminCouponsController();
}

String _$adminCouponsControllerHash() =>
    r'dc0d551dcf1008cd3d30603b92bba04e7757344d';

/// Admin standalone coupon codes — cart-wide, stacked on sale prices.

abstract class _$AdminCouponsController
    extends $AsyncNotifier<List<ManagedCoupon>> {
  FutureOr<List<ManagedCoupon>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ManagedCoupon>>, List<ManagedCoupon>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ManagedCoupon>>, List<ManagedCoupon>>,
              AsyncValue<List<ManagedCoupon>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Banner moderation list (Section 5b — banners are their own table).

@ProviderFor(AdminBannersController)
final adminBannersControllerProvider = AdminBannersControllerProvider._();

/// Banner moderation list (Section 5b — banners are their own table).
final class AdminBannersControllerProvider
    extends
        $AsyncNotifierProvider<AdminBannersController, List<ManagedBanner>> {
  /// Banner moderation list (Section 5b — banners are their own table).
  AdminBannersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminBannersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminBannersControllerHash();

  @$internal
  @override
  AdminBannersController create() => AdminBannersController();
}

String _$adminBannersControllerHash() =>
    r'2bf24b75db6b3304c561391a5848a09b3542e119';

/// Banner moderation list (Section 5b — banners are their own table).

abstract class _$AdminBannersController
    extends $AsyncNotifier<List<ManagedBanner>> {
  FutureOr<List<ManagedBanner>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ManagedBanner>>, List<ManagedBanner>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ManagedBanner>>, List<ManagedBanner>>,
              AsyncValue<List<ManagedBanner>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Active brands for the sale-scope picker (Section 2d).

@ProviderFor(promoBrands)
final promoBrandsProvider = PromoBrandsProvider._();

/// Active brands for the sale-scope picker (Section 2d).

final class PromoBrandsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PromoBrandRef>>,
          List<PromoBrandRef>,
          FutureOr<List<PromoBrandRef>>
        >
    with
        $FutureModifier<List<PromoBrandRef>>,
        $FutureProvider<List<PromoBrandRef>> {
  /// Active brands for the sale-scope picker (Section 2d).
  PromoBrandsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'promoBrandsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$promoBrandsHash();

  @$internal
  @override
  $FutureProviderElement<List<PromoBrandRef>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PromoBrandRef>> create(Ref ref) {
    return promoBrands(ref);
  }
}

String _$promoBrandsHash() => r'645ad40ece89843d63140388521c9ccdf138207c';

/// All categories for the sale-scope picker (Section 9).

@ProviderFor(promoCategories)
final promoCategoriesProvider = PromoCategoriesProvider._();

/// All categories for the sale-scope picker (Section 9).

final class PromoCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PromoCategoryRef>>,
          List<PromoCategoryRef>,
          FutureOr<List<PromoCategoryRef>>
        >
    with
        $FutureModifier<List<PromoCategoryRef>>,
        $FutureProvider<List<PromoCategoryRef>> {
  /// All categories for the sale-scope picker (Section 9).
  PromoCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'promoCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$promoCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<PromoCategoryRef>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PromoCategoryRef>> create(Ref ref) {
    return promoCategories(ref);
  }
}

String _$promoCategoriesHash() => r'f9da1869c4e336042be766867b5f891577d6a025';
