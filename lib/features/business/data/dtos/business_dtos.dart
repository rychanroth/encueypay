import 'package:json_annotation/json_annotation.dart';

part 'business_dtos.g.dart';

/// Wire shape of the `businesses` row for the owner portal (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class BusinessProfileDto {
  const BusinessProfileDto({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  factory BusinessProfileDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileDtoFromJson(json);

  final String id;
  final String name;
  final String description;
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$BusinessProfileDtoToJson(this);
}

/// Wire shape of the `products` row with the owner's variants join.
@JsonSerializable(fieldRename: FieldRename.snake)
class BusinessProductDto {
  const BusinessProductDto({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.basePriceMinor,
    required this.stock,
    this.status,
    this.productVariants = const [],
  });

  factory BusinessProductDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessProductDtoFromJson(json);

  final String id;
  final String categoryId;
  final String name;
  final String description;
  final int basePriceMinor;
  final int stock;
  final String? status;

  @JsonKey(name: 'product_variants', defaultValue: [])
  final List<ManagementVariantDto> productVariants;

  Map<String, dynamic> toJson() => _$BusinessProductDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ManagementVariantDto {
  const ManagementVariantDto({
    required this.id,
    required this.name,
    required this.stock,
    this.priceMinor,
  });

  factory ManagementVariantDto.fromJson(Map<String, dynamic> json) =>
      _$ManagementVariantDtoFromJson(json);

  final String id;
  final String name;
  final int? priceMinor;
  final int stock;

  Map<String, dynamic> toJson() => _$ManagementVariantDtoToJson(this);
}

/// Wire shape of the `categories` row for the product form (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class CategoryOptionDto {
  const CategoryOptionDto({required this.id, required this.name});

  factory CategoryOptionDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryOptionDtoFromJson(json);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => _$CategoryOptionDtoToJson(this);
}

/// Wire shape of the `business_orders` row for the owner, with item and
/// customer-name joins (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class ManagedOrderDto {
  const ManagedOrderDto({
    required this.id,
    required this.orderId,
    required this.subtotalMinor,
    required this.discountMinor,
    required this.createdAt,
    this.status,
    this.rejectionReason,
    this.orderItems = const [],
    this.orders,
  });

  factory ManagedOrderDto.fromJson(Map<String, dynamic> json) =>
      _$ManagedOrderDtoFromJson(json);

  final String id;
  final String orderId;
  final int subtotalMinor;
  final int discountMinor;
  final DateTime createdAt;
  final String? status;
  final String? rejectionReason;

  @JsonKey(name: 'order_items', defaultValue: [])
  final List<ManagedOrderItemDto> orderItems;

  @JsonKey(name: 'orders')
  final ManagedOrderParentDto? orders;

  Map<String, dynamic> toJson() => _$ManagedOrderDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ManagedOrderItemDto {
  const ManagedOrderItemDto({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.lineTotalMinor,
    this.variantName,
  });

  factory ManagedOrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$ManagedOrderItemDtoFromJson(json);

  final String id;
  final String productName;
  final String? variantName;
  final int quantity;
  final int lineTotalMinor;

  Map<String, dynamic> toJson() => _$ManagedOrderItemDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ManagedOrderParentDto {
  const ManagedOrderParentDto({this.users});

  factory ManagedOrderParentDto.fromJson(Map<String, dynamic> json) =>
      _$ManagedOrderParentDtoFromJson(json);

  @JsonKey(name: 'users')
  final ManagedOrderCustomerDto? users;

  Map<String, dynamic> toJson() => _$ManagedOrderParentDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ManagedOrderCustomerDto {
  const ManagedOrderCustomerDto({this.fullName});

  factory ManagedOrderCustomerDto.fromJson(Map<String, dynamic> json) =>
      _$ManagedOrderCustomerDtoFromJson(json);

  final String? fullName;

  Map<String, dynamic> toJson() => _$ManagedOrderCustomerDtoToJson(this);
}
