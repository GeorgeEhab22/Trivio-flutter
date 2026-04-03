import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';

class SuggestHashtagsButton extends StatelessWidget {
  final VoidCallback onTap;

  const SuggestHashtagsButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> greenGradient = isDark
        ? [const Color(0xFF42C83C).withAlpha(200), AppColors.darkGreen]
        : [const Color(0xFF42C83C), AppColors.darkGreen];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFF42C83C,
                ).withValues(alpha: isDark ? 0.2 : 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: greenGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: isDark ? 0.1 : 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white, 
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Suggest Hashtags',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
