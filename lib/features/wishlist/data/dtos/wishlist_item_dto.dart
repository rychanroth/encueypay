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
    this.stock = 0,
    this.status,
    this.productVariants = const [],
    this.productImages = const [],
  });

  factory WishlistProductJoinDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistProductJoinDtoFromJson(json);

  final String? name;
  final int? basePriceMinor;

  /// Product-wide stock (Section 6/2d).
  @JsonKey(defaultValue: 0)
  final int stock;
  final String? status;

  /// Price-only variant embed — the first id is the default variant for the
  /// card quick actions (Section 6).
  @JsonKey(name: 'product_variants', defaultValue: [])
  final List<WishlistVariantJoinDto> productVariants;

  @JsonKey(name: 'product_images', defaultValue: [])
  final List<WishlistImageJoinDto> productImages;

  Map<String, dynamic> toJson() => _$WishlistProductJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WishlistVariantJoinDto {
  const WishlistVariantJoinDto({this.id});

  factory WishlistVariantJoinDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistVariantJoinDtoFromJson(json);

  final String? id;

  Map<String, dynamic> toJson() => _$WishlistVariantJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WishlistImageJoinDto {
  const WishlistImageJoinDto({this.storagePath, this.sortOrder = 0});

  factory WishlistImageJoinDto.fromJson(Map<String, dynamic> json) =>
      _$WishlistImageJoinDtoFromJson(json);

  final String? storagePath;

  @JsonKey(defaultValue: 0)
  final int sortOrder;

  Map<String, dynamic> toJson() => _$WishlistImageJoinDtoToJson(this);
}
