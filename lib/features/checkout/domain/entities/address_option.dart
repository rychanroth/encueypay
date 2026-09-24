import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_option.freezed.dart';

/// A user address as offered at checkout. Slim, purpose-shaped duplicate —
/// features never import each other (ARCH-04); the server copies the chosen
/// address into the order as a historical snapshot (spec §17).
@freezed
abstract class AddressOption with _$AddressOption {
  const factory AddressOption({
    required String id,
    required String label,
    required String recipientName,
    required String phone,
    required String line1,
    String? line2,
    required String city,
  }) = _AddressOption;
}
