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
    String? imageUrl,
  }) async {
    final current = state.value ?? const <AdminCategory>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).createCategory(
            name: name,
            parentId: parentId,
            imageUrl: imageUrl,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> rename({
    required String categoryId,
    required String name,
    String? imageUrl,
  }) async {
    final current = state.value ?? const <AdminCategory>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).renameCategory(
            categoryId: categoryId,
            name: name,
            imageUrl: imageUrl,
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
