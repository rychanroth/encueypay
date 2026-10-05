import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_report_provider.g.dart';

/// Server-computed platform report (§2.4) — plain one-shot fetch
/// (DOMAIN-03).
@riverpod
class AdminReportController extends _$AdminReportController {
  @override
  Future<PlatformAnalyticsReport> build() {
    return ref.watch(adminRepositoryProvider).fetchPlatformReport();
  }
}

/// Assignment §8 dashboard KPIs (Section 4).
@riverpod
class AdminKpisController extends _$AdminKpisController {
  @override
  Future<AdminKpis> build() {
    return ref.watch(adminRepositoryProvider).fetchAdminKpis();
  }
}
