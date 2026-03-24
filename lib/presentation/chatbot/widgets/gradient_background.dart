import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration:  BoxDecoration(
          color: Color(0xFF0A0A0A),
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [
              Color(0xFF003D0A).withValues(alpha: 0.45), // softer
              Color(0xFF001A04).withValues(alpha: 0.25), // mid fade
              Color(0xFF0A0A0A), // solid dark
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}
