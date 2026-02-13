import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:auth/core/styels.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomTeamRow extends StatelessWidget {
  final Widget icon;
  final String name;
  final int score;
  final bool? winner;

  const CustomTeamRow(
    this.icon,
    this.name,
    this.score,
    this.winner, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        SizedBox(
          width: 50,
          child: winner == true
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Opacity(opacity: 0.3, child: icon),
                    ),
                    icon,
                  ],
                )
              : icon,
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            name,
            style: Styles.textStyle16.copyWith(
              color: winner == true
                  ? (isDark
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.9, green: 120))
                  : Theme.of(context).textTheme.displayMedium?.color,
              fontWeight: winner == true ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
        Skeleton.ignore(
          child: Text(
            score.toString(),
            style: Styles.textStyle18.copyWith(
              color: winner == true
                  ? (isDark
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.9, green: 120))
                  : Theme.of(context).textTheme.displayMedium?.color,
              fontWeight: winner == true ? FontWeight.w900 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
