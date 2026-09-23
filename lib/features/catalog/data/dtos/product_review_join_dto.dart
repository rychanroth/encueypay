import 'package:json_annotation/json_annotation.dart';

part 'product_review_join_dto.g.dart';

/// Slim wire shape of an embedded `reviews` row on product detail (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class ProductReviewJoinDto {
  const ProductReviewJoinDto({
    required this.id,
    required this.rating,
    required this.createdAt,
    this.text,
    this.users,
  });

  factory ProductReviewJoinDto.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewJoinDtoFromJson(json);

  final String id;
  final int rating;
  final DateTime createdAt;
  final String? text;

  @JsonKey(name: 'users')
  final ReviewAuthorJoinDto? users;

  Map<String, dynamic> toJson() => _$ProductReviewJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewAuthorJoinDto {
  const ReviewAuthorJoinDto({this.fullName});

  factory ReviewAuthorJoinDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewAuthorJoinDtoFromJson(json);

  final String? fullName;

  Map<String, dynamic> toJson() => _$ReviewAuthorJoinDtoToJson(this);
}
