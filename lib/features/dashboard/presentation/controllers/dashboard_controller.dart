import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/stream_result.dart';
import '../../data/repository/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard.dart';

part 'dashboard_controller.g.dart';

/// Customer dashboard (assignment §1, Section 5). The aggregation stays
/// server-side (DOMAIN-03); a customer-scoped order stream invalidates the
/// one-shot fetch whenever spending or order counts change.
@riverpod
class DashboardController extends _$DashboardController {
  Timer? _refreshDebounce;

  @override
  Future<DashboardSummary> build() async {
    final repository = ref.watch(dashboardRepositoryProvider);
    final subscription = repository
        .watchDashboardChanges()
        .skipInitialSnapshot()
        .listen((result) {
      if (result is StreamData) _scheduleRefresh();
    });
    ref.onDispose(() {
      _refreshDebounce?.cancel();
      subscription.cancel();
    });
    return repository.fetchSummary();
  }

  void _scheduleRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(
      const Duration(milliseconds: 250),
      () {
        if (ref.mounted) ref.invalidateSelf();
      },
    );
  }
}
