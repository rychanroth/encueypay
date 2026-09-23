// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_review_join_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReviewJoinDto _$ProductReviewJoinDtoFromJson(
  Map<String, dynamic> json,
) => ProductReviewJoinDto(
  id: json['id'] as String,
  rating: (json['rating'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  text: json['text'] as String?,
  users: json['users'] == null
      ? null
      : ReviewAuthorJoinDto.fromJson(json['users'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductReviewJoinDtoToJson(
  ProductReviewJoinDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'rating': instance.rating,
  'created_at': instance.createdAt.toIso8601String(),
  'text': instance.text,
  'users': instance.users,
};

ReviewAuthorJoinDto _$ReviewAuthorJoinDtoFromJson(Map<String, dynamic> json) =>
    ReviewAuthorJoinDto(fullName: json['full_name'] as String?);

Map<String, dynamic> _$ReviewAuthorJoinDtoToJson(
  ReviewAuthorJoinDto instance,
) => <String, dynamic>{'full_name': instance.fullName};
