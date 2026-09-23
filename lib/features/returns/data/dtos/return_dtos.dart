import 'package:json_annotation/json_annotation.dart';

part 'return_dtos.g.dart';

/// Wire shape of the `return_requests` row with item + product-name joins
/// (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class ReturnRequestDto {
  const ReturnRequestDto({
    required this.id,
    required this.orderId,
    required this.createdAt,
    this.status,
    this.returnItems = const [],
  });

  factory ReturnRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnRequestDtoFromJson(json);

  final String id;
  final String orderId;
  final DateTime createdAt;
  final String? status;

  @JsonKey(name: 'return_items', defaultValue: [])
  final List<ReturnItemJoinDto> returnItems;

  Map<String, dynamic> toJson() => _$ReturnRequestDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReturnItemJoinDto {
  const ReturnItemJoinDto({
    required this.id,
    required this.orderItemId,
    required this.quantity,
    required this.reason,
    this.orderItems,
  });

  factory ReturnItemJoinDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnItemJoinDtoFromJson(json);

  final String id;
  final String orderItemId;
  final int quantity;
  final String reason;

  @JsonKey(name: 'order_items')
  final ReturnOrderItemJoinDto? orderItems;

  Map<String, dynamic> toJson() => _$ReturnItemJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ReturnOrderItemJoinDto {
  const ReturnOrderItemJoinDto({this.productName, this.variantName});

  factory ReturnOrderItemJoinDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnOrderItemJoinDtoFromJson(json);

  final String? productName;
  final String? variantName;

  Map<String, dynamic> toJson() => _$ReturnOrderItemJoinDtoToJson(this);
}

/// Wire shape of the `order_items` row offered for return (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class ReturnableItemDto {
  const ReturnableItemDto({
    required this.id,
    required this.productName,
    required this.quantity,
    this.variantName,
  });

  factory ReturnableItemDto.fromJson(Map<String, dynamic> json) =>
      _$ReturnableItemDtoFromJson(json);

  final String id;
  final String productName;
  final String? variantName;
  final int quantity;

  Map<String, dynamic> toJson() => _$ReturnableItemDtoToJson(this);
}
