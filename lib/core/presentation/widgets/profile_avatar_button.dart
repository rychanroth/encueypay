import 'package:flutter/material.dart';

/// App-bar profile affordance shared by the customer and admin home shells.
/// Shows the signed-in user's avatar when available and falls back to a
/// person glyph; navigation is injected by the composition root so callers
/// keep their own route rules (ARCH-04/ROUTE-08).
class ProfileAvatarButton extends StatelessWidget {
  const ProfileAvatarButton({
    super.key,
    this.avatarUrl,
    required this.onPressed,
  });

  final String? avatarUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = avatarUrl;
    final hasAvatar = url != null && url.isNotEmpty;
    final fallback = Icon(
      Icons.person,
      size: 20,
      color: theme.colorScheme.onPrimaryContainer,
    );

    return IconButton(
      tooltip: 'Profile',
      onPressed: onPressed,
      icon: CircleAvatar(
        radius: 16,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: hasAvatar
            ? ClipOval(
                child: Image.network(
                  url,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => fallback,
                ),
              )
            : fallback,
      ),
    );
  }
}
