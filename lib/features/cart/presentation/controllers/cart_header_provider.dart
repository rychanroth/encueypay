import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/cart_repository_impl.dart';
import '../../domain/entities/cart_delivery_address.dart';

part 'cart_header_provider.g.dart';

/// Cart header facts: the default delivery address (label + city) and the
/// platform delivery fee for the trust rows. Two plain one-shot fetches
/// (DOMAIN-03); refreshed after the addresses screen returns.
typedef CartHeader = ({CartDeliveryAddress? address, int deliveryFeeMinor});

@riverpod
Future<CartHeader> cartHeader(Ref ref) async {
  final repository = ref.watch(cartRepositoryProvider);
  final results = await Future.wait([
    repository.fetchDefaultAddress(),
    repository.fetchDeliveryFeeMinor(),
  ]);
  return (
    address: results[0] as CartDeliveryAddress?,
    deliveryFeeMinor: results[1] as int,
  );
}
