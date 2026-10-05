import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../controllers/profile_controller.dart';

/// Shared Profile tab (all roles). Shows the user's profile and links to
/// edit, addresses, and settings. Customer-only links are gated by
/// [isCustomer] (injected by the composition root). Sign-out lives in
/// Settings and is wired through the composition root, not imported here.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.isCustomer = true, this.overviewPanel});

  final bool isCustomer;

  /// Section 8A: the account overview (spending hero, orders panel,
  /// wishlist rail, cart summary) — injected by the composition root so
  /// features/profile never imports features/dashboard (ARCH-04).
  final Widget? overviewPanel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(profileControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (isCustomer && overviewPanel != null) ...[
              overviewPanel!,
              const SizedBox(height: 16),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: profile.avatarUrl != null
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: profile.avatarUrl == null
                          ? const Icon(Icons.person, size: 28)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName.isEmpty
                                ? 'Unnamed user'
                                : profile.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (profile.phone != null &&
                              profile.phone!.isNotEmpty)
                            Text(profile.phone!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.profileEdit),
            ),
            if (isCustomer) ...[
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Addresses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoutes.addresses),
              ),
              ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: const Text('Wishlist'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoutes.wishlist),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
  }
}
