import 'package:flutter/material.dart';

/// Customer tab 3 — Orders. Placeholder: the orders feature arrives in
/// Phase 5.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const Center(child: Text('Orders arrive in Phase 5')),
    );
  }
}
