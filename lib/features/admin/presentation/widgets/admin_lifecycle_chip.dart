import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/status_badge.dart';

/// Lifecycle chip shared by the admin orders list and detail views
/// (Section 3). [wireName] drives the shared §2.2 status-badge palette so
/// admin and customer surfaces speak the same color language; [label] is the
/// humanized lifecycle text (never the raw wire name). Keeping the two
/// separate prevents a display label from accidentally selecting another
/// status's palette entry.
class AdminLifecycleChip extends StatelessWidget {
  const AdminLifecycleChip({
    super.key,
    required this.wireName,
    required this.label,
  });

  final String wireName;
  final String label;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(wireName: wireName, label: label, dense: true);
  }
}
