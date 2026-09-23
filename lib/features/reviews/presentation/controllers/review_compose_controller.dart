import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/reviews_repository_impl.dart';

part 'review_compose_controller.g.dart';

@riverpod
class ReviewComposeController extends _$ReviewComposeController {
  @override
  Future<void> build() async {}

  Future<void> submit({
    required String orderItemId,
    required int rating,
    required String text,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(reviewsRepositoryProvider).submitReview(
            orderItemId: orderItemId,
            rating: rating,
            text: text,
          ),
    );
  }
}
