import 'package:flutter/material.dart';

/// Coarse lifecycle chip shared by the admin orders list and detail views
/// (Section 3). The label is the wire lifecycle computed by
/// [AdminOrderSummary.lifecycle] or a raw business-order status.
class AdminLifecycleChip extends StatelessWidget {
  const AdminLifecycleChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, textColor) = switch (label) {
      'completed' || 'ready' => (
          theme.colorScheme.primaryContainer,
          theme.colorScheme.onPrimaryContainer
        ),
      'rejected' || 'cancelled' => (
          theme.colorScheme.errorContainer,
          theme.colorScheme.onErrorContainer
        ),
      _ => (
          theme.colorScheme.surfaceContainerHighest,
          theme.colorScheme.onSurface
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: textColor),
      ),
    );
  }
}
