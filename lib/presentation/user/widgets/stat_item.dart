import 'package:auth/common/functions/format_number.dart';
import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onTap;

  const StatItem({
    required this.label,
    required this.count,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formatNumber(count),
                style: Styles.textStyle20.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Styles.textStyle14.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
