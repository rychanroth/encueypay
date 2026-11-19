import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/order.dart';

/// Horizontal connected stepper for order tracking (DESIGN.md §6.2).
///
/// All seven lifecycle stages share one row. To keep the labels legible on a
/// phone only the previous, current and final stages are labelled; the dots
/// carry the rest. Every stage the order has already reached shows the
/// server-logged time it entered that state ([OrderStatusEvent]).
///
/// * completed nodes — solid emerald fill with a check icon;
/// * the active node — pulsing royal dot;
/// * future nodes — muted hollow outlines;
/// * the cancelled lifecycle replaces the track with a dedicated status
///   callout banner (no forward track exists for them).
class OrderStatusTimeline extends StatefulWidget {
  const OrderStatusTimeline({
    super.key,
    required this.status,
    this.history = const [],
    this.showDetails = true,
  });

  final OrderStatus status;

  /// Lifecycle transitions as logged by the server (`get_order_status_history`).
  final List<OrderStatusEvent> history;

  /// When false the track is dots only (the collapsed customer default);
  /// when true it adds the space-saving labels and the logged times.
  final bool showDetails;

  static const stages = <(OrderStatus, String)>[
    (OrderStatus.pending, 'Pending'),
    (OrderStatus.confirmed, 'Confirmed'),
    (OrderStatus.processing, 'Processing'),
    (OrderStatus.packed, 'Packed'),
    (OrderStatus.shipped, 'Shipped'),
    (OrderStatus.outForDelivery, 'Out for Delivery'),
    (OrderStatus.delivered, 'Delivered'),
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _pulse.stop();
      _pulse.value = 1;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

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

  bool get _hasNotice => widget.status == OrderStatus.cancelled;

  /// Latest log entry for [status]; null when the server has no timestamp
  /// (e.g. transitions recorded before the history trigger existed).
  DateTime? _changedAt(OrderStatus status) {
    DateTime? result;
    for (final event in widget.history) {
      if (event.status == status) result = event.changedAt;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_hasNotice) {
      final cancelledAt = _changedAt(OrderStatus.cancelled);
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: AppRadii.br12,
        ),
        child: Row(
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 18,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                cancelledAt == null
                    ? 'This order was cancelled.'
                    : 'This order was cancelled at ${_logStamp(cancelledAt)}.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final current = _currentIndex.clamp(
      0,
      OrderStatusTimeline.stages.length - 1,
    );
    final last = OrderStatusTimeline.stages.length - 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < OrderStatusTimeline.stages.length; i++)
          Expanded(
            child: _StageColumn(
              label: OrderStatusTimeline.stages[i].$2,
              isFirst: i == 0,
              isLast: i == last,
              state: i < current
                  ? _StageState.done
                  : i == current
                  ? _StageState.current
                  : _StageState.upcoming,
              // Space-saving labels: previous, current, and the final stage.
              showLabel: i == current || i == current - 1 || i == last,
              showDetails: widget.showDetails,
              time: i <= current
                  ? _changedAt(OrderStatusTimeline.stages[i].$1)
                  : null,
              pulse: _pulse,
            ),
          ),
      ],
    );
  }
}

enum _StageState { done, current, upcoming }

class _StageColumn extends StatelessWidget {
  const _StageColumn({
    required this.label,
    required this.isFirst,
    required this.isLast,
    required this.state,
    required this.showLabel,
    required this.showDetails,
    required this.time,
    required this.pulse,
  });

  final String label;
  final bool isFirst;
  final bool isLast;
  final _StageState state;
  final bool showLabel;
  final bool showDetails;
  final DateTime? time;
  final Animation<double> pulse;

  static const _nodeSize = 18.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nodeColor = switch (state) {
      _StageState.done => AppColors.accentEmerald,
      _StageState.current => theme.colorScheme.primary,
      _StageState.upcoming => theme.colorScheme.onSurfaceVariant,
    };

    final stateLabel = switch (state) {
      _StageState.done => 'completed',
      _StageState.current => 'current',
      _StageState.upcoming => 'upcoming',
    };

    final timeLabel = time == null ? '' : ', ${_logStamp(time!)}';

    return Semantics(
      container: true,
      label: '$label, $stateLabel$timeLabel',
      child: ExcludeSemantics(
        child: Column(
          children: [
            SizedBox(
              height: 26,
              child: Row(
                children: [
                  Expanded(
                    child: _connector(
                      theme,
                      visible: !isFirst,
                      filled:
                          state == _StageState.done ||
                          state == _StageState.current,
                    ),
                  ),
                  _node(theme, nodeColor),
                  Expanded(
                    child: _connector(
                      theme,
                      visible: !isLast,
                      filled: state == _StageState.done,
                    ),
                  ),
                ],
              ),
            ),
            if (showDetails) ...[
              const SizedBox(height: 4),
              SizedBox(
                height: 26,
                child: showLabel
                    ? Center(
                        child: Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            height: 1.15,
                            color: state == _StageState.upcoming
                                ? theme.colorScheme.onSurfaceVariant
                                : theme.colorScheme.onSurface,
                            fontWeight: state == _StageState.current
                                ? FontWeight.w600
                                : null,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(
                height: 24,
                child: time == null
                    ? null
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _logDate(time!),
                              maxLines: 1,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                height: 1.1,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _logTime(time!),
                              maxLines: 1,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 9.5,
                                height: 1.1,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _connector(
    ThemeData theme, {
    required bool visible,
    required bool filled,
  }) {
    return Container(
      height: 2,
      color: !visible
          ? Colors.transparent
          : filled
          ? AppColors.accentEmerald
          : theme.colorScheme.outlineVariant,
    );
  }

  Widget _node(ThemeData theme, Color nodeColor) {
    final dot = Container(
      width: _nodeSize,
      height: _nodeSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (state) {
          _StageState.done => nodeColor,
          _StageState.current => nodeColor,
          _StageState.upcoming => theme.colorScheme.surfaceContainerLowest,
        },
        border: Border.all(color: nodeColor, width: 2),
      ),
      child: state == _StageState.done
          ? const Icon(Icons.check, size: 10, color: Colors.white)
          : state == _StageState.current
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );

    if (state != _StageState.current) return dot;
    return FadeTransition(
      opacity: Tween(begin: 0.55, end: 1.0).animate(pulse),
      child: ScaleTransition(
        scale: Tween(begin: 0.9, end: 1.0).animate(pulse),
        child: dot,
      ),
    );
  }
}

String _logTime(DateTime value) {
  final local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _logDate(DateTime value) {
  final local = value.toLocal();
  return '${local.day} ${_months[local.month - 1]}';
}

/// Compact local log stamp for accessibility and the cancelled notice.
String _logStamp(DateTime value) => '${_logDate(value)} ${_logTime(value)}';
