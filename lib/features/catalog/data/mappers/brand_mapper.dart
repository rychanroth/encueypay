import '../../domain/entities/brand.dart';
import '../dtos/brand_dto.dart';

extension BrandDtoX on BrandDto {
  Brand toDomain() => Brand(id: id, name: name);
}
