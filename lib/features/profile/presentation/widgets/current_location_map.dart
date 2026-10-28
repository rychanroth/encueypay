import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';

/// Verification map for the one-tap locate flow (Section 6b): shows the
/// device fix as a pin on an interactive 240dp OpenStreetMap map so the
/// user can confirm the position before saving the address. Raster tiles
/// need no API key or billing; map types stay confined to this file — the
/// screen passes plain doubles.
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
      child: FlutterMap(
        options: MapOptions(initialCenter: target, initialZoom: 16),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            // OpenStreetMap tile policy: apps identify themselves.
            userAgentPackageName: 'com.example.encueypay',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: target,
                width: 40,
                height: 40,
                // The pin's tip sits on the fix, not its center.
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.location_on,
                  size: 40,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          // OpenStreetMap tile policy: visible attribution.
          SimpleAttributionWidget(
            source: const Text('© OpenStreetMap contributors'),
          ),
        ],
      ),
    );
  }
}
