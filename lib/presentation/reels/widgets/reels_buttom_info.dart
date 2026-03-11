import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/follow_button.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:flutter/material.dart';

class ReelsBottomInfo extends StatelessWidget {
  final Post reel;
  final String currentUserId;

  const ReelsBottomInfo({
    super.key,
    required this.reel,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      bottom: 20,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                backgroundImage: reel.authorImage != null
                    ? NetworkImage(reel.authorImage!)
                    : null,
                child: reel.authorImage == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              ),
              const SizedBox(width: 10),

              Text(
                reel.authorName ?? 'wait backend',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              if (currentUserId != reel.authorId)
                FollowButton(
                  currentUserId: currentUserId,
                  authorId: reel.authorId,
                  initialFollowStatus: false,
                ),
            ],
          ),
          const SizedBox(height: 12),

          ExpandableText(
            text: reel.caption ?? '',
            previewLines: 2,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
