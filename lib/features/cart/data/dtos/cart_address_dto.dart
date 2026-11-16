import 'package:json_annotation/json_annotation.dart';

part 'cart_address_dto.g.dart';

/// Wire shape of the `addresses` columns the cart header previews (DATA-01).
/// The cart deliberately reads only label + city: full address management
/// belongs to checkout/profile, and this keeps the cart entity slim.
@JsonSerializable(fieldRename: FieldRename.snake)
class CartAddressDto {
  const CartAddressDto({
    required this.id,
    required this.label,
    required this.city,
  });

  factory CartAddressDto.fromJson(Map<String, dynamic> json) =>
      _$CartAddressDtoFromJson(json);

  final String id;
  final String label;
  final String city;

  Map<String, dynamic> toJson() => _$CartAddressDtoToJson(this);
}
