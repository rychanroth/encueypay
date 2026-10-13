import '../../domain/entities/category.dart';
import '../dtos/category_dto.dart';

extension CategoryDtoX on CategoryDto {
  /// [imageUrl] is resolved from [CategoryDto.imagePath] by the repository
  /// impl — see the brand mapper note (DATA-02).
  Category toDomain({String? imageUrl}) =>
      Category(id: id, name: name, parentId: parentId, imageUrl: imageUrl);
}
