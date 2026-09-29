import '../../domain/entities/business_profile.dart';
import '../../domain/entities/managed_business_order.dart';
import '../dtos/business_dtos.dart';

extension BusinessProfileDtoX on BusinessProfileDto {
  BusinessProfile toDomain() => BusinessProfile(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
}

extension BusinessProductDtoX on BusinessProductDto {
  /// [resolveUrl] turns a Storage reference into its public URL — supplied by
  /// the repository (§48: URLs are resolved in the data layer only).
  BusinessProduct toDomain({String Function(String storagePath)? resolveUrl}) {
    final images = [...productImages]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return BusinessProduct(
      id: id,
      categoryId: categoryId,
      name: name,
      description: description,
      basePriceMinor: basePriceMinor,
      archived: status == 'archived',
      variants: productVariants
          .map((v) => ManagementVariant(
                id: v.id,
                name: v.name,
                priceMinor: v.priceMinor,
                imagePath: v.imagePath,
                imageUrl:
                    v.imagePath == null ? null : resolveUrl?.call(v.imagePath!),
              ))
          .toList(),
      images: images
          .map((i) => BusinessProductImage(
                id: i.id,
                storagePath: i.storagePath,
                url: resolveUrl?.call(i.storagePath) ?? '',
              ))
          .toList(),
    );
  }
}

extension CategoryOptionDtoX on CategoryOptionDto {
  CategoryOption toDomain() => CategoryOption(id: id, name: name);
}

extension ManagedOrderDtoX on ManagedOrderDto {
  ManagedBusinessOrder toDomain() => ManagedBusinessOrder(
        id: id,
        orderId: orderId,
        customerName: orders?.users?.fullName ?? 'Customer',
        status: ManagedOrderStatus.fromName(status),
        rejectionReason: rejectionReason,
        subtotalMinor: subtotalMinor,
        discountMinor: discountMinor,
        createdAt: createdAt,
        items: orderItems
            .map((item) => ManagedOrderItem(
                  id: item.id,
                  productName: item.productName,
                  variantName: item.variantName,
                  quantity: item.quantity,
                  lineTotalMinor: item.lineTotalMinor,
                ))
            .toList(),
      );
}
