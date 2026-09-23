import 'package:flutter/material.dart';

/// Business tab 2 — Products. Placeholder: product management arrives in
/// Phase 6.
class BusinessProductsScreen extends StatelessWidget {
  const BusinessProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My products')),
      body: const Center(child: Text('Product management arrives in Phase 6')),
    );
  }
}
