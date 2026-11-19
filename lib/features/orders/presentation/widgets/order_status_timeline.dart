import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/order.dart';

/// Order tracking timeline (DESIGN.md §6.2).
///
/// Collapsed ([showDetails] false) is a compact one-row track: all seven
/// lifecycle stages as dots. Expanding it switches to a vertical list where
/// every stage is named and each stage the order has already reached carries
/// the server-logged date and time it entered that state
/// ([OrderStatusEvent]).
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

  /// False renders the compact horizontal dot track; true the vertical
  /// named list with transition times.
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
    if (!widget.showDetails) {
      return _CompactTrack(current: current, pulse: _pulse);
    }
    return _DetailedTrack(
      current: current,
      pulse: _pulse,
      changedAt: _changedAt,
    );
  }
}

enum _StageState { done, current, upcoming }

_StageState _stateFor(int index, int current) => index < current
    ? _StageState.done
    : index == current
    ? _StageState.current
    : _StageState.upcoming;

Color _nodeColor(ThemeData theme, _StageState state) => switch (state) {
  _StageState.done => AppColors.accentEmerald,
  _StageState.current => theme.colorScheme.primary,
  _StageState.upcoming => theme.colorScheme.onSurfaceVariant,
};

String _stateLabel(_StageState state) => switch (state) {
  _StageState.done => 'completed',
  _StageState.current => 'current',
  _StageState.upcoming => 'upcoming',
};

/// Collapsed customer default: one row, seven dots, no labels or times.
class _CompactTrack extends StatelessWidget {
  const _CompactTrack({required this.current, required this.pulse});

  final int current;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final last = OrderStatusTimeline.stages.length - 1;
    return Row(
      children: [
        for (var i = 0; i <= last; i++)
          Expanded(
            child: Semantics(
              container: true,
              label:
                  '${OrderStatusTimeline.stages[i].$2}, '
                  '${_stateLabel(_stateFor(i, current))}',
              child: ExcludeSemantics(
                child: SizedBox(
                  height: 26,
                  child: Row(
                    children: [
                      Expanded(
                        child: _horizontalConnector(
                          theme,
                          visible: i > 0,
                          filled: i <= current,
                        ),
                      ),
                      _StageNode(
                        state: _stateFor(i, current),
                        pulse: pulse,
                        size: 18,
                      ),
                      Expanded(
                        child: _horizontalConnector(
                          theme,
                          visible: i < last,
                          filled: i < current,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Expanded view: vertical list, every stage named, reached stages timed.
class _DetailedTrack extends StatelessWidget {
  const _DetailedTrack({
    required this.current,
    required this.pulse,
    required this.changedAt,
  });

  final int current;
  final Animation<double> pulse;
  final DateTime? Function(OrderStatus status) changedAt;

  @override
  Widget build(BuildContext context) {
    final last = OrderStatusTimeline.stages.length - 1;
    return Column(
      children: [
        for (var i = 0; i <= last; i++)
          _DetailedStageRow(
            label: OrderStatusTimeline.stages[i].$2,
            state: _stateFor(i, current),
            isFirst: i == 0,
            isLast: i == last,
            time: i <= current
                ? changedAt(OrderStatusTimeline.stages[i].$1)
                : null,
            pulse: pulse,
          ),
      ],
    );
  }
}

class _DetailedStageRow extends StatelessWidget {
  const _DetailedStageRow({
    required this.label,
    required this.state,
    required this.isFirst,
    required this.isLast,
    required this.time,
    required this.pulse,
  });

  final String label;
  final _StageState state;
  final bool isFirst;
  final bool isLast;
  final DateTime? time;
  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeLabel = time == null ? '' : ', ${_logStamp(time!)}';

    return Semantics(
      container: true,
      label: '$label, ${_stateLabel(state)}$timeLabel',
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 26,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _verticalConnector(
                    theme,
                    visible: !isFirst,
                    filled: state != _StageState.upcoming,
                  ),
                  _StageNode(state: state, pulse: pulse),
                  _verticalConnector(
                    theme,
                    visible: !isLast,
                    filled: state == _StageState.done,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: state == _StageState.upcoming
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onSurface,
                    fontWeight: state == _StageState.current
                        ? FontWeight.w600
                        : null,
                  ),
                ),
              ),
            ),
            if (time != null)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: Text(
                  _logStamp(time!),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StageNode extends StatelessWidget {
  const _StageNode({required this.state, required this.pulse, this.size = 22});

  final _StageState state;
  final Animation<double> pulse;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _nodeColor(theme, state);
    final dot = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: state == _StageState.upcoming
            ? theme.colorScheme.surfaceContainerLowest
            : color,
        border: Border.all(color: color, width: 2),
      ),
      child: switch (state) {
        _StageState.done => const Icon(
          Icons.check,
          size: 13,
          color: Colors.white,
        ),
        _StageState.current => Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        _StageState.upcoming => null,
      },
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

Widget _horizontalConnector(
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

Widget _verticalConnector(
  ThemeData theme, {
  required bool visible,
  required bool filled,
}) {
  return Container(
    width: 2,
    height: 14,
    color: !visible
        ? Colors.transparent
        : filled
        ? AppColors.accentEmerald
        : theme.colorScheme.outlineVariant,
  );
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

/// Compact local log stamp used by the vertical rows and the cancelled notice.
String _logStamp(DateTime value) => '${_logDate(value)} ${_logTime(value)}';
