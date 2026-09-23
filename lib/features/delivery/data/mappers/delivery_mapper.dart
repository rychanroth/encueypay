import '../../domain/entities/delivery.dart';
import '../dtos/delivery_dtos.dart';

extension DeliveryDtoX on DeliveryDto {
  /// [assigned] selects the projection: available listings show pickup
  /// business names; the driver's own delivery shows full stop detail.
  AvailableDelivery toAvailable() {
    return AvailableDelivery(
      id: id,
      orderId: orderId,
      dropoffCity: orders?.shippingCity ?? '',
      pickupBusinessNames: [
        for (final stop in pickupStops)
          if (stop.businessOrders?.businesses?.name != null)
            stop.businessOrders!.businesses!.name!,
      ],
      stopCount: pickupStops.length,
      deliveryFeeMinor: deliveryFeeMinor,
      createdAt: createdAt,
    );
  }

  DriverDelivery toDriverDelivery() {
    return DriverDelivery(
      id: id,
      orderId: orderId,
      status: DeliveryStateValue.fromName(status),
      customerName: orders?.users?.fullName ?? 'Customer',
      dropoffLine1: orders?.shippingLine1 ?? '',
      dropoffCity: orders?.shippingCity ?? '',
      earningMinor: driverEarningMinor,
      createdAt: createdAt,
      stops: pickupStops
          .map((stop) => DriverStop(
                id: stop.id,
                businessName: stop.businessOrders?.businesses?.name ?? 'Stop',
                sequence: stop.sequence,
                completed: stop.status == 'completed',
              ))
          .toList()
        ..sort((a, b) => a.sequence.compareTo(b.sequence)),
    );
  }
}
