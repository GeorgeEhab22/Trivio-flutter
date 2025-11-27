import 'package:auth/domain/entities/comment.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/home/comments/widgets/comment_item.dart';

class CommentRepliesList extends StatelessWidget {
  final List<Comment> replies;
  final String currentUserId;
  final bool showReplies;

  const CommentRepliesList({
    super.key,
    required this.replies,
    required this.currentUserId,
    this.showReplies = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: replies.length,
      itemBuilder: (context, index) {
        final reply = replies[index];
        return CommentItem(
          key: ValueKey(reply.id),
          comment: reply,
          showReplies: false, // handle using cubit
          currentUserId: currentUserId,
          replyingTo: reply.parentCommentId ?? '',
          replies: [],
        );
      },
    );
  }
}
