import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';

/// Product brand (assignment §2/§3): an independent catalog dimension, kept
/// separate from the bypassed vendor model (living spec Part B §2). Brands
/// are admin-managed; customers read active ones only. Immutable (DOMAIN-01).
@freezed
abstract class Brand with _$Brand {
  const factory Brand({
    required String id,
    required String name,
    String? imageUrl,
  }) = _Brand;
}
