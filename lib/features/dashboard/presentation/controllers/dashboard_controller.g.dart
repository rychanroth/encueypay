// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Customer dashboard (assignment §1, Section 5). Plain one-shot fetch —
/// the aggregation is server-side (DOMAIN-03); pull-to-refresh on the
/// screen re-runs it.

@ProviderFor(DashboardController)
final dashboardControllerProvider = DashboardControllerProvider._();

/// Customer dashboard (assignment §1, Section 5). Plain one-shot fetch —
/// the aggregation is server-side (DOMAIN-03); pull-to-refresh on the
/// screen re-runs it.
final class DashboardControllerProvider
    extends $AsyncNotifierProvider<DashboardController, DashboardSummary> {
  /// Customer dashboard (assignment §1, Section 5). Plain one-shot fetch —
  /// the aggregation is server-side (DOMAIN-03); pull-to-refresh on the
  /// screen re-runs it.
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
    r'ee9968ac0339176a3e19fd420f27bb7ffe6d3291';

/// Customer dashboard (assignment §1, Section 5). Plain one-shot fetch —
/// the aggregation is server-side (DOMAIN-03); pull-to-refresh on the
/// screen re-runs it.

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
