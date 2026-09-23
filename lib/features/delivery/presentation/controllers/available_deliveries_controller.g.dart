// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_deliveries_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Available deliveries for drivers. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.

@ProviderFor(AvailableDeliveriesController)
final availableDeliveriesControllerProvider =
    AvailableDeliveriesControllerProvider._();

/// Available deliveries for drivers. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.
final class AvailableDeliveriesControllerProvider
    extends
        $AsyncNotifierProvider<
          AvailableDeliveriesController,
          List<AvailableDelivery>
        > {
  /// Available deliveries for drivers. Realtime is a sync signal (§31/§54):
  /// stream events trigger a refetch of ground truth.
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
    r'0903e79dd0b1761befd3f519a747352d113c25a3';

/// Available deliveries for drivers. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.

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
