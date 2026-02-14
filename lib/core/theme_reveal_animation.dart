import 'dart:math' as math;

import 'package:flutter/material.dart';

class ThemeRevealAnimation extends StatefulWidget {
  final Widget child;
  final ThemeMode themeMode;
  final Duration duration;

  const ThemeRevealAnimation({
    super.key,
    required this.child,
    required this.themeMode,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<ThemeRevealAnimation> createState() => _ThemeRevealAnimationState();
}

class _ThemeRevealAnimationState extends State<ThemeRevealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ThemeMode? _previousTheme;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _previousTheme = widget.themeMode;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  void didUpdateWidget(ThemeRevealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.themeMode != widget.themeMode) {
      _previousTheme = oldWidget.themeMode;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setTapPosition(Offset position) {
    setState(() {
      _tapPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            widget.child,
            if (_animation.value > 0 && _animation.value < 1)
              Positioned.fill(
                child: CustomPaint(
                  painter: _CircularRevealPainter(
                    progress: _animation.value,
                    center: _tapPosition ?? Offset.zero,
                    isDarkMode: widget.themeMode == ThemeMode.dark,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CircularRevealPainter extends CustomPainter {
  final double progress;
  final Offset center;
  final bool isDarkMode;

  _CircularRevealPainter({
    required this.progress,
    required this.center,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = math.sqrt(
      math.pow(size.width, 2) + math.pow(size.height, 2),
    );

    final radius = maxRadius * progress;

    final paint = Paint()
      ..color = isDarkMode ? const Color(0xFF18191a) : Colors.white
      ..style = PaintingStyle.fill;

    // Draw expanding circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_CircularRevealPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}

/// Alternative: Ripple effect transition
class ThemeRippleTransition extends StatefulWidget {
  final Widget child;
  final bool isDark;
  final Duration duration;

  const ThemeRippleTransition({
    super.key,
    required this.child,
    required this.isDark,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<ThemeRippleTransition> createState() => _ThemeRippleTransitionState();
}

class _ThemeRippleTransitionState extends State<ThemeRippleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ripple1;
  late Animation<double> _ripple2;
  late Animation<double> _ripple3;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _ripple1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _ripple2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.75, curve: Curves.easeOut),
      ),
    );

    _ripple3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
      ),
    );

    _fade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void didUpdateWidget(ThemeRippleTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (_controller.value == 0 || _controller.value == 1) {
              return const SizedBox.shrink();
            }

            return Opacity(
              opacity: _fade.value,
              child: CustomPaint(
                size: Size.infinite,
                painter: _RipplePainter(
                  ripple1: _ripple1.value,
                  ripple2: _ripple2.value,
                  ripple3: _ripple3.value,
                  color: widget.isDark ? const Color(0xFF18191a) : Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double ripple1;
  final double ripple2;
  final double ripple3;
  final Color color;

  _RipplePainter({
    required this.ripple1,
    required this.ripple2,
    required this.ripple3,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius =
        math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2)) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw three ripples with different opacities
    if (ripple1 > 0) {
      paint.color = color.withOpacity(0.3 * (1 - ripple1));
      canvas.drawCircle(center, maxRadius * ripple1, paint);
    }

    if (ripple2 > 0) {
      paint.color = color.withOpacity(0.5 * (1 - ripple2));
      canvas.drawCircle(center, maxRadius * ripple2, paint);
    }

    if (ripple3 > 0) {
      paint.color = color.withOpacity(0.8 * (1 - ripple3));
      canvas.drawCircle(center, maxRadius * ripple3, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.ripple1 != ripple1 ||
        oldDelegate.ripple2 != ripple2 ||
        oldDelegate.ripple3 != ripple3;
  }
}
