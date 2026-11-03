import 'package:flutter/material.dart';

import '../motion.dart';

/// Product-grid entrance (HANDOFF-UX-VISUAL §3.1): one short controller per
/// grid, each card fading/translating in on a capped stagger. Reduced motion
/// renders the plain grid.
class StaggeredGrid extends StatefulWidget {
  const StaggeredGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.gridDelegate,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final SliverGridDelegate gridDelegate;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  State<StaggeredGrid> createState() => _StaggeredGridState();
}

class _StaggeredGridState extends State<StaggeredGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.stagger,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = AppMotion.reduced(context);
    return GridView.builder(
      padding: widget.padding,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      gridDelegate: widget.gridDelegate,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        final child = widget.itemBuilder(context, index);
        if (reduceMotion) return child;
        final start = (index * 0.06).clamp(0.0, 0.45).toDouble();
        final end = (start + 0.55).clamp(0.0, 1.0).toDouble();
        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: AppMotion.enterCurve),
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}
