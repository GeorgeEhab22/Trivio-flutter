import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction.dart';
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
    final resolvedReaction = _resolveCurrentUserReaction();
    var resolvedCount = post.reactionsCount > 0
        ? post.reactionsCount
        : (post.reactions?.length ?? 0);
    if (resolvedReaction != ReactionType.none && resolvedCount == 0) {
      resolvedCount = 1;
    }
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
                  ReactionAction(
                    postId: post.postID ?? '',
                    initialReaction: resolvedReaction,
                    initialCount: resolvedCount,
                    initialReactionId: _resolveCurrentUserReactionId(),
                  ),
                  _ActionDivider(color: dividerColor),
                  CommentAction(
                    postId: post.postID ?? '',
                    currentUserId: currentUserId,
                    commentsCount: post.commentsCount,
                  ),
                  _ActionDivider(color: dividerColor),
                  ShareButton(count: 0),
                  _ActionDivider(color: dividerColor),
                  SizedBox(width: 10,),
                  SendPostButton(
                    postId: post.postID ?? '',
                    compact: true,
                    iconColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ReactionType _resolveCurrentUserReaction() {
    if (currentReaction != null && currentReaction != ReactionType.none) {
      return currentReaction!;
    }
    if (post.userReaction != ReactionType.none) {
      return post.userReaction;
    }

    final List<Reaction>? reactions = post.reactions;
    if (reactions == null || reactions.isEmpty) {
      return ReactionType.none;
    }

    for (final reaction in reactions.reversed) {
      if (reaction.userId == currentUserId) {
        return reaction.type;
      }
    }
    return ReactionType.none;
  }

  String? _resolveCurrentUserReactionId() {
    final List<Reaction>? reactions = post.reactions;
    if (reactions == null || reactions.isEmpty) {
      return null;
    }

    for (final reaction in reactions.reversed) {
      if (reaction.userId == currentUserId) {
        final id = reaction.id.trim();
        if (id.isNotEmpty) {
          return id;
        }
      }
    }
    return null;
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
