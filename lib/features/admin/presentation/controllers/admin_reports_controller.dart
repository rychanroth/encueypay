import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_reports_controller.freezed.dart';
part 'admin_reports_controller.g.dart';

/// Date-range parameters for the reporting screen (Section 8C).
@freezed
abstract class ReportRange with _$ReportRange {
  const factory ReportRange({
    required DateTime from,
    required DateTime to,
  }) = _ReportRange;
}

/// The date-range sales report (Section 8C, assignment §8 "Reporting and
/// Analytics"). Defaults to the last 30 days; the screen re-filters via
/// [setRange].
@riverpod
class AdminReportsController extends _$AdminReportsController {
  @override
  Future<AdminSalesReport> build(ReportRange range) async {
    return ref.watch(adminRepositoryProvider).fetchSalesReport(
          from: range.from,
          to: range.to,
        );
  }

  Future<void> setRange(ReportRange range) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(adminRepositoryProvider).fetchSalesReport(
            from: range.from,
            to: range.to,
          ),
    );
  }
}

/// Helper for the screen: the default range (last 30 days, inclusive).
ReportRange defaultReportRange() {
  final now = DateTime.now();
  return ReportRange(
    from: now.subtract(const Duration(days: 29)),
    to: now,
  );
}
