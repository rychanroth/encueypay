import 'package:flutter/material.dart';

import '../theme/app_typography.dart';

/// Graceful network image with a deterministic monogram fallback — the
/// shared imagery treatment for brands, categories, banners and products
/// (§6.1 "fallback skeleton"):
///
/// * loading → pulsing skeleton surface;
/// * null/empty URL or network failure → monogram (initials on a stable
///   accent pair derived from the name's code-unit sum, so the same name
///   always renders identically);
/// * success → cover-fit network image.
///
/// `core` takes primitives only (ARCH-05) — no feature imports.
class MonogramImage extends StatelessWidget {
  const MonogramImage({
    super.key,
    required this.imageUrl,
    required this.name,
    this.fit = BoxFit.cover,
    this.icon,
  });

  final String? imageUrl;
  final String name;
  final BoxFit fit;

  /// Optional glyph shown with the monogram (e.g. a category icon).
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _MonogramFallback(name: name, icon: icon);
    }
    return Image.network(
      url,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        // Keep the skeleton behind the image until the first frame lands.
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 180),
          child: child,
        );
      },
      errorBuilder: (_, _, _) => _MonogramFallback(name: name, icon: icon),
      loadingBuilder: (context, child, progress) {
        if (progress != null &&
            progress.expectedTotalBytes != null &&
            progress.cumulativeBytesLoaded >= progress.expectedTotalBytes!) {
          return child;
        }
        return const _ImageSkeleton();
      },
    );
  }
}

class _ImageSkeleton extends StatefulWidget {
  const _ImageSkeleton();

  @override
  State<_ImageSkeleton> createState() => _ImageSkeletonState();
}

class _ImageSkeletonState extends State<_ImageSkeleton>
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
    final base = Theme.of(context).colorScheme.surfaceContainerHigh;
    return FadeTransition(
      opacity: Tween(begin: 0.45, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: ColoredBox(color: base),
    );
  }
}

class _MonogramFallback extends StatelessWidget {
  const _MonogramFallback({required this.name, this.icon});

  final String name;
  final IconData? icon;

  /// Curated accent pairs (bg, fg) from the DESIGN.md palette family — the
  /// code-unit-sum hash picks one, so the same name never changes colors.
  static const List<(Color, Color)> _pairs = [
    (Color(0xFF1E3A8A), Color(0xFFEFF6FF)), // royal / blue 50
    (Color(0xFF059669), Color(0xFFECFDF5)), // emerald / emerald 50
    (Color(0xFF0E7490), Color(0xFFECFEFF)), // cyan 700 / cyan 50
    (Color(0xFF7E22CE), Color(0xFFFAF5FF)), // purple 700 / purple 50
    (Color(0xFFBE123C), Color(0xFFFFF1F2)), // rose 700 / rose 50
    (Color(0xFFB45309), Color(0xFFFFFBEB)), // amber 700 / amber 50
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;
    final (bg, fg) = _pairs[(name.codeUnits.fold<int>(0, (a, b) => a + b))
        .abs() %
        _pairs.length];

    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();

    return ColoredBox(
      color: isLight
          ? bg
          : Color.alphaBlend(
              bg.withValues(alpha: 0.22), theme.colorScheme.surfaceLow),
      child: Center(
        child: icon != null
            ? Icon(
                icon,
                size: 32,
                color: isLight
                    ? fg
                    : Color.lerp(fg, Colors.white, 0.35),
              )
            : Text(
                initials.isEmpty ? '?' : initials,
                style: AppTypography.headlineMedium.copyWith(
                  fontSize: 26,
                  color: isLight
                      ? fg
                      : Color.lerp(fg, Colors.white, 0.35),
                ),
              ),
      ),
    );
  }
}

extension on ColorScheme {
  Color get surfaceLow => surfaceContainerLowest;
}
