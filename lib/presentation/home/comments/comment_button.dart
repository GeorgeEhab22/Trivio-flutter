import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/post_action_item.dart';
import 'package:auth/presentation/home/comments/comments_buttom_sheet.dart';

class CommentButton extends StatelessWidget {
  final int reactionsCount;
  final int commentsCount;
  final VoidCallback onCommentAdded;
  final VoidCallback onCommentDeleted;

  const CommentButton({
    super.key,
    required this.reactionsCount,
    required this.onCommentAdded,
    required this.onCommentDeleted,
    required this.commentsCount,
  });

  void _openComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
      builder: (context) => CommentsBottomSheet(
        reactionsCount: reactionsCount,
        onCommentAdded: onCommentAdded,
        onCommentDeleted: onCommentDeleted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PostActionItem(
      icon: FaIcon(FontAwesomeIcons.comment, size: 22),
      count: commentsCount,
      onTap: () => _openComments(context),
    );
  }
}
