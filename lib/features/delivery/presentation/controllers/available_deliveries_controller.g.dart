// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_deliveries_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Available deliveries for drivers. Realtime (§31) arrives in Phase 11;
/// pull-to-refresh until then.

@ProviderFor(AvailableDeliveriesController)
final availableDeliveriesControllerProvider =
    AvailableDeliveriesControllerProvider._();

/// Available deliveries for drivers. Realtime (§31) arrives in Phase 11;
/// pull-to-refresh until then.
final class AvailableDeliveriesControllerProvider
    extends
        $AsyncNotifierProvider<
          AvailableDeliveriesController,
          List<AvailableDelivery>
        > {
  /// Available deliveries for drivers. Realtime (§31) arrives in Phase 11;
  /// pull-to-refresh until then.
  AvailableDeliveriesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableDeliveriesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableDeliveriesControllerHash();

  @$internal
  @override
  AvailableDeliveriesController create() => AvailableDeliveriesController();
}

String _$availableDeliveriesControllerHash() =>
    r'a062a335e1f5aba4dfa4599ee12febf61c7326da';

/// Available deliveries for drivers. Realtime (§31) arrives in Phase 11;
/// pull-to-refresh until then.

abstract class _$AvailableDeliveriesController
    extends $AsyncNotifier<List<AvailableDelivery>> {
  FutureOr<List<AvailableDelivery>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AvailableDelivery>>,
              List<AvailableDelivery>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AvailableDelivery>>,
                List<AvailableDelivery>
              >,
              AsyncValue<List<AvailableDelivery>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
