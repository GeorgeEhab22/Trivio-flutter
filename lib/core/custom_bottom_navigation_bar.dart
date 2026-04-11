// ignore_for_file: deprecated_member_use

import 'package:auth/constants/paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class GlassmorphismNav extends StatefulWidget {
  final Map<int, String>? routeForIndex;
  final int currentIndex;
  final void Function(int index)? onTapIndex;

  const GlassmorphismNav({
    super.key,
    this.routeForIndex,
    required this.currentIndex,
    this.onTapIndex,
  });

  @override
  State<GlassmorphismNav> createState() => _GlassmorphismNavState();
}

class _GlassmorphismNavState extends State<GlassmorphismNav>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Map<int, String> _routeForIndex;

  @override
  void initState() {
    super.initState();

    _routeForIndex =
        widget.routeForIndex ??
        {
          0: '/app/home',
          1: '/app/reels',
          2: '/app/chatbot',
          3: '/app/stats',
          4: '/app/profile',
        };

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pulseController.stop();
    _rotateController.stop();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (widget.onTapIndex != null) {
      widget.onTapIndex!(index);
      return;
    }

    final routeName = _routeForIndex[index];
    if (routeName == null) return;

    GoRouter.of(context).go(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isReel = widget.currentIndex == 1;
    final isChatbot = widget.currentIndex == 2;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final backgroundColor = isDarkMode
        ? const Color(0xFF1a1d21).withOpacity(0.8) // Dark glass background
        : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8);

    final borderColor = isDarkMode
        ? Colors.white.withOpacity(0.1) // Subtle border in dark mode
        : Colors.white.withOpacity(0.3);

    final gradientColors = isDarkMode
        ? [
            Colors.white.withOpacity(0.05), // Very subtle gradient in dark
            Colors.white.withOpacity(0.02),
          ]
        : [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.05)];

    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.4) // Stronger shadow in dark mode
        : Colors.black.withOpacity(0.1);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: isReel || isChatbot ? const Color(0xFF18191a) : backgroundColor,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          if (isDarkMode)
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
              spreadRadius: -5,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGlassNavItem(Paths.homeIcon, 0, isDarkMode),
              _buildGlassNavItem(Icons.video_library_outlined, 1, isDarkMode),
              _buildGlassNavItem(Paths.chatbotIcon, 2, isDarkMode),
              _buildGlassNavItem(Paths.statsIcon, 3, isDarkMode),
              _buildGlassNavItem(Paths.profileIcon, 4, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassNavItem(dynamic icon, int index, bool isDarkMode) {

    final isSelected = widget.currentIndex == index;

    final selectedBgColor = isDarkMode
        ? Colors.white.withOpacity(0.15)
        : Colors.white.withOpacity(0.3);

    final selectedBorderColor = isDarkMode
        ? Colors.white.withOpacity(0.3)
        : Colors.white.withOpacity(0.5);

    final selectedIconColor = isDarkMode
        ? Colors.green[400]!
        : Colors.green[200]!;

    final unselectedIconColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;

    final Color resolvedIconColor = isSelected
        ? selectedIconColor
        : unselectedIconColor;

    final double iconSize = isSelected ? 28 : 24;

    Widget iconWidget;
    if (icon is String) {
      iconWidget = SvgPicture.asset(
        icon,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(resolvedIconColor, BlendMode.srcIn),
      );
    } else {
      iconWidget = Icon(
        icon as IconData,
        size: iconSize,
        color: resolvedIconColor,
      );
    }

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.transparent,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: selectedBorderColor, width: 2)
              : null,
          
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: isSelected ? 1.0 : 0.9,
          child: iconWidget,
        ),
      ),
    );
  }
}
