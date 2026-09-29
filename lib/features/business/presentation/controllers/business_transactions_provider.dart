import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/business_repository_impl.dart';
import '../../domain/entities/transaction.dart';

part 'business_transactions_provider.g.dart';

/// Realized profit lines for the selected day — plain one-shot fetch
/// consumed directly by the screen (DOMAIN-03). [day] is date-only.
@riverpod
Future<List<BusinessTransactionEntry>> businessTransactions(
  Ref ref,
  DateTime day,
) {
  return ref.watch(businessRepositoryProvider).fetchBusinessTransactions(day);
}
