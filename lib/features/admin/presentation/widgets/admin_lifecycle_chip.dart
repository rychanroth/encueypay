import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/status_badge.dart';

/// Lifecycle chip shared by the admin orders list and detail views
/// (Section 3). Delegates to the shared §2.2 status-badge palette so admin
/// and customer surfaces speak the same color language (DESIGN.md §2.2).
/// The label is the wire lifecycle computed by
/// [AdminOrderSummary.lifecycle] or a raw business-order status; wire names
/// outside the palette render the neutral slate entry.
class AdminLifecycleChip extends StatelessWidget {
  const AdminLifecycleChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      wireName: switch (label) {
        'completed' => 'delivered',
        'ready' => 'packed',
        'rejected' => 'cancelled',
        _ => label,
      },
      label: label,
      dense: true,
    );
  }
}
