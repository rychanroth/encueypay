// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_deliveries_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyDeliveriesController)
final myDeliveriesControllerProvider = MyDeliveriesControllerProvider._();

final class MyDeliveriesControllerProvider
    extends $AsyncNotifierProvider<MyDeliveriesController, MyDeliveriesState> {
  MyDeliveriesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myDeliveriesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myDeliveriesControllerHash();

  @$internal
  @override
  MyDeliveriesController create() => MyDeliveriesController();
}

String _$myDeliveriesControllerHash() =>
    r'6df93ef8a00590f773663a65d66d0393bdce65da';

abstract class _$MyDeliveriesController
    extends $AsyncNotifier<MyDeliveriesState> {
  FutureOr<MyDeliveriesState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MyDeliveriesState>, MyDeliveriesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MyDeliveriesState>, MyDeliveriesState>,
              AsyncValue<MyDeliveriesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
