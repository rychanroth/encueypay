import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/business_repository_impl.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/entities/business_profile.dart';

part 'business_profile_controller.g.dart';

/// null state = not onboarded yet → the dashboard shows the wizard
/// (Phase 6 decision: onboarding fills the CreateBusiness spec gap).
@riverpod
class BusinessProfileController extends _$BusinessProfileController {
  @override
  Future<BusinessProfile?> build() async {
    return ref.watch(businessRepositoryProvider).fetchMyBusiness();
  }

  Future<void> createBusiness({
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    final current = state.value;
    state = await AsyncValue.guard(() async {
      await ref.read(businessRepositoryProvider).createBusiness(
            name: name,
            description: description,
            imageUrl: imageUrl,
          );
      ref.invalidateSelf();
      return current;
    });
  }

  Future<void> updateBusiness({
    required String name,
    required String description,
  }) async {
    final current = state.value;
    state = await AsyncValue.guard(() async {
      await ref
          .read(businessRepositoryProvider)
          .updateMyBusiness(name: name, description: description);
      ref.invalidateSelf();
      return current;
    });
  }

  Future<String?> uploadImage({
    required String filePath,
    required String fileName,
  }) {
    return ref.read(businessRepositoryProvider).uploadBusinessImage(
          filePath: filePath,
          fileName: fileName,
        );
  }
}

/// Server-computed analytics (§58) — plain one-shot fetch consumed
/// directly by the dashboard (DOMAIN-03).
@riverpod
Future<BusinessAnalytics> businessAnalytics(Ref ref) {
  return ref.watch(businessRepositoryProvider).fetchMyAnalytics();
}
