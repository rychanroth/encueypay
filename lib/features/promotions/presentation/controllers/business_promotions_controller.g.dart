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
