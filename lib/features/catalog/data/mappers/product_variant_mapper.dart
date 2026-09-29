import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';
import '../dtos/product_variant_dto.dart';

extension ProductVariantDtoX on ProductVariantDto {
  /// [resolveImageUrl] turns the variant's Storage reference into its public
  /// URL — supplied by the repository (§48: URLs resolved in the data layer).
  ProductVariant toDomain({
    String Function(String storagePath)? resolveImageUrl,
  }) {
    return ProductVariant(
      id: id,
      productId: productId,
      name: name,
      attributes: attributes,
      priceMinor: priceMinor,
      imageUrl: imagePath == null ? null : resolveImageUrl?.call(imagePath!),
      status: ProductStatus.fromName(status),
    );
  }
}
