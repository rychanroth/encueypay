import '../../domain/entities/address.dart';
import '../dtos/address_dto.dart';

extension AddressDtoX on AddressDto {
  /// Null defaults live here, never in the UI (DATA-02).
  Address toDomain() {
    return Address(
      id: id,
      label: label,
      recipientName: recipientName,
      phone: phone,
      line1: line1,
      line2: line2,
      city: city,
    );
  }
}
