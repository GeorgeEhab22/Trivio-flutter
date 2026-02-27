import 'package:flutter/material.dart';
import 'package:auth/domain/entities/comment.dart';
import '../comment_item/comment_item.dart';

class CommentRepliesList extends StatelessWidget {
  final List<Comment> replies;
  final String currentUserId;
  final Function(Comment)? onReplyTap;

  const CommentRepliesList({
    super.key,
    required this.replies,
    required this.currentUserId,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: replies.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final reply = replies[index];
        return CommentItem(
          comment: reply,
          currentUserId: currentUserId,
          replies: reply.repliesList ?? [],
          onReplyTap: onReplyTap,
        );
      },
    );
  }
}
