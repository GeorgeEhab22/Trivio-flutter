import 'package:auth/domain/entities/comment.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/home/comments/widgets/comment_item.dart';

class CommentsList extends StatelessWidget {
  final List<Comment> comments;
  final GlobalKey<AnimatedListState> listKey;
  final String currentUserId;
  final ScrollController scrollController;
  const CommentsList({
    super.key,
    required this.comments,
    required this.listKey,
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
            child: KeyedSubtree(
              key: ValueKey(comment.id),
              child: CommentItem(
                comment: comment,
                currentUserId: currentUserId,
                showReplies: false, // handle using cubit
                replies: [], // handle using cubit
              ),
            ),
          ),
        );
      },
    );
  }
}
