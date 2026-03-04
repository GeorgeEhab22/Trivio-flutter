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
      elevation: 0,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      // Outer border removed by removing the 'side' property
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.lightGrey,
              backgroundImage:
                  (follower.avatarUrl != null && follower.avatarUrl!.isNotEmpty)
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

            // Minimal Action Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMinimalButton(icon: Icons.check, onTap: onAccept),
                const SizedBox(width: 18),
                _buildMinimalButton(icon: Icons.close, onTap: onDecline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Updated helper for a cleaner, borderless look
  Widget _buildMinimalButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        alignment: Alignment.center,
        child: Icon(icon, size: 30),
      ),
    );
  }
}
