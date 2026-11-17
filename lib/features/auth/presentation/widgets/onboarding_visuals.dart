import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/theme/app_typography.dart';

/// Illustrated onboarding scenes. Built from theme tokens and Material icons
/// rather than bitmap assets: they stay crisp, follow light/dark, and cost no
/// extra download size.
class CatalogOnboardingVisual extends StatelessWidget {
  const CatalogOnboardingVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return _VisualFrame(
      tint: AppColors.primaryRoyal,
      semanticLabel:
          'Illustration of a product search with two product cards and '
          'category filters',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SearchBar(),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ProductCard(
                    icon: Icons.checkroom_outlined,
                    tint: AppColors.primaryRoyal,
                    name: 'Khmer silk scarf',
                    price: r'$18.00',
                    tag: 'Local',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ProductCard(
                    icon: Icons.rice_bowl_outlined,
                    tint: AppColors.accentEmerald,
                    name: 'Jasmine rice · 5kg',
                    price: r'$12.50',
                    tag: 'Fresh',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _Pill(label: 'Fashion', color: AppColors.primaryRoyal),
              _Pill(label: 'Home', color: AppColors.accentAmber),
              _Pill(label: 'Beauty', color: AppColors.promotionCoral),
              _Pill(label: 'Electronics', color: AppColors.accentEmerald),
            ],
          ),
        ],
      ),
    );
  }
}

class PaymentOnboardingVisual extends StatelessWidget {
  const PaymentOnboardingVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VisualFrame(
      tint: AppColors.khqrRed,
      semanticLabel:
          'Illustration of a Bakong KHQR payment card with a verified badge '
          'and a cash-on-delivery option',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _KhqrMock()),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _OptionChip(
                  icon: Icons.qr_code_2,
                  label: 'Bakong KHQR',
                  color: AppColors.khqrRed,
                  selected: true,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _OptionChip(
                  icon: Icons.payments_outlined,
                  label: 'Cash on delivery',
                  color: kCodAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeliveryOnboardingVisual extends StatelessWidget {
  const DeliveryOnboardingVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VisualFrame(
      tint: AppColors.accentEmerald,
      semanticLabel:
          'Illustration of an order tracking card showing confirmed, out for '
          'delivery and delivered steps',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OrderHeader(),
          SizedBox(height: AppSpacing.sm),
          Expanded(child: _TrackingSteps()),
          SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: _Pill(
              label: 'Arriving today · 2–4 PM',
              color: AppColors.accentEmerald,
              icon: Icons.schedule_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bordered gradient canvas shared by the three scenes. The fixed logical
/// scene is scaled down when the available slot is smaller, so large text
/// never overflows the illustration area.
class _VisualFrame extends StatelessWidget {
  const _VisualFrame({
    required this.tint,
    required this.semanticLabel,
    required this.child,
  });

  final Color tint;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = scheme.brightness == Brightness.dark;

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: AppRadii.br24,
            border: Border.all(color: scheme.outlineVariant),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? [scheme.surfaceContainerHigh, scheme.surfaceContainerLow]
                  : [
                      tint.withValues(alpha: 0.16),
                      scheme.surfaceContainerLowest,
                    ],
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          // The scene is decorative (the surrounding Semantics label describes
          // it). Pinning its inner text scale keeps the fixed composition
          // intact; FittedBox then scales the whole scene to the slot.
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(width: 380, height: 260, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 4,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadii.brFull,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Search products…',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          Icon(Icons.tune, size: 18, color: scheme.primary),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.icon,
    required this.tint,
    required this.name,
    required this.price,
    required this.tag,
  });

  final IconData icon;
  final Color tint;
  final String name;
  final String price;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = _readableTint(theme, tint);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: fg.withValues(alpha: 0.14),
                  borderRadius: AppRadii.br16,
                ),
                child: Icon(icon, color: fg, size: 28),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _Pill(label: tag, color: tint),
          const SizedBox(height: AppSpacing.xs),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleSmall.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            price,
            style: AppTypography.priceHighlight.copyWith(
              fontSize: 14,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _KhqrMock extends StatelessWidget {
  const _KhqrMock();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.khqrRed,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code_2, color: Colors.white, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'KHQR · Bakong',
                  style: AppTypography.labelLarge.copyWith(color: Colors.white),
                ),
                const Spacer(),
                Icon(
                  Icons.lock_outline,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 16,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLow,
                      borderRadius: AppRadii.br12,
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Icon(
                      Icons.qr_code_2,
                      size: 72,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scan with any banking app',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleSmall.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Amount due',
                          style: AppTypography.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          r'$24.00',
                          style: AppTypography.priceHighlight.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const _Pill(
                          label: 'Payment verified',
                          color: AppColors.accentEmerald,
                          icon: Icons.verified_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.icon,
    required this.label,
    required this.color,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = _readableTint(theme, color);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: selected
            ? fg.withValues(alpha: 0.14)
            : scheme.surfaceContainerLowest,
        borderRadius: AppRadii.br12,
        border: Border.all(
          color: selected ? fg : scheme.outlineVariant,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: fg),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(color: scheme.onSurface),
            ),
          ),
          if (selected) Icon(Icons.check_circle, size: 16, color: fg),
        ],
      ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  const _OrderHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = _readableTint(theme, AppColors.accentEmerald);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm + 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: fg.withValues(alpha: 0.14),
              borderRadius: AppRadii.br12,
            ),
            child: Icon(Icons.local_shipping_outlined, size: 20, color: fg),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #R67-1042',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  '2 items · Phnom Penh',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const _Pill(
            label: 'Out for delivery',
            color: AppColors.accentEmerald,
          ),
        ],
      ),
    );
  }
}

class _TrackingSteps extends StatelessWidget {
  const _TrackingSteps();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TimelineStep(
            icon: Icons.check,
            title: 'Order confirmed',
            subtitle: 'Payment verified · 9:12 AM',
            color: AppColors.accentEmerald,
            done: true,
          ),
          _TimelineStep(
            icon: Icons.local_shipping_outlined,
            title: 'Out for delivery',
            subtitle: 'Driver is 10 minutes away',
            color: AppColors.accentEmerald,
            done: true,
            active: true,
          ),
          _TimelineStep(
            icon: Icons.home_outlined,
            title: 'Delivered',
            subtitle: 'We will notify you',
            color: AppColors.textMutedLight,
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.done = false,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = _readableTint(theme, color);
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: done ? fg.withValues(alpha: 0.16) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: done ? fg : scheme.outlineVariant,
              width: 1.4,
            ),
          ),
          child: Icon(icon, size: 14, color: fg),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall.copyWith(
                  color: scheme.onSurface,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = _readableTint(theme, color);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.12),
        borderRadius: AppRadii.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}

/// Lifts a brand/semantic hue toward white in dark mode so pill text and
/// small icons keep contrast on the dark card surfaces.
Color _readableTint(ThemeData theme, Color color) {
  if (theme.brightness != Brightness.dark) return color;
  return Color.lerp(color, Colors.white, 0.55)!;
}
