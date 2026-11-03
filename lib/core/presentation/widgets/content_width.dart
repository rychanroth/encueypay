import 'package:flutter/material.dart';

/// Caps readable content on tablets/desktop while keeping phones edge-to-edge.
///
/// Forms and checkout should not stretch a text field across a 1200dp window;
/// lists can still choose their own padding.
class ContentWidth extends StatelessWidget {
  const ContentWidth({
    super.key,
    required this.child,
    this.maxWidth = 720,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
