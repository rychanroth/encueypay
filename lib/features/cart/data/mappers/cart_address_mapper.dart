import '../../domain/entities/cart_delivery_address.dart';
import '../dtos/cart_address_dto.dart';

extension CartAddressDtoX on CartAddressDto {
  /// Null defaults live here — never in the UI (DATA-02).
  CartDeliveryAddress toDomain() {
    return CartDeliveryAddress(id: id, label: label, city: city);
  }
}
