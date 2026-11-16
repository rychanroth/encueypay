import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';

/// Help & support (mocked contact data, per the prototype brief). The
/// details are placeholders — tapping a row copies it so the flow can be
/// exercised without a real support backend.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _contacts = <({IconData icon, String label, String value})>[
    (icon: Icons.mail_outline, label: 'Email', value: 'support@r67.example'),
    (icon: Icons.phone_outlined, label: 'Phone', value: '+855 12 345 678'),
    (icon: Icons.telegram, label: 'Telegram', value: '@r67support'),
  ];

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(AppSnackBar(content: Text('Copied $value')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help & support')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We are here to help',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Questions about an order, a payment or a delivery? '
                    'Reach us through any channel below — 8:00 to 18:00, '
                    'Monday to Saturday.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                for (final contact in _contacts)
                  ListTile(
                    leading: Icon(contact.icon),
                    title: Text(contact.label),
                    subtitle: Text(contact.value),
                    trailing: const Icon(Icons.copy, size: 18),
                    onTap: () => _copy(context, contact.value),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Demo contact details — replace before launch.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
