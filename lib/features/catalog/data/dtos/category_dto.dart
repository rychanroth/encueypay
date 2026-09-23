import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

/// Wire shape of the `categories` table row (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.name,
    this.parentId,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  final String id;
  final String name;
  final String? parentId;

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}
