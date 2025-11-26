import 'package:flutter/material.dart';
import 'package:auth/presentation/home/comments/widgets/comment_item.dart';

class CommentRepliesList extends StatelessWidget {
  final List<Map<String, dynamic>> replies;

  final void Function(String id, String newText) onEdit;
  final void Function(String id) onDelete;
  final void Function(String id, String username) onReply;

  final void Function(String id) onReport;
  final void Function(String id) onHide;

  final String currentUserId;

  const CommentRepliesList({
    super.key,
    required this.replies,
    required this.onEdit,
    required this.onDelete,
    required this.onReply,
    required this.onReport,
    required this.onHide,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: replies.length,
      itemBuilder: (context, index) {
        final reply = replies[index];
        final id = reply['id']?.toString() ?? 'reply_$index';
        return CommentItem(
          key: ValueKey(id), 
          comment: reply,
          onEdit: onEdit,
          onDelete: onDelete,
          onReply: onReply,
          onReport: onReport,
          onHide: onHide,
          currentUserId: currentUserId,
          isReply: true,
          replyingTo: reply["replyingTo"] ?? '',
        );
      },
    );
  }
}
