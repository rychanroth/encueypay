import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// Visual arrangement of the brand lockup.
enum BrandLockupLayout { horizontal, stacked }

/// Ledger E mark + type-based wordmark (docs/brand/BRAND.md §4).
///
/// The wordmark is rendered as [Text] in the bundled Plus Jakarta Sans
/// ExtraBold — never a PNG — so it stays crisp at every size and costs no
/// asset bytes. The mark is the bundled vector export.
class BrandLockup extends StatelessWidget {
  const BrandLockup({
    super.key,
    this.layout = BrandLockupLayout.horizontal,
    this.markSize = 64,
    this.wordmarkSize = 32,
  });

  /// Bundled mark (1x/2x/3x density variants resolve automatically).
  static const markAsset = 'assets/brand/mark.png';

  final BrandLockupLayout layout;
  final double markSize;
  final double wordmarkSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mark = Image.asset(
      markAsset,
      width: markSize,
      height: markSize,
      excludeFromSemantics: true,
      filterQuality: FilterQuality.medium,
    );
    final wordmark = Text(
      'R67',
      textAlign: TextAlign.center,
      style: AppTypography.displayLarge.copyWith(
        fontSize: wordmarkSize,
        // −3% tracking, per the brand lockup rule.
        letterSpacing: wordmarkSize * -0.03,
        color: theme.colorScheme.onSurface,
      ),
    );

    return Semantics(
      header: true,
      label: 'R67',
      child: ExcludeSemantics(
        child: layout == BrandLockupLayout.stacked
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  mark,
                  // Lockup gap (brand measurement, not a layout token).
                  const SizedBox(height: 12),
                  wordmark,
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  mark,
                  const SizedBox(width: 16),
                  wordmark,
                ],
              ),
      ),
    );
  }
}
