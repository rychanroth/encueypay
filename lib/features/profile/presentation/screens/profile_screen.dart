import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/picked_file.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/user_profile.dart';
import '../controllers/profile_controller.dart';

/// Shared Profile tab (all roles). The identity header sits first, followed
/// by the role-specific overview (customer) and account links. Tapping the
/// avatar changes the photo; sign-out is a first-class action here rather
/// than a trip through Settings. The sign-out callback is injected by the
/// composition root so this feature never imports the auth feature
/// (ARCH-04).
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
    this.isCustomer = true,
    this.overviewPanel,
    this.onSignOut,
    this.onRefresh,
  });

  final bool isCustomer;

  /// Section 8A: the account overview (spending hero, orders panel,
  /// wishlist rail, cart summary) — injected by the composition root so
  /// features/profile never imports features/dashboard (ARCH-04).
  final Widget? overviewPanel;

  /// Injected by the composition root (ROUTE-08). Null hides the action.
  final Future<void> Function()? onSignOut;

  /// Pull-to-refresh for the server-aggregated overview (spending/order
  /// counts). Injected by the composition root so profile never imports the
  /// dashboard feature; null disables the indicator (admin profile).
  final Future<void> Function()? onRefresh;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _uploadingAvatar = false;
  bool _signingOut = false;

  Future<void> _changePhoto() async {
    if (_uploadingAvatar) return;
    final file = await FilePicker.pickFile(type: FileType.image);
    if (!mounted || file == null) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _uploadingAvatar = true);
    final error = await ref
        .read(profileControllerProvider.notifier)
        .updateAvatar(
          image: PickedFile(
            bytes: await file.readAsBytes(),
            fileName: file.name,
          ),
        );
    if (!mounted) return;
    setState(() => _uploadingAvatar = false);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            error == null ? 'Photo updated' : userMessageFor(error),
          ),
        ),
      );
  }

  Future<void> _confirmSignOut() async {
    final onSignOut = widget.onSignOut;
    if (onSignOut == null || _signingOut) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _signingOut = true);
    await onSignOut();
    // On success the auth session stream updates and the router redirect
    // leaves this screen; nothing to do here.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileAsync.when(
        // Keep the loaded profile visible through avatar/name mutations —
        // only a true cold load shows the spinner.
        skipLoadingOnReload: true,
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userMessageFor(error), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(profileControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (profile) => _withRefresh(
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _ProfileHeader(
                profile: profile,
                uploading: _uploadingAvatar,
                onChangePhoto: _changePhoto,
              ),
              if (widget.isCustomer && widget.overviewPanel != null) ...[
                const SizedBox(height: 16),
                widget.overviewPanel!,
              ],
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoutes.profileEdit),
              ),
              if (widget.isCustomer) ...[
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
                leading: const Icon(Icons.headset_mic_outlined),
                title: const Text('Help & support'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoutes.helpSupport),
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: const Text('Help and feedback'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoutes.helpFeedback),
              ),
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: const Text('About R67'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoutes.about),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(AppRoutes.settings),
              ),
              if (widget.onSignOut != null) ...[
                const SizedBox(height: AppSpacing.lg),
                OutlinedButton.icon(
                  onPressed: _signingOut ? null : _confirmSignOut,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  icon: _signingOut
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _withRefresh(Widget child) {
    final onRefresh = widget.onRefresh;
    if (onRefresh == null) return child;
    return RefreshIndicator(onRefresh: onRefresh, child: child);
  }
}

/// Identity header (first in the screen): avatar with an edit affordance,
/// username and phone. Tapping the card or the avatar picks a new photo.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    required this.uploading,
    required this.onChangePhoto,
  });

  final UserProfile profile;
  final bool uploading;
  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = profile.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    return Card(
      child: InkWell(
        onTap: uploading ? null : onChangePhoto,
        borderRadius: AppRadii.br12,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                    child: hasAvatar
                        ? null
                        : const Icon(Icons.person, size: 32),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: uploading
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt_outlined,
                              size: 14,
                              color: theme.colorScheme.onPrimary,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName.isEmpty
                          ? 'Unnamed user'
                          : profile.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (profile.phone != null && profile.phone!.isNotEmpty)
                      Text(
                        profile.phone!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      uploading
                          ? 'Uploading photo…'
                          : 'Tap the photo to change it',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
