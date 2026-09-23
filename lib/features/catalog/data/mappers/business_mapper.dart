import '../../domain/entities/business.dart';
import '../dtos/business_dto.dart';

extension BusinessDtoX on BusinessDto {
  Business toDomain() => Business(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
}
