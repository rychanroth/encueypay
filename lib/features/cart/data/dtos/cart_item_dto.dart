import 'package:json_annotation/json_annotation.dart';

part 'cart_item_dto.g.dart';

/// Wire shape of the `cart_items` row with PostgREST joins for display data
/// (DATA-01). All join sections are nullable so partial embeds stay
/// parseable. Never leaves the data layer.
@JsonSerializable(fieldRename: FieldRename.snake)
class CartItemDto {
  const CartItemDto({
    required this.id,
    required this.quantity,
    this.productVariants,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) =>
      _$CartItemDtoFromJson(json);

  final String id;
  final int quantity;

  /// PostgREST embed key for the variant join.
  @JsonKey(name: 'product_variants')
  final CartVariantJoinDto? productVariants;

  Map<String, dynamic> toJson() => _$CartItemDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CartVariantJoinDto {
  const CartVariantJoinDto({
    this.id,
    this.name,
    this.priceMinor,
    this.stock,
    this.products,
  });

  factory CartVariantJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CartVariantJoinDtoFromJson(json);

  final String? id;
  final String? name;
  final int? priceMinor;
  final int? stock;

  @JsonKey(name: 'products')
  final CartProductJoinDto? products;

  Map<String, dynamic> toJson() => _$CartVariantJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CartProductJoinDto {
  const CartProductJoinDto({
    this.id,
    this.name,
    this.basePriceMinor,
    this.productImages = const [],
    this.businesses,
  });

  factory CartProductJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CartProductJoinDtoFromJson(json);

  final String? id;
  final String? name;
  final int? basePriceMinor;

  @JsonKey(name: 'product_images', defaultValue: [])
  final List<CartImageJoinDto> productImages;

  @JsonKey(name: 'businesses')
  final CartBusinessJoinDto? businesses;

  Map<String, dynamic> toJson() => _$CartProductJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CartImageJoinDto {
  const CartImageJoinDto({this.storagePath, this.sortOrder = 0});

  factory CartImageJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CartImageJoinDtoFromJson(json);

  final String? storagePath;

  @JsonKey(defaultValue: 0)
  final int sortOrder;

  Map<String, dynamic> toJson() => _$CartImageJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CartBusinessJoinDto {
  const CartBusinessJoinDto({this.id, this.name});

  factory CartBusinessJoinDto.fromJson(Map<String, dynamic> json) =>
      _$CartBusinessJoinDtoFromJson(json);

  final String? id;
  final String? name;

  Map<String, dynamic> toJson() => _$CartBusinessJoinDtoToJson(this);
}
