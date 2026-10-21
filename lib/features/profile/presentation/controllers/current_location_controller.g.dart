// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_location_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One-shot locate for the address form (spec B.6): device position →
/// platform reverse geocode. A plain fetch, so the controller calls the
/// repository directly (DOMAIN-04) — no use case.

@ProviderFor(CurrentLocationController)
final currentLocationControllerProvider = CurrentLocationControllerProvider._();

/// One-shot locate for the address form (spec B.6): device position →
/// platform reverse geocode. A plain fetch, so the controller calls the
/// repository directly (DOMAIN-04) — no use case.
final class CurrentLocationControllerProvider
    extends $AsyncNotifierProvider<CurrentLocationController, LocatedAddress?> {
  /// One-shot locate for the address form (spec B.6): device position →
  /// platform reverse geocode. A plain fetch, so the controller calls the
  /// repository directly (DOMAIN-04) — no use case.
  CurrentLocationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocationControllerHash();

  @$internal
  @override
  CurrentLocationController create() => CurrentLocationController();
}

String _$currentLocationControllerHash() =>
    r'3fe62e215e18b5fb723adec8d07e3d11e2b0b07c';

/// One-shot locate for the address form (spec B.6): device position →
/// platform reverse geocode. A plain fetch, so the controller calls the
/// repository directly (DOMAIN-04) — no use case.

abstract class _$CurrentLocationController
    extends $AsyncNotifier<LocatedAddress?> {
  FutureOr<LocatedAddress?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LocatedAddress?>, LocatedAddress?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LocatedAddress?>, LocatedAddress?>,
              AsyncValue<LocatedAddress?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
