import '../../domain/entities/brand.dart';
import '../dtos/brand_dto.dart';

extension BrandDtoX on BrandDto {
  /// [imageUrl] is resolved from [BrandDto.imagePath] by the repository
  /// impl (public URL or http passthrough) — DTOs never leave `data/`
  /// carrying unresolved storage references (DATA-02).
  Brand toDomain({String? imageUrl}) =>
      Brand(id: id, name: name, imageUrl: imageUrl);
}
