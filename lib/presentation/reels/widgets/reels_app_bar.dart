import 'package:auth/constants/colors.dart';
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
      child: Container(
        color: Colors.black,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          bottom: 12,
          left: 16,
          right: 16,
        ),
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
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTabButton(
                  "For You",
                  isActive: true,
                  onTap: () {
                    //TODO: add logic to change tab in cubit later
                  },
                ),
                const SizedBox(width: 24),

                _buildTabButton(
                  "Following",
                  isActive: false,
                  onTap: () {
                    // TODO: add logic to change tab in cubit later
                  },
                ),
              ],
            ),

            const ReelsAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(
    String label, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.6),
                fontSize: 15,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            if (isActive)
              Container(
                width: double.infinity,
                height: 2.5,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              const SizedBox(height: 2.5),
          ],
        ),
      ),
    );
  }
}
