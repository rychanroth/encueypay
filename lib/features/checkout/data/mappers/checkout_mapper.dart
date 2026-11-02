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
  CheckoutItem toDomain({String? imageUrl}) {
    return CheckoutItem(
      id: id,
      productName: productName,
      variantName: variantName,
      unitPriceMinor: unitPriceMinor,
      saleUnitPriceMinor: saleUnitPriceMinor,
      quantity: quantity,
      imageUrl: imageUrl,
    );
  }
}

extension PlatformSettingsDtoX on PlatformSettingsDto {
  int get deliveryFeeMinorOrDefault => deliveryFeeMinor ?? 0;
}
