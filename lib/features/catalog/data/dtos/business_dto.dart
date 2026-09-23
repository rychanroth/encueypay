import 'package:json_annotation/json_annotation.dart';

part 'business_dto.g.dart';

/// Wire shape of the `businesses` table row (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class BusinessDto {
  const BusinessDto({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    this.imageUrl,
    this.status,
  });

  factory BusinessDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessDtoFromJson(json);

  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String? imageUrl;
  final String? status;

  Map<String, dynamic> toJson() => _$BusinessDtoToJson(this);
}
