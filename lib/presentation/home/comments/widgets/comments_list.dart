import 'package:flutter/material.dart';
import 'package:auth/presentation/home/comments/widgets/comment_item.dart';

class CommentsList extends StatelessWidget {
  final List<Map<String, dynamic>> comments;
  final GlobalKey<AnimatedListState> listKey;

  final void Function(String id, String newText) onEdit;
  final void Function(String id) onDelete;
  final void Function(String id, String username) onReply;

  final void Function(String id) onReport;
  final void Function(String id) onHide;

  final String currentUserId;

  final ScrollController scrollController;

  const CommentsList({
    super.key,
    required this.comments,
    required this.listKey,
    required this.onEdit,
    required this.onDelete,
    required this.onReply,
    required this.onReport,
    required this.onHide,
    required this.currentUserId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      initialItemCount: comments.length,
      itemBuilder: (context, index, animation) {
        final comment = comments[index];
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: FadeTransition(
            opacity: animation,
            child: CommentItem(
              comment: comment,
              onEdit: onEdit,
              onDelete: onDelete,
              onReply: onReply,
              onReport: onReport,
              onHide: onHide,
              currentUserId: currentUserId,
            ),
          ),
        );
      },
    );
  }
}
