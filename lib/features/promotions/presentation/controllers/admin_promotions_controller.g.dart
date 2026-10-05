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
    r'e1d450e50fa09edd2eb5ce2fa4ef977b7a45e93a';

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

/// Active brands for the coupon-scope picker (Section 2d).

@ProviderFor(promoBrands)
final promoBrandsProvider = PromoBrandsProvider._();

/// Active brands for the coupon-scope picker (Section 2d).

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
  /// Active brands for the coupon-scope picker (Section 2d).
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
