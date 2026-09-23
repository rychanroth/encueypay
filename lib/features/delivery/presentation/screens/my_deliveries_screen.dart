import 'package:flutter/material.dart';

/// Driver tab 2 — My deliveries (active + history). Placeholder: arrives in
/// Phase 7.
class MyDeliveriesScreen extends StatelessWidget {
  const MyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My deliveries')),
      body: const Center(child: Text('Delivery feature arrives in Phase 7')),
    );
  }
}
