import 'package:flutter/material.dart';

/// Customer tab 1 — Home. Placeholder: the catalog feature arrives in
/// Phase 2 (the contract's reference feature).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EncueYPay')),
      body: const Center(child: Text('Home — catalog arrives in Phase 2')),
    );
  }
}
