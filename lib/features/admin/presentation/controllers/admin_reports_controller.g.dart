// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reports_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The date-range sales report (Section 8C, assignment §8 "Reporting and
/// Analytics"). Defaults to the last 30 days; the screen re-filters via
/// [setRange].

@ProviderFor(AdminReportsController)
final adminReportsControllerProvider = AdminReportsControllerFamily._();

/// The date-range sales report (Section 8C, assignment §8 "Reporting and
/// Analytics"). Defaults to the last 30 days; the screen re-filters via
/// [setRange].
final class AdminReportsControllerProvider
    extends $AsyncNotifierProvider<AdminReportsController, AdminSalesReport> {
  /// The date-range sales report (Section 8C, assignment §8 "Reporting and
  /// Analytics"). Defaults to the last 30 days; the screen re-filters via
  /// [setRange].
  AdminReportsControllerProvider._({
    required AdminReportsControllerFamily super.from,
    required ReportRange super.argument,
  }) : super(
         retry: null,
         name: r'adminReportsControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminReportsControllerHash();

  @override
  String toString() {
    return r'adminReportsControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminReportsController create() => AdminReportsController();

  @override
  bool operator ==(Object other) {
    return other is AdminReportsControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminReportsControllerHash() =>
    r'd1171184c2960c074dd64a6d16855ac44f92263e';

/// The date-range sales report (Section 8C, assignment §8 "Reporting and
/// Analytics"). Defaults to the last 30 days; the screen re-filters via
/// [setRange].

final class AdminReportsControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminReportsController,
          AsyncValue<AdminSalesReport>,
          AdminSalesReport,
          FutureOr<AdminSalesReport>,
          ReportRange
        > {
  AdminReportsControllerFamily._()
    : super(
        retry: null,
        name: r'adminReportsControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The date-range sales report (Section 8C, assignment §8 "Reporting and
  /// Analytics"). Defaults to the last 30 days; the screen re-filters via
  /// [setRange].

  AdminReportsControllerProvider call(ReportRange range) =>
      AdminReportsControllerProvider._(argument: range, from: this);

  @override
  String toString() => r'adminReportsControllerProvider';
}

/// The date-range sales report (Section 8C, assignment §8 "Reporting and
/// Analytics"). Defaults to the last 30 days; the screen re-filters via
/// [setRange].

abstract class _$AdminReportsController
    extends $AsyncNotifier<AdminSalesReport> {
  late final _$args = ref.$arg as ReportRange;
  ReportRange get range => _$args;

  FutureOr<AdminSalesReport> build(ReportRange range);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<AdminSalesReport>, AdminSalesReport>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AdminSalesReport>, AdminSalesReport>,
              AsyncValue<AdminSalesReport>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
