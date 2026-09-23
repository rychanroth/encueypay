import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/returns_repository_impl.dart';
import '../../domain/entities/return_request.dart';

part 'business_returns_controller.g.dart';

@riverpod
class BusinessReturnsController extends _$BusinessReturnsController {
  @override
  Future<List<ReturnRequest>> build() async {
    return ref.watch(returnsRepositoryProvider).fetchBusinessReturns();
  }

  Future<void> process({required String returnId, required bool approve}) async {
    final current = state.value ?? const <ReturnRequest>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(returnsRepositoryProvider)
          .processReturn(returnId: returnId, approve: approve);
      ref.invalidateSelf();
      return current;
    });
  }
}
