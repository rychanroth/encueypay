import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/returns_repository_impl.dart';
import '../../domain/entities/return_request.dart';

part 'return_request_controller.g.dart';

/// Returnable lines for one delivered order + submission.
@riverpod
class ReturnRequestController extends _$ReturnRequestController {
  @override
  Future<List<ReturnableItem>> build(String orderId) async {
    return ref.watch(returnsRepositoryProvider).fetchReturnableItems(orderId);
  }

  Future<void> submit(List<ReturnItemDraft> items) async {
    final current = state.value ?? const <ReturnableItem>[];
    state = await AsyncValue.guard(() async {
      await ref
          .read(returnsRepositoryProvider)
          .requestReturn(orderId: orderId, items: items);
      ref.invalidateSelf();
      return current;
    });
  }
}
