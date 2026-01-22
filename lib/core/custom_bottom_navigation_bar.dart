// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/core/app_routes.dart';

class GlassmorphismNav extends StatefulWidget {
  final Map<int, String>? routeForIndex;
  final int currentIndex; // Controlled from AuthShell

  const GlassmorphismNav({
    super.key,
    this.routeForIndex,
    required this.currentIndex,
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

    _routeForIndex = widget.routeForIndex ??
        {
          0: AppRoutes.home,
          1: AppRoutes.reels,
          2: AppRoutes.chatbot,
          3: AppRoutes.groups,
          4: AppRoutes.stats,
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
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    final routeName = _routeForIndex[index];
    if (routeName == null) return;

    // Use go() so route is replaced and URL updates
    GoRouter.of(context).go(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
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
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
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


// ----------------- Dummy pages (you already had these) -----------------
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Theme.of( context).scaffoldBackgroundColor,
      child: const Center(
        child: Text("📊 Stats Page", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ChatBotPage extends StatelessWidget {
  const ChatBotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: Text("🤖 ChatBot Page", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: Text("🎬 Reels Page", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: Text("👥 Group Page", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
