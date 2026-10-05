// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Server-computed platform report (§2.4) — plain one-shot fetch
/// (DOMAIN-03).

@ProviderFor(AdminReportController)
final adminReportControllerProvider = AdminReportControllerProvider._();

/// Server-computed platform report (§2.4) — plain one-shot fetch
/// (DOMAIN-03).
final class AdminReportControllerProvider
    extends
        $AsyncNotifierProvider<AdminReportController, PlatformAnalyticsReport> {
  /// Server-computed platform report (§2.4) — plain one-shot fetch
  /// (DOMAIN-03).
  AdminReportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminReportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminReportControllerHash();

  @$internal
  @override
  AdminReportController create() => AdminReportController();
}

String _$adminReportControllerHash() =>
    r'9ad14899da0462b93bb60d7cd25362ed9767fceb';

/// Server-computed platform report (§2.4) — plain one-shot fetch
/// (DOMAIN-03).

abstract class _$AdminReportController
    extends $AsyncNotifier<PlatformAnalyticsReport> {
  FutureOr<PlatformAnalyticsReport> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<PlatformAnalyticsReport>,
              PlatformAnalyticsReport
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<PlatformAnalyticsReport>,
                PlatformAnalyticsReport
              >,
              AsyncValue<PlatformAnalyticsReport>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Assignment §8 dashboard KPIs (Section 4).

@ProviderFor(AdminKpisController)
final adminKpisControllerProvider = AdminKpisControllerProvider._();

/// Assignment §8 dashboard KPIs (Section 4).
final class AdminKpisControllerProvider
    extends $AsyncNotifierProvider<AdminKpisController, AdminKpis> {
  /// Assignment §8 dashboard KPIs (Section 4).
  AdminKpisControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminKpisControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminKpisControllerHash();

  @$internal
  @override
  AdminKpisController create() => AdminKpisController();
}

String _$adminKpisControllerHash() =>
    r'315eb9c5b7b37add9ddcd849bf0c75ba6701e28b';

/// Assignment §8 dashboard KPIs (Section 4).

abstract class _$AdminKpisController extends $AsyncNotifier<AdminKpis> {
  FutureOr<AdminKpis> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AdminKpis>, AdminKpis>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminKpis>, AdminKpis>,
              AsyncValue<AdminKpis>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
