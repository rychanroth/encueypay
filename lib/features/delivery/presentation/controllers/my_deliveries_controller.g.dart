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
    r'9002d449918ffd11160b415d86c2b1d515f1d051';

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
