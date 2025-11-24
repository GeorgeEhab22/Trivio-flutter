// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class GlassmorphismNav extends StatefulWidget {
  const GlassmorphismNav({super.key});
  @override
  State<GlassmorphismNav> createState() => _GlassmorphismNavState();
}

class _GlassmorphismNavState extends State<GlassmorphismNav>
    with TickerProviderStateMixin {
  int selectedNav = 0;
  int _currentIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  @override
  void initState() {
    super.initState();
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
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCurrentNavBar();
  }

  Widget _buildCurrentNavBar() {
    switch (selectedNav) {
      default:
        return _buildGlassmorphismNav();
    }
  }

  Widget _buildGlassmorphismNav() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGlassNavItem(Icons.home_rounded, 0),
              _buildGlassNavItem(Icons.play_circle_filled, 1),
              _buildGlassNavItem(Icons.smart_toy_rounded, 2),
              _buildGlassNavItem(Icons.people_rounded, 3),
              _buildGlassNavItem(Icons.bar_chart_rounded, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.3)
              : Colors.transparent,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.white.withOpacity(0.5), width: 2)
              : null,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.green[700] : Colors.grey[700],
          size: isSelected ? 28 : 24,
        ),
      ),
    );
  }
}
