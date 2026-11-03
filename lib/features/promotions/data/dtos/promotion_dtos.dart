import 'package:json_annotation/json_annotation.dart';

part 'promotion_dtos.g.dart';

/// Wire shape of the `sales` row (group pricing, Section 9) with the
/// brand/category name joins for the scope chips (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class SaleDto {
  const SaleDto({
    required this.id,
    required this.name,
    this.description,
    required this.discountValue,
    this.scope,
    this.discountType,
    this.active = true,
    this.startsAt,
    this.endsAt,
    this.brands,
    this.categories,
  });

  factory SaleDto.fromJson(Map<String, dynamic> json) =>
      _$SaleDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String name;

  final String? description;
  final String? scope;
  final String? discountType;

  @JsonKey(defaultValue: 0)
  final int discountValue;

  /// Admin kill switch — window expiry is derived from the dates.
  @JsonKey(defaultValue: true)
  final bool active;

  final DateTime? startsAt;
  final DateTime? endsAt;

  @JsonKey(name: 'brands')
  final PromoBrandRefDto? brands;

  @JsonKey(name: 'categories')
  final PromoCategoryRefDto? categories;

  Map<String, dynamic> toJson() => _$SaleDtoToJson(this);
}

/// Wire shape of a standalone `coupons` row — the code carries its own
/// value, window and minimum order (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class CouponDto {
  const CouponDto({
    required this.id,
    required this.code,
    required this.discountValue,
    this.name = '',
    this.discountType,
    this.minOrderAmountMinor = 0,
    this.active = true,
    this.startsAt,
    this.endsAt,
  });

  factory CouponDto.fromJson(Map<String, dynamic> json) =>
      _$CouponDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String code;
  final String? discountType;

  @JsonKey(defaultValue: 0)
  final int discountValue;

  @JsonKey(defaultValue: 0)
  final int minOrderAmountMinor;

  @JsonKey(defaultValue: true)
  final bool active;

  final DateTime? startsAt;
  final DateTime? endsAt;

  Map<String, dynamic> toJson() => _$CouponDtoToJson(this);
}

/// Wire shape of the `banners` row (moderation view, DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class BannerDto {
  const BannerDto({
    required this.id,
    required this.name,
    required this.imagePath,
    this.status,
    this.startsAt,
    this.endsAt,
  });

  factory BannerDto.fromJson(Map<String, dynamic> json) =>
      _$BannerDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(name: 'image_path')
  final String? imagePath;

  final String? status;
  final DateTime? startsAt;
  final DateTime? endsAt;

  Map<String, dynamic> toJson() => _$BannerDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PromoCategoryRefDto {
  const PromoCategoryRefDto({required this.id, required this.name});

  factory PromoCategoryRefDto.fromJson(Map<String, dynamic> json) =>
      _$PromoCategoryRefDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String name;

  Map<String, dynamic> toJson() => _$PromoCategoryRefDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PromoBrandRefDto {
  const PromoBrandRefDto({required this.id, required this.name});

  factory PromoBrandRefDto.fromJson(Map<String, dynamic> json) =>
      _$PromoBrandRefDtoFromJson(json);

  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String name;

  Map<String, dynamic> toJson() => _$PromoBrandRefDtoToJson(this);
}
