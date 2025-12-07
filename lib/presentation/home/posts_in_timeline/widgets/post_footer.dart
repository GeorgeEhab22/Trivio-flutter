import 'package:auth/presentation/home/share_post/send_post_button.dart';
import 'package:flutter/material.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:auth/presentation/home/comments/widgets/comment_action.dart';
import 'package:auth/presentation/home/share_post/share_button.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final double spacing = screenWidth < 350 ? 12 : screenWidth < 600 ? 20 : 28;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ReactionAction(
            postId: post.postID??'',
            userId: currentUserId,
            initialReaction: currentReaction ?? ReactionType.none,
            initialCount: post.reactions?.length ?? 0,
          ),
          SizedBox(width: spacing),
          CommentAction(
            postId: post.postID??'',
            currentUserId: currentUserId,
            //TODO : implement comments count later
            commentsCount:  0,
          ),
          SizedBox(width: spacing),
          ShareButton(count: 0),

          const Spacer(),
         SendPostButton(postId: post.postID??''),
        ],
      ),
    );
  }
}