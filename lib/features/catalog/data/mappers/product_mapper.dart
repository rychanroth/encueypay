import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';

extension ProductDtoX on ProductDto {
  /// [imageUrls] are resolved from Storage references by the repository
  /// impl (§48: Storage owns the file, records own the reference).
  Product toDomain({List<String> imageUrls = const []}) {
    return Product(
      id: id,
      businessId: businessId,
      categoryId: categoryId,
      name: name,
      description: description,
      basePriceMinor: basePriceMinor,
      status: ProductStatus.fromName(status),
      imageUrls: imageUrls,
    );
  }
}
