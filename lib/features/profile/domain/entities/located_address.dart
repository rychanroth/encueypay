import 'package:freezed_annotation/freezed_annotation.dart';

part 'located_address.freezed.dart';

/// Reverse-geocoded approximation of the user's current position — a
/// prefill suggestion for the address form. Never persisted: `addresses`
/// stores no geo data (spec B.6 keeps the field set coarse).
@freezed
abstract class LocatedAddress with _$LocatedAddress {
  const factory LocatedAddress({
    /// Street line (e.g. "271 Preah Norodom Blvd"); empty when the geocoder
    /// could only resolve an administrative area.
    required String line1,
    String? city,
  }) = _LocatedAddress;
}
