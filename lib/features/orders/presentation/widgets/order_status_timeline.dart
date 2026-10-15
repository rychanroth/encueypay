import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';
import '../../domain/entities/order.dart';

/// Vertical connected stepper for order tracking (DESIGN.md §6.2):
///
/// * completed nodes — solid emerald fill with a check icon;
/// * the active node — pulsing royal dot;
/// * future nodes — muted hollow outlines;
/// * cancelled/returned lifecycles replace the track with a dedicated
///   status callout banner (no forward track exists for them).
///
/// Presentation-only: it maps the customer's derived lifecycle onto the
/// assignment's status vocabulary (Part D mapping).
class OrderStatusTimeline extends StatefulWidget {
  const OrderStatusTimeline({super.key, required this.status});

  final OrderStatus status;

  static const _stages = [
    'Pending',
    'Confirmed',
    'Processing',
    'Packed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
  ];

  @override
  State<OrderStatusTimeline> createState() => _OrderStatusTimelineState();
}

class _OrderStatusTimelineState extends State<OrderStatusTimeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  /// The order's own lifecycle (Section 7A) maps 1:1 onto the stages.
  int get _currentIndex => switch (widget.status) {
        OrderStatus.pending => 0,
        OrderStatus.confirmed => 1,
        OrderStatus.processing => 2,
        OrderStatus.packed => 3,
        OrderStatus.shipped => 4,
        OrderStatus.outForDelivery => 5,
        OrderStatus.delivered => 6,
        // Non-trackable states render as a notice (see [_hasNotice]).
        _ => -1,
      };

  bool get _hasNotice => switch (widget.status) {
        OrderStatus.cancelled || OrderStatus.returned => true,
        _ => false,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_hasNotice) {
      final isCancelled = widget.status == OrderStatus.cancelled;
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isCancelled
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.tertiaryContainer,
          borderRadius: AppRadii.br12,
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
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                isCancelled
                    ? 'This order was cancelled.'
                    : 'This order was returned.',
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

    final current = _currentIndex.clamp(0, OrderStatusTimeline._stages.length - 1);
    return Column(
      children: [
        for (var i = 0; i < OrderStatusTimeline._stages.length; i++)
          _StageRow(
            label: OrderStatusTimeline._stages[i],
            isFirst: i == 0,
            isLast: i == OrderStatusTimeline._stages.length - 1,
            state: i < current
                ? _StageState.done
                : i == current
                    ? _StageState.current
                    : _StageState.upcoming,
            pulse: _pulse,
          ),
      ],
    );
  }
}

enum _StageState { done, current, upcoming }

class _StageRow extends StatelessWidget {
  const _StageRow({
    required this.label,
    required this.isFirst,
    required this.isLast,
    required this.state,
    required this.pulse,
  });

  final String label;
  final bool isFirst;
  final bool isLast;
  final _StageState state;
  final Animation<double> pulse;

  static const _nodeSize = 22.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nodeColor = switch (state) {
      _StageState.done => AppColors.accentEmerald,
      _StageState.current => theme.colorScheme.primary,
      _StageState.upcoming => theme.colorScheme.onSurfaceVariant,
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Track + node column -------------------------------------------
          SizedBox(
            width: _nodeSize + 8,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 14,
                    color: state == _StageState.upcoming
                        ? theme.colorScheme.outlineVariant
                        : nodeColor,
                  ),
                SizedBox(
                  width: _nodeSize + 8,
                  height: _nodeSize + 8,
                  child: Center(
                    child: state == _StageState.current
                        ? FadeTransition(
                            opacity: Tween(begin: 0.55, end: 1.0)
                                .animate(pulse),
                            child: ScaleTransition(
                              scale: Tween(begin: 0.9, end: 1.0)
                                  .animate(pulse),
                              child: Container(
                                width: _nodeSize,
                                height: _nodeSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: nodeColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: nodeColor.withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.circle,
                                    size: 8, color: Colors.white),
                              ),
                            ),
                          )
                        : Container(
                            width: _nodeSize,
                            height: _nodeSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: state == _StageState.done
                                  ? nodeColor
                                  : theme.colorScheme.surfaceContainerLowest,
                              border: Border.all(color: nodeColor, width: 2),
                            ),
                            child: state == _StageState.done
                                ? const Icon(Icons.check,
                                    size: 13, color: Colors.white)
                                : null,
                          ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 14,
                    color: state == _StageState.done
                        ? nodeColor
                        : theme.colorScheme.outlineVariant,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          // --- Label ---------------------------------------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: _nodeSize / 2 + 7),
              child: Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: switch (state) {
                    _StageState.upcoming => theme.colorScheme.onSurfaceVariant,
                    _ => theme.colorScheme.onSurface,
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
