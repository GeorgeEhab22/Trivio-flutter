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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Follower Avatar
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
            
            // Follower Name
            Expanded(
              child: Text(
                follower.name,
                style: Styles.textStyle20.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // Accept/Decline Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onAccept,
                  icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                  tooltip: 'Accept',
                ),
                IconButton(
                  onPressed: onDecline,
                  icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
                  tooltip: 'Decline',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}