import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/status_chip.dart';
import '../../domain/entities/managed_business_order.dart';

/// Presentation-side visual mapping for [ManagedOrderStatus] — the domain
/// entity stays free of Colors.
extension ManagedOrderStatusVisual on ManagedOrderStatus {
  String get label => switch (this) {
        ManagedOrderStatus.pending => 'Pending',
        ManagedOrderStatus.accepted => 'Accepted',
        ManagedOrderStatus.rejected => 'Rejected',
        ManagedOrderStatus.preparing => 'Preparing',
        ManagedOrderStatus.ready => 'Ready',
        ManagedOrderStatus.completed => 'Completed',
        ManagedOrderStatus.cancelled => 'Cancelled',
      };

  Color get color => switch (this) {
        ManagedOrderStatus.pending => Colors.orange,
        ManagedOrderStatus.accepted => Colors.blue,
        ManagedOrderStatus.rejected => Colors.red,
        ManagedOrderStatus.preparing => Colors.indigo,
        ManagedOrderStatus.ready => Colors.teal,
        ManagedOrderStatus.completed => Colors.green,
        ManagedOrderStatus.cancelled => Colors.grey,
      };
}

/// Scannable status pill for managed business orders.
class ManagedOrderStatusChip extends StatelessWidget {
  const ManagedOrderStatusChip({super.key, required this.status});

  final ManagedOrderStatus status;

  @override
  Widget build(BuildContext context) =>
      StatusChip(label: status.label, color: status.color);
}
