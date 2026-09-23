import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/supabase_client_provider.dart';

/// Reviews contract (spec §29) (DATA-03). The read path (product reviews)
/// lives in the catalog feature's own slim read model (ARCH-04).
abstract interface class IReviewsRepository {
  /// One review per purchased OrderItem — uniqueness is enforced and
  /// verified server-side.
  Future<void> submitReview({
    required String orderItemId,
    required int rating,
    required String text,
  });
}

final reviewsRepositoryProvider = Provider<IReviewsRepository>((ref) {
  return ReviewsRepositoryImpl(ref.watch(supabaseClientProvider));
});

class ReviewsRepositoryImpl implements IReviewsRepository {
  ReviewsRepositoryImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<void> submitReview({
    required String orderItemId,
    required int rating,
    required String text,
  }) async {
    try {
      await _client.rpc('create_review', params: {
        'p_order_item_id': orderItemId,
        'p_rating': rating,
        'p_text': text,
      });
    } on PostgrestException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const NetworkFailure();
    }
  }
}
