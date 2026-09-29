import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

/// One realized profit line for the signed-in business: the net revenue of a
/// completed business order, booked at pickup completion (spec §58).
@freezed
abstract class BusinessTransactionEntry with _$BusinessTransactionEntry {
  const factory BusinessTransactionEntry({
    required String id,
    required DateTime occurredAt,
    required int amountMinor,
    required String label,
  }) = _BusinessTransactionEntry;
}
