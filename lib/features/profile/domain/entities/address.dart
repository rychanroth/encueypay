import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';

/// A user-owned shipping address (spec §17). Addresses are mutable before
/// checkout; the order later stores its own historical snapshot.
@freezed
abstract class Address with _$Address {
  const factory Address({
    required String id,
    @Default('Home') String label,
    required String recipientName,
    @Default('') String phone,
    required String line1,
    String? line2,
    required String city,
  }) = _Address;
}

/// Input shape for creating/updating an address (no id, no timestamps).
@freezed
abstract class AddressDraft with _$AddressDraft {
  const factory AddressDraft({
    required String label,
    required String recipientName,
    required String phone,
    required String line1,
    String? line2,
    required String city,
  }) = _AddressDraft;

  const AddressDraft._();

  Address toEntity(String id) => Address(
        id: id,
        label: label,
        recipientName: recipientName,
        phone: phone,
        line1: line1,
        line2: line2,
        city: city,
      );
}
