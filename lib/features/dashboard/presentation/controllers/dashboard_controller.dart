import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard.dart';

part 'dashboard_controller.g.dart';

/// Customer dashboard (assignment §1, Section 5). Plain one-shot fetch —
/// the aggregation is server-side (DOMAIN-03); pull-to-refresh on the
/// screen re-runs it.
@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<DashboardSummary> build() async {
    return ref.watch(dashboardRepositoryProvider).fetchSummary();
  }
}
