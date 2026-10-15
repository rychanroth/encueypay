// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promotions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminPromotionsController)
final adminPromotionsControllerProvider = AdminPromotionsControllerProvider._();

final class AdminPromotionsControllerProvider
    extends
        $AsyncNotifierProvider<AdminPromotionsController, List<MyPromotion>> {
  AdminPromotionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminPromotionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminPromotionsControllerHash();

  @$internal
  @override
  AdminPromotionsController create() => AdminPromotionsController();
}

String _$adminPromotionsControllerHash() =>
    r'2a3f66f963753bd946a0fa29c00a9a2f31fada91';

abstract class _$AdminPromotionsController
    extends $AsyncNotifier<List<MyPromotion>> {
  FutureOr<List<MyPromotion>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<MyPromotion>>, List<MyPromotion>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MyPromotion>>, List<MyPromotion>>,
              AsyncValue<List<MyPromotion>>,
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
    r'05c7cc939e66c74d6e417e99ce0b271d0a476c05';

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

/// Active brands for the coupon-scope picker (Section 2d) and the banner
/// destination picker (Section 9).

@ProviderFor(promoBrands)
final promoBrandsProvider = PromoBrandsProvider._();

/// Active brands for the coupon-scope picker (Section 2d) and the banner
/// destination picker (Section 9).

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
  /// Active brands for the coupon-scope picker (Section 2d) and the banner
  /// destination picker (Section 9).
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

/// All categories for the banner destination picker (Section 9).

@ProviderFor(promoCategories)
final promoCategoriesProvider = PromoCategoriesProvider._();

/// All categories for the banner destination picker (Section 9).

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
  /// All categories for the banner destination picker (Section 9).
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
