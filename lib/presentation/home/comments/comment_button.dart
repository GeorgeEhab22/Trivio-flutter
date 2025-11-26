import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/post_action_item.dart';

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

  

  @override
  Widget build(BuildContext context) {
    return PostActionItem(
      icon: FaIcon(FontAwesomeIcons.comment, size: 22),
      count: commentsCount,
      onTap: () => BottomSheetManager.openComments(context,
        reactionsCount: reactionsCount,
        onCommentAdded: onCommentAdded,
        onCommentDeleted: onCommentDeleted,
      ),
    );
  }
}
