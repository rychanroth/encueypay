import 'package:flutter/material.dart';

/// Driver tab 1 — Available deliveries. Placeholder: the delivery feature
/// arrives in Phase 7.
class AvailableDeliveriesScreen extends StatelessWidget {
  const AvailableDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available deliveries')),
      body: const Center(child: Text('Delivery feature arrives in Phase 7')),
    );
  }
}
