import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/delivery_repository_impl.dart';
import '../../domain/entities/transaction.dart';

part 'driver_transactions_provider.g.dart';

/// Realized earning lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.
@riverpod
Future<List<DriverTransactionEntry>> driverTransactions(
  Ref ref,
  DateTime day,
) {
  return ref.watch(deliveryRepositoryProvider).fetchDriverTransactions(day);
}
