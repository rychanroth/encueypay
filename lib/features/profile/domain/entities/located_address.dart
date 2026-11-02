import 'package:freezed_annotation/freezed_annotation.dart';

part 'located_address.freezed.dart';

/// Reverse-geocoded approximation of the user's current position — a
/// prefill suggestion for the address form. Never persisted as-is; the
/// form saves the user-confirmed hierarchy through [AddressDraft].
@freezed
abstract class LocatedAddress with _$LocatedAddress {
  const factory LocatedAddress({
    /// Street line (e.g. "271 Preah Norodom Blvd"); empty when the geocoder
    /// could only resolve an administrative area.
    required String line1,
    String? city,

    /// Official 2025 codes when Nominatim output could be matched to the
    /// bundled hierarchy. Each level is filled independently.
    String? provinceCode,
    String? provinceName,
    String? districtCode,
    String? districtName,
    String? communeCode,
    String? communeName,
    String? villageCode,
    String? villageName,
  }) = _LocatedAddress;

  const LocatedAddress._();

  int get matchedLevels => [
        provinceCode,
        districtCode,
        communeCode,
        villageCode,
      ].whereType<String>().length;
}
