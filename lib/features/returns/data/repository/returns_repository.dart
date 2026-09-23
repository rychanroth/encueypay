import '../../domain/entities/return_request.dart';

/// Returns contract (spec §28, §58 Return ops) (DATA-03).
abstract interface class IReturnsRepository {
  Future<List<ReturnableItem>> fetchReturnableItems(String orderId);

  Future<void> requestReturn({
    required String orderId,
    required List<ReturnItemDraft> items,
  });

  Future<List<ReturnRequest>> fetchBusinessReturns();

  Future<void> processReturn({required String returnId, required bool approve});
}
