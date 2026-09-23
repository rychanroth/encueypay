// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_returns_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BusinessReturnsController)
final businessReturnsControllerProvider = BusinessReturnsControllerProvider._();

final class BusinessReturnsControllerProvider
    extends
        $AsyncNotifierProvider<BusinessReturnsController, List<ReturnRequest>> {
  BusinessReturnsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessReturnsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessReturnsControllerHash();

  @$internal
  @override
  BusinessReturnsController create() => BusinessReturnsController();
}

String _$businessReturnsControllerHash() =>
    r'5c262b42709fc370b1bcec7adfdcea6172dc4237';

abstract class _$BusinessReturnsController
    extends $AsyncNotifier<List<ReturnRequest>> {
  FutureOr<List<ReturnRequest>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ReturnRequest>>, List<ReturnRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ReturnRequest>>, List<ReturnRequest>>,
              AsyncValue<List<ReturnRequest>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
