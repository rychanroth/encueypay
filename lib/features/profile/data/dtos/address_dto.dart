import 'package:json_annotation/json_annotation.dart';

part 'address_dto.g.dart';

/// Wire shape of the `addresses` table row (DATA-01). Never leaves the
/// data layer.
@JsonSerializable(fieldRename: FieldRename.snake)
class AddressDto {
  const AddressDto({
    required this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.phone,
    required this.line1,
    this.line2,
    required this.city,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

  final String id;
  final String userId;
  final String label;
  final String recipientName;
  final String phone;
  final String line1;
  final String? line2;
  final String city;

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);
}
