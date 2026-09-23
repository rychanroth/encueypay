import 'package:flutter/material.dart';

/// Admin tab 1 — Dashboard. Placeholder: reports arrive in Phase 12.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin dashboard')),
      body: const Center(child: Text('Admin reports arrive in Phase 12')),
    );
  }
}
