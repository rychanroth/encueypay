import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';

/// Verification map for the one-tap locate flow (Section 6b): shows the
/// device fix as a pin on an interactive 240dp map so the user can confirm
/// the position before saving the address. Plugin types are confined to
/// this file — the screen passes plain doubles.
class CurrentLocationMap extends StatelessWidget {
  const CurrentLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = LatLng(latitude, longitude);
    return Container(
      height: 240,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: AppRadii.br16,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: target, zoom: 16),
        markers: {
          Marker(
            markerId: const MarkerId('current-location'),
            position: target,
            infoWindow: const InfoWindow(title: 'Your current location'),
          ),
        },
        // The blue accuracy dot doubles as verification — the locate flow
        // has already been granted the permission by this point.
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
      ),
    );
  }
}
