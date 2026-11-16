import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_delivery_address.freezed.dart';

/// The selected delivery address shown in the cart header — a slim read
/// model (label + city only). Full address management lives in checkout and
/// the profile addresses screen; the cart only previews where the order goes.
@freezed
abstract class CartDeliveryAddress with _$CartDeliveryAddress {
  const factory CartDeliveryAddress({
    required String id,
    required String label,
    required String city,
  }) = _CartDeliveryAddress;
}
