import 'package:json_annotation/json_annotation.dart';

part 'wishlist_item_dto.g.dart';

/// Wire shape of the `wishlist_items` row with the product join (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class WishlistItemDto {
  const WishlistItemDto({
    required this.id,
    required this.productId,
    this.products,
  });

  factory WishlistItemDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemDtoFromJson(json);

  final String id;
  final String productId;

  /// PostgREST embed key for the product join.
  @JsonKey(name: 'products')
  final WishlistProductJoinDto? products;

  Map<String, dynamic> toJson() => _$WishlistItemDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WishlistProductJoinDto {
  const WishlistProductJoinDto({
    this.name,
    this.basePriceMinor,
    this.productImages = const [],
  });

  factory WishlistProductJoinDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistProductJoinDtoFromJson(json);

  final String? name;
  final int? basePriceMinor;

  @JsonKey(name: 'product_images', defaultValue: [])
  final List<WishlistImageJoinDto> productImages;

  Map<String, dynamic> toJson() => _$WishlistProductJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WishlistImageJoinDto {
  const WishlistImageJoinDto({this.storagePath});

  factory WishlistImageJoinDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistImageJoinDtoFromJson(json);

  final String? storagePath;

  Map<String, dynamic> toJson() => _$WishlistImageJoinDtoToJson(this);
}
