// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_promotions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BusinessPromotionsController)
final businessPromotionsControllerProvider =
    BusinessPromotionsControllerProvider._();

final class BusinessPromotionsControllerProvider
    extends
        $AsyncNotifierProvider<
          BusinessPromotionsController,
          List<MyPromotion>
        > {
  BusinessPromotionsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessPromotionsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessPromotionsControllerHash();

  @$internal
  @override
  BusinessPromotionsController create() => BusinessPromotionsController();
}

String _$businessPromotionsControllerHash() =>
    r'e2a10cd35cbb7add8b2e77b0776ef97fee5c06b2';

abstract class _$BusinessPromotionsController
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

/// The business user's submitted banners (Section 5b — separate table).

@ProviderFor(myBanners)
final myBannersProvider = MyBannersProvider._();

/// The business user's submitted banners (Section 5b — separate table).

final class MyBannersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ManagedBanner>>,
          List<ManagedBanner>,
          FutureOr<List<ManagedBanner>>
        >
    with
        $FutureModifier<List<ManagedBanner>>,
        $FutureProvider<List<ManagedBanner>> {
  /// The business user's submitted banners (Section 5b — separate table).
  MyBannersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myBannersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myBannersHash();

  @$internal
  @override
  $FutureProviderElement<List<ManagedBanner>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ManagedBanner>> create(Ref ref) {
    return myBanners(ref);
  }
}

String _$myBannersHash() => r'066776b852f4b007b4de8071be9b9afe10a913f3';
