import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_categories_controller.g.dart';

@riverpod
class AdminCategoriesController extends _$AdminCategoriesController {
  @override
  Future<List<AdminCategory>> build() async {
    return ref.watch(adminRepositoryProvider).fetchCategories();
  }

  Future<void> create({
    required String name,
    String? parentId,
    String? imagePath,
  }) async {
    final current = state.value ?? const <AdminCategory>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).createCategory(
            name: name,
            parentId: parentId,
            imagePath: imagePath,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  /// Uploads category imagery into `catalog_assets` and returns the stored
  /// path (DESIGN.md imagery pipeline).
  Future<String> uploadImage({required String filePath}) {
    return ref
        .read(adminRepositoryProvider)
        .uploadCatalogImage(filePath: filePath);
  }

  Future<void> rename({
    required String categoryId,
    required String name,
    String? imagePath,
    String? parentId,
  }) async {
    final current = state.value ?? const <AdminCategory>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).renameCategory(
            categoryId: categoryId,
            name: name,
            imagePath: imagePath,
            parentId: parentId,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> delete({required String categoryId}) async {
    final current = state.value ?? const <AdminCategory>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .deleteCategory(categoryId: categoryId);
      ref.invalidateSelf();
      return current;
    });
  }
}
