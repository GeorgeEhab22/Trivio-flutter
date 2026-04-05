import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';

class ReelsButtonsGreenEffect extends StatelessWidget {
  final Widget child;
  final double size;

  const ReelsButtonsGreenEffect({
    super.key,
    required this.child,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.0),
                  AppColors.primary.withValues(alpha: 0.2),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
          ),

          Center(child: child),
        ],
      ),
    );
  }
}
