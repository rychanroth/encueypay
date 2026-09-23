// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Incoming/active business orders. Realtime arrives in Phase 11; until
/// then the list refreshes via invalidate (pull-to-refresh + after each
/// transition).

@ProviderFor(BusinessOrdersController)
final businessOrdersControllerProvider = BusinessOrdersControllerProvider._();

/// Incoming/active business orders. Realtime arrives in Phase 11; until
/// then the list refreshes via invalidate (pull-to-refresh + after each
/// transition).
final class BusinessOrdersControllerProvider
    extends
        $AsyncNotifierProvider<
          BusinessOrdersController,
          List<ManagedBusinessOrder>
        > {
  /// Incoming/active business orders. Realtime arrives in Phase 11; until
  /// then the list refreshes via invalidate (pull-to-refresh + after each
  /// transition).
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
    r'988e731d35e8b4814bc0d78f2a0aa12da922a874';

/// Incoming/active business orders. Realtime arrives in Phase 11; until
/// then the list refreshes via invalidate (pull-to-refresh + after each
/// transition).

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
