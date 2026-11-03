import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';

part 'delivery_fee_provider.g.dart';

/// Platform-wide delivery fee (minor units) for the storefront trust block.
/// Plain one-shot fetch — presentation may call the repository directly
/// (DOMAIN-03).
@riverpod
Future<int> deliveryFeeMinor(Ref ref) {
  return ref.watch(catalogRepositoryProvider).fetchDeliveryFeeMinor();
}
