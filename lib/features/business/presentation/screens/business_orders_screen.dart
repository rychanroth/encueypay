import 'package:flutter/material.dart';

/// Business tab 3 — Orders. Placeholder: order processing arrives in
/// Phase 6.
class BusinessOrdersScreen extends StatelessWidget {
  const BusinessOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming orders')),
      body: const Center(child: Text('Order processing arrives in Phase 6')),
    );
  }
}
