import 'package:flutter/material.dart';

/// Business tab 1 — Dashboard. Placeholder: the business portal arrives in
/// Phase 6 (including the onboarding wizard that gates this shell).
class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business dashboard')),
      body: const Center(child: Text('Business portal arrives in Phase 6')),
    );
  }
}
