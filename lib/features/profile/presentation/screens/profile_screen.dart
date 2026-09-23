import 'package:flutter/material.dart';

/// Shared tab — Profile (all roles). Placeholder: the profile feature
/// arrives in Phase 1.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile arrives in Phase 1')),
    );
  }
}
