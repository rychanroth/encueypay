import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/admin_repository_impl.dart';
import '../../domain/entities/admin.dart';

part 'admin_brands_controller.g.dart';

/// Brand management (Section 2b, assignment §2/§3): list + create + edit +
/// archive/activate + delete. Mutations persist-then-invalidate (PRES-03).
@riverpod
class AdminBrandsController extends _$AdminBrandsController {
  @override
  Future<List<AdminBrand>> build() async {
    return ref.watch(adminRepositoryProvider).fetchBrands();
  }

  Future<void> create({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final current = state.value ?? const <AdminBrand>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).createBrand(
            name: name,
            description: description,
            imageUrl: imageUrl,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  // Named `edit`, not `update`: Riverpod's generated async notifier already
  // exposes an `update` member.
  Future<void> edit({
    required String brandId,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final current = state.value ?? const <AdminBrand>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).updateBrand(
            brandId: brandId,
            name: name,
            description: description,
            imageUrl: imageUrl,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> setArchived({
    required String brandId,
    required bool archived,
  }) async {
    final current = state.value ?? const <AdminBrand>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(adminRepositoryProvider)
          .setBrandArchived(brandId: brandId, archived: archived);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> delete({required String brandId}) async {
    final current = state.value ?? const <AdminBrand>[];
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).deleteBrand(brandId: brandId);
      ref.invalidateSelf();
      return current;
    });
  }
}
