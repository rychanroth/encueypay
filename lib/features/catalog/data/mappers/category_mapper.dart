import '../../domain/entities/category.dart';
import '../dtos/category_dto.dart';

extension CategoryDtoX on CategoryDto {
  Category toDomain() =>
      Category(id: id, name: name, parentId: parentId, imageUrl: imageUrl);
}
