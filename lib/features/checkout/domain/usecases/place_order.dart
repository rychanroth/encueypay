import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/checkout_repository.dart';
import '../../data/repository/checkout_repository_impl.dart';
import '../entities/payment_method.dart';

/// Real domain operation (DOMAIN-02): the atomic checkout is a use case,
/// not a plain fetch. One class, one `call()`, interface-injected, own
/// manual provider.
class PlaceOrderUseCase {
  PlaceOrderUseCase(this._repository);

  final ICheckoutRepository _repository;

  Future<String> call({
    required String addressId,
    required PaymentMethod method,
    required List<String> couponCodes,
  }) {
    return _repository.placeOrder(
      addressId: addressId,
      method: method,
      couponCodes: couponCodes,
    );
  }
}

final placeOrderUseCaseProvider = Provider<PlaceOrderUseCase>((ref) {
  return PlaceOrderUseCase(ref.watch(checkoutRepositoryProvider));
});
