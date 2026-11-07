// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Customer dashboard (assignment §1, Section 5). The aggregation stays
/// server-side (DOMAIN-03); a customer-scoped order stream invalidates the
/// one-shot fetch whenever spending or order counts change.

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

/// Customer dashboard (assignment §1, Section 5). The aggregation stays
/// server-side (DOMAIN-03); a customer-scoped order stream invalidates the
/// one-shot fetch whenever spending or order counts change.
final class DashboardControllerProvider
    extends $AsyncNotifierProvider<DashboardController, DashboardSummary> {
  /// Customer dashboard (assignment §1, Section 5). The aggregation stays
  /// server-side (DOMAIN-03); a customer-scoped order stream invalidates the
  /// one-shot fetch whenever spending or order counts change.
  DashboardControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();
}

String _$dashboardControllerHash() =>
    r'5257c078fdea04f6e82439dfb2cc6ca2bc76396e';

/// Customer dashboard (assignment §1, Section 5). The aggregation stays
/// server-side (DOMAIN-03); a customer-scoped order stream invalidates the
/// one-shot fetch whenever spending or order counts change.

abstract class _$DashboardController extends $AsyncNotifier<DashboardSummary> {
  FutureOr<DashboardSummary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DashboardSummary>, DashboardSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DashboardSummary>, DashboardSummary>,
              AsyncValue<DashboardSummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
