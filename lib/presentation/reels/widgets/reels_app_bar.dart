import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/reels/buttons/reels_add_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReelsAppBar extends StatelessWidget {
  const ReelsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTabButton("Reels", isActive: true),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 15),
                  _buildTabButton("Friends", isActive: false),
                ],
              ),
              ReelsAddButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, {required bool isActive}) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 153),
          fontSize: 18,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          shadows: const [
            Shadow(
              offset: Offset(0, 1),
              blurRadius: 3.0,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
