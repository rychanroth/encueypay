import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

/// One realized earning line for the signed-in driver: the delivery earning,
/// booked at delivery completion (spec §58).
@freezed
abstract class DriverTransactionEntry with _$DriverTransactionEntry {
  const factory DriverTransactionEntry({
    required String id,
    required DateTime occurredAt,
    required int amountMinor,
    required String label,
  }) = _DriverTransactionEntry;
}
