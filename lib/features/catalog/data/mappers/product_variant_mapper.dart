import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';
import '../dtos/product_variant_dto.dart';

extension ProductVariantDtoX on ProductVariantDto {
  ProductVariant toDomain() {
    return ProductVariant(
      id: id,
      productId: productId,
      name: name,
      attributes: attributes,
      priceMinor: priceMinor,
      stock: stock,
      status: ProductStatus.fromName(status),
    );
  }
}
