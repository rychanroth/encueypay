import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_dimensions.dart';

/// Uniform `AsyncValue` renderer (DESIGN.md §8 `async_value_widget.dart`):
/// loading renders a skeleton (or spinner), error renders message + retry,
/// data renders [data]. Use everywhere a controller is watched so every
/// surface shares one deterministic loading/error vocabulary.
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.retry,
    this.loading,
    this.errorBuilder,
    this.skipLoadingOnReload = true,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Shown on the error branch; the retry callback invalidates the source
  /// provider. When null, the error branch is read-only.
  final VoidCallback? retry;

  /// Custom loading branch; defaults to the skeleton shimmer.
  final Widget? loading;

  /// Custom error copy (defaults to the failure's toString).
  final String Function(Object error)? errorBuilder;

  /// Keep the previous data on-screen through background refetches — no
  /// layout flashing (deterministic UX, PRES-05 friendly).
  final bool skipLoadingOnReload;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: true,
      data: data,
      loading: () => loading ?? const SkeletonListView(),
      error: (error, _) => AsyncErrorView(
        message: errorBuilder?.call(error) ?? '$error',
        retry: retry,
      ),
    );
  }
}

/// Error branch: message + optional retry, centered.
class AsyncErrorView extends StatelessWidget {
  const AsyncErrorView({super.key, required this.message, this.retry});

  final String message;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (retry != null) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.tonal(
                onPressed: retry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty branch: icon + title + optional description and action — the
/// shared vocabulary for "nothing here yet".
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    this.description,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: theme.colorScheme.outline),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                description!,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder block with a deterministic pulse — the loading
/// vocabulary (no spinners inside content surfaces).
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppRadii.br12,
  });

  final double? width;
  final double height;
  final BorderRadius radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.surfaceContainerHigh;
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(color: base, borderRadius: widget.radius),
      ),
    );
  }
}

/// Full-area skeleton grid — default loading branch for list/grid screens.
class SkeletonListView extends StatelessWidget {
  const SkeletonListView({super.key, this.itemCount = 6, this.crossAxisCount = 2});

  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.68,
      ),
      itemCount: itemCount,
      itemBuilder: (_, _) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: SkeletonBox(height: double.infinity)),
        const SizedBox(height: AppSpacing.sm),
        const SkeletonBox(width: 90),
        const SizedBox(height: AppSpacing.xs),
        const SkeletonBox(width: 56),
      ],
    );
  }
}
