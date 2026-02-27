import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/comments/widgets/comment_action.dart';
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:auth/presentation/home/share_post/send_post_button.dart';
import 'package:auth/presentation/home/share_post/share_button.dart';
import 'package:flutter/material.dart';

class PostFooter extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final ReactionType? currentReaction;

  const PostFooter({
    super.key,
    required this.post,
    required this.currentUserId,
    this.currentReaction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : const Color(0xFFF2F5F3);
    final dividerColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: panelColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: ReactionAction(
                        postId: post.postID ?? '',
                        userId: currentUserId,
                        initialReaction: currentReaction ?? ReactionType.none,
                        initialCount: post.reactions?.length ?? 0,
                      ),
                    ),
                  ),
                  _ActionDivider(color: dividerColor),
                  Expanded(
                    child: Center(
                      child: CommentAction(
                        postId: post.postID ?? '',
                        currentUserId: currentUserId,
                        commentsCount: post.commentsCount,
                      ),
                    ),
                  ),
                  _ActionDivider(color: dividerColor),
                  const Expanded(
                    child: Center(
                      child: ShareButton(count: 0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF42C83C), Color(0xFF7BDC5B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF42C83C).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: SendPostButton(
                  postId: post.postID ?? '',
                  compact: true,
                  iconColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  final Color color;

  const _ActionDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 20, color: color);
  }
}
