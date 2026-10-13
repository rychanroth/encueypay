import '../../domain/entities/address_option.dart';
import '../../domain/entities/checkout_summary.dart';
import '../dtos/checkout_dtos.dart';

extension CheckoutAddressDtoX on CheckoutAddressDto {
  AddressOption toDomain() => AddressOption(
        id: id,
        label: label,
        recipientName: recipientName,
        phone: phone,
        line1: line1,
        line2: line2,
        city: city,
      );
}

extension CheckoutItemDtoX on CheckoutItemDto {
  /// Unit price falls back variant → product base price (DATA-02 defaults) —
  /// the same coalesce the order RPC prices with, so the summary matches the
  /// cart and the placed order.
  CheckoutItem toDomain() {
    final variant = productVariants;
    final product = variant?.products;
    return CheckoutItem(
      id: id,
      productName: product?.name ?? 'Unknown product',
      variantName: variant?.name,
      unitPriceMinor: variant?.priceMinor ?? product?.basePriceMinor ?? 0,
      quantity: quantity,
    );
  }
}

extension PlatformSettingsDtoX on PlatformSettingsDto {
  int get deliveryFeeMinorOrDefault => deliveryFeeMinor ?? 0;
}
