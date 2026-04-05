import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/home/comments/widgets/comment_action.dart';
import 'package:flutter/material.dart';

class ReelsCommentButton extends StatelessWidget {
  final Post reel;
  final String currentUserId;
  final VoidCallback onToggleComments;

  const ReelsCommentButton({
    super.key,
    required this.reel,
    required this.currentUserId,
    required this.onToggleComments,
  });

  @override
  Widget build(BuildContext context) {
    return CommentAction(
      postId: reel.postID,
      currentUserId: currentUserId,
      commentsCount: reel.commentsCount,
      isReelView: true,
      onReelsCommentTap: onToggleComments,
    );
  }
}
