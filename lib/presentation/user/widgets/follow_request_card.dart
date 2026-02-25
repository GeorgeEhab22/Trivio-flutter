import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/user_profile_preview.dart';
import 'package:flutter/material.dart';

class FollowRequestCard extends StatelessWidget {
  final UserProfilePreview follower;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FollowRequestCard({
    super.key,
    required this.follower,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Remove elevation
      color: Colors.transparent, // No background color
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lightGrey, width: 1), // Optional: thin border for definition
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.lightGrey,
              backgroundImage: (follower.avatarUrl != null && follower.avatarUrl!.isNotEmpty)
                  ? NetworkImage(follower.avatarUrl!)
                  : null,
              child: (follower.avatarUrl == null || follower.avatarUrl!.isEmpty)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                follower.name,
                style: Styles.textStyle20.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Square Action Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSquareButton(
                  icon: Icons.check,
                  color: Colors.green,
                  onTap: onAccept,
                ),
                const SizedBox(width: 8),
                _buildSquareButton(
                  icon: Icons.close,
                  color: Colors.red,
                  onTap: onDecline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // Light background for the square
          borderRadius: BorderRadius.circular(8), // Small radius for "square" look
          border: Border.all(color: color, width: 1.5),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}