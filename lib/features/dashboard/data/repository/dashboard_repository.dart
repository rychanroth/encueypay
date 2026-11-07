import '../../../../core/domain/stream_result.dart';
import '../../domain/entities/dashboard.dart';

/// Customer dashboard contract (assignment §1, Section 5) (DATA-03).
abstract interface class IDashboardRepository {
  Future<DashboardSummary> fetchSummary();

  /// Realtime sync signal for the customer-scoped order aggregates.
  Stream<StreamResult<bool>> watchDashboardChanges();
}
