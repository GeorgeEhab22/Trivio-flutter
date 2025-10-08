import 'package:flutter/material.dart';

class VanishingItem extends StatelessWidget {
  final bool isVisible;
  final Widget child;
  final Duration duration;
  final Curve curve;

  const VanishingItem({
    super.key,
    required this.isVisible,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: 1.0,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}