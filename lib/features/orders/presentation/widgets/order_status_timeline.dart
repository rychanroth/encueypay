import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';

/// Step-progress timeline for an order (assignment §7: "visual status
/// timeline"/"step-progress indicators"). Presentation-only: it maps the
/// customer's derived lifecycle onto the assignment's status vocabulary
/// (Part D mapping). Cancelled/refund orders render a notice instead of the
/// stepper — those lifecycles have no forward track.
class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({super.key, required this.status});

  final CustomerOrderStatus status;

  static const _steps = [
    'Pending',
    'Confirmed',
    'Processing',
    'Packed',
    'Shipped',
    'Out for delivery',
    'Delivered',
  ];

  /// Derived status → index into [_steps]. `ready` maps to Packed; with the
  /// administrative fulfillment (Section 3) completion jumps Packed →
  /// Delivered, so Shipped is implicitly passed. There is no separate
  /// Shipped event in the as-built pipeline.
  int get _currentIndex => switch (status) {
        CustomerOrderStatus.pending => 0,
        CustomerOrderStatus.accepted => 1,
        CustomerOrderStatus.preparing => 2,
        CustomerOrderStatus.ready => 3,
        CustomerOrderStatus.outForDelivery => 5,
        CustomerOrderStatus.delivered => 6,
        // Non-trackable states render as a notice (see [hasNotice]).
        _ => -1,
      };

  bool get hasNotice => switch (status) {
        CustomerOrderStatus.cancelled ||
        CustomerOrderStatus.refundRequired =>
          true,
        _ => false,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (hasNotice) {
      final isCancelled = status == CustomerOrderStatus.cancelled;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCancelled
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isCancelled ? Icons.cancel_outlined : Icons.currency_exchange,
              size: 18,
              color: isCancelled
                  ? theme.colorScheme.onErrorContainer
                  : theme.colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isCancelled
                    ? 'This order was cancelled.'
                    : 'A refund is required for this order.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isCancelled
                      ? theme.colorScheme.onErrorContainer
                      : theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final current = _currentIndex.clamp(0, _steps.length - 1);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(top: 7),
                color: i <= current
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          _StepDot(
            label: _steps[i],
            state: i < current
                ? _StepState.done
                : i == current
                    ? _StepState.current
                    : _StepState.upcoming,
          ),
        ],
      ],
    );
  }
}

enum _StepState { done, current, upcoming }

class _StepDot extends StatelessWidget {
  const _StepDot({required this.label, required this.state});

  final String label;
  final _StepState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (state) {
      _StepState.done || _StepState.current => theme.colorScheme.primary,
      _StepState.upcoming => theme.colorScheme.surfaceContainerHighest,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state == _StepState.done
                ? theme.colorScheme.primary
                : theme.colorScheme.surface,
            border: Border.all(color: color, width: 2),
          ),
          child: state == _StepState.current
              ? Icon(Icons.circle, size: 8, color: theme.colorScheme.primary)
              : null,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 44,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9,
              color: state == _StepState.upcoming
                  ? theme.colorScheme.outline
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
