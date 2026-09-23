// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BusinessProductsController)
final businessProductsControllerProvider =
    BusinessProductsControllerProvider._();

final class BusinessProductsControllerProvider
    extends
        $AsyncNotifierProvider<
          BusinessProductsController,
          List<BusinessProduct>
        > {
  BusinessProductsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessProductsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessProductsControllerHash();

  @$internal
  @override
  BusinessProductsController create() => BusinessProductsController();
}

String _$businessProductsControllerHash() =>
    r'c5b0ee7dbfb58a20d8c3efc1649964c523dfebff';

abstract class _$BusinessProductsController
    extends $AsyncNotifier<List<BusinessProduct>> {
  FutureOr<List<BusinessProduct>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<BusinessProduct>>, List<BusinessProduct>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<BusinessProduct>>,
                List<BusinessProduct>
              >,
              AsyncValue<List<BusinessProduct>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
