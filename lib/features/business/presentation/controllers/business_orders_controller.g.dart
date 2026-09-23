// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Incoming/active business orders. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.

@ProviderFor(BusinessOrdersController)
final businessOrdersControllerProvider = BusinessOrdersControllerProvider._();

/// Incoming/active business orders. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.
final class BusinessOrdersControllerProvider
    extends
        $AsyncNotifierProvider<
          BusinessOrdersController,
          List<ManagedBusinessOrder>
        > {
  /// Incoming/active business orders. Realtime is a sync signal (§31/§54):
  /// stream events trigger a refetch of ground truth.
  BusinessOrdersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessOrdersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessOrdersControllerHash();

  @$internal
  @override
  BusinessOrdersController create() => BusinessOrdersController();
}

String _$businessOrdersControllerHash() =>
    r'6e074d5763c2c2eb18001223fb4af8beba9ac15a';

/// Incoming/active business orders. Realtime is a sync signal (§31/§54):
/// stream events trigger a refetch of ground truth.

abstract class _$BusinessOrdersController
    extends $AsyncNotifier<List<ManagedBusinessOrder>> {
  FutureOr<List<ManagedBusinessOrder>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ManagedBusinessOrder>>,
              List<ManagedBusinessOrder>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ManagedBusinessOrder>>,
                List<ManagedBusinessOrder>
              >,
              AsyncValue<List<ManagedBusinessOrder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
