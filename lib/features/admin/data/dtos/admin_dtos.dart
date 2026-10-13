import 'package:json_annotation/json_annotation.dart';

part 'admin_dtos.g.dart';

/// Wire shape of the `audit_logs` row (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class AuditLogDto {
  const AuditLogDto({
    required this.id,
    required this.action,
    required this.targetType,
    required this.createdAt,
    this.actor,
    this.targetId,
  });

  factory AuditLogDto.fromJson(Map<String, dynamic> json) =>
      _$AuditLogDtoFromJson(json);

  final String id;
  final String? actor;
  final String action;
  final String targetType;
  final String? targetId;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => _$AuditLogDtoToJson(this);
}

/// Wire shape of the `platform_settings` singleton (admin view, DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class PlatformSettingsAdminDto {
  const PlatformSettingsAdminDto({
    required this.deliveryFeeMinor,
    required this.platformCommissionPercent,
    required this.paymentAccount,
    this.qrAccountId = '',
  });

  factory PlatformSettingsAdminDto.fromJson(Map<String, dynamic> json) =>
      _$PlatformSettingsAdminDtoFromJson(json);

  final int deliveryFeeMinor;
  final int platformCommissionPercent;
  final String paymentAccount;

  @JsonKey(defaultValue: '')
  final String qrAccountId;

  Map<String, dynamic> toJson() => _$PlatformSettingsAdminDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminApplicantJoinDto {
  const AdminApplicantJoinDto({this.fullName});

  factory AdminApplicantJoinDto.fromJson(Map<String, dynamic> json) =>
      _$AdminApplicantJoinDtoFromJson(json);

  final String? fullName;

  Map<String, dynamic> toJson() => _$AdminApplicantJoinDtoToJson(this);
}

/// Wire shape of the `categories` row for admin management (DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminCategoryDto {
  const AdminCategoryDto({
    required this.id,
    required this.name,
    this.parentId,
    this.imagePath,
  });

  factory AdminCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$AdminCategoryDtoFromJson(json);

  final String id;
  final String name;
  final String? parentId;
  final String? imagePath;

  Map<String, dynamic> toJson() => _$AdminCategoryDtoToJson(this);
}

/// Wire shape of the `brands` row for admin management (Section 2b, DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminBrandDto {
  const AdminBrandDto({
    required this.id,
    required this.name,
    this.description,
    this.imagePath,
    this.status,
  });

  factory AdminBrandDto.fromJson(Map<String, dynamic> json) =>
      _$AdminBrandDtoFromJson(json);

  final String id;
  final String name;
  final String? description;
  final String? imagePath;
  final String? status;

  Map<String, dynamic> toJson() => _$AdminBrandDtoToJson(this);
}

/// Name-only embeds for the admin product list (PostgREST FK joins).
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminNamedJoinDto {
  const AdminNamedJoinDto({this.name});

  factory AdminNamedJoinDto.fromJson(Map<String, dynamic> json) =>
      _$AdminNamedJoinDtoFromJson(json);

  final String? name;

  Map<String, dynamic> toJson() => _$AdminNamedJoinDtoToJson(this);
}

/// Wire shape of the `products` row for the admin catalog list (Section 2b,
/// DATA-01): every status, with brand/category/business names embedded.
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminProductRowDto {
  const AdminProductRowDto({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.businessId,
    required this.basePriceMinor,
    required this.createdAt,
    this.description,
    this.brandId,
    this.status,
    this.stock = 0,
    this.brands,
    this.categories,
    this.businesses,
    this.productVariants = const [],
    this.productImages = const [],
  });

  factory AdminProductRowDto.fromJson(Map<String, dynamic> json) =>
      _$AdminProductRowDtoFromJson(json);

  final String id;
  final String name;
  final String categoryId;
  final String businessId;
  final int basePriceMinor;
  final DateTime createdAt;
  final String? description;
  final String? brandId;
  final String? status;

  /// Product-wide stock (Section 2d; column re-added by 0031).
  @JsonKey(defaultValue: 0)
  final int stock;

  @JsonKey(name: 'brands')
  final AdminNamedJoinDto? brands;

  @JsonKey(name: 'categories')
  final AdminNamedJoinDto? categories;

  @JsonKey(name: 'businesses')
  final AdminNamedJoinDto? businesses;

  /// Price-only embed — used for the variant count.
  @JsonKey(name: 'product_variants', defaultValue: [])
  final List<AdminVariantIdJoinDto> productVariants;

  @JsonKey(name: 'product_images', defaultValue: [])
  final List<AdminProductImagePathDto> productImages;

  Map<String, dynamic> toJson() => _$AdminProductRowDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminVariantIdJoinDto {
  const AdminVariantIdJoinDto({this.id});

  factory AdminVariantIdJoinDto.fromJson(Map<String, dynamic> json) =>
      _$AdminVariantIdJoinDtoFromJson(json);

  final String? id;

  Map<String, dynamic> toJson() => _$AdminVariantIdJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminProductImagePathDto {
  const AdminProductImagePathDto({
    required this.id,
    required this.storagePath,
    this.sortOrder = 0,
  });

  factory AdminProductImagePathDto.fromJson(Map<String, dynamic> json) =>
      _$AdminProductImagePathDtoFromJson(json);

  final String id;
  final String storagePath;
  final int sortOrder;

  Map<String, dynamic> toJson() => _$AdminProductImagePathDtoToJson(this);
}

/// Wire shape of a slim `businesses` reference row (store picker, DATA-01).
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminBusinessRefDto {
  const AdminBusinessRefDto({required this.id, required this.name});

  factory AdminBusinessRefDto.fromJson(Map<String, dynamic> json) =>
      _$AdminBusinessRefDtoFromJson(json);

  final String id;
  final String name;

  Map<String, dynamic> toJson() => _$AdminBusinessRefDtoToJson(this);
}

/// Wire shape of the `orders` row for admin oversight (Section 3, DATA-01):
/// customer name, payment, per-business parts, and return requests embedded.
@JsonSerializable(fieldRename: FieldRename.snake)
class AdminOrderRowDto {
  const AdminOrderRowDto({
    required this.id,
    required this.subtotalMinor,
    required this.discountMinor,
    required this.deliveryFeeMinor,
    required this.totalMinor,
    required this.createdAt,
    required this.status,
    this.cancellationReason = '',
    this.users,
    this.payments = const [],
    this.items = const [],
    this.returnRequests = const [],
  });

  factory AdminOrderRowDto.fromJson(Map<String, dynamic> json) =>
      _$AdminOrderRowDtoFromJson(json);

  final String id;
  final int subtotalMinor;
  final int discountMinor;
  final int deliveryFeeMinor;
  final int totalMinor;
  final DateTime createdAt;
  final String status;

  @JsonKey(defaultValue: '')
  final String cancellationReason;

  @JsonKey(name: 'users')
  final AdminApplicantJoinDto? users;

  @JsonKey(name: 'payments', defaultValue: [])
  final List<AdminPaymentJoinDto> payments;

  @JsonKey(name: 'order_items', defaultValue: [])
  final List<AdminItemJoinDto> items;

  @JsonKey(name: 'return_requests', defaultValue: [])
  final List<AdminReturnJoinDto> returnRequests;

  Map<String, dynamic> toJson() => _$AdminOrderRowDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminPaymentJoinDto {
  const AdminPaymentJoinDto({this.method, this.status});

  factory AdminPaymentJoinDto.fromJson(Map<String, dynamic> json) =>
      _$AdminPaymentJoinDtoFromJson(json);

  final String? method;
  final String? status;

  Map<String, dynamic> toJson() => _$AdminPaymentJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminItemJoinDto {
  const AdminItemJoinDto({
    required this.productName,
    required this.quantity,
    required this.lineTotalMinor,
    this.variantName,
    this.businessName,
  });

  factory AdminItemJoinDto.fromJson(Map<String, dynamic> json) =>
      _$AdminItemJoinDtoFromJson(json);

  final String productName;
  final int quantity;
  final int lineTotalMinor;
  final String? variantName;
  final String? businessName;

  Map<String, dynamic> toJson() => _$AdminItemJoinDtoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AdminReturnJoinDto {
  const AdminReturnJoinDto({required this.id, this.status, this.reason});

  factory AdminReturnJoinDto.fromJson(Map<String, dynamic> json) =>
      _$AdminReturnJoinDtoFromJson(json);

  final String id;
  final String? status;
  final String? reason;

  Map<String, dynamic> toJson() => _$AdminReturnJoinDtoToJson(this);
}
