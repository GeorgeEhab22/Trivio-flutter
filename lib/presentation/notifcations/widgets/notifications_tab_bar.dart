import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';

class NotificationsTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const NotificationsTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

 
    final inactiveBgColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFF4F8F5);

    final inactiveBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.06);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isActive ? AppColors.primary : inactiveBgColor,
                border: isActive
                    ? Border.all(color: Colors.transparent) 
                    : Border.all(color: inactiveBorderColor),
              ),
              child: Material(
                color: Colors.transparent, 
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onTabChanged(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : (isDark ? Colors.grey[400] : Colors.grey[700]),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5, 
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}