import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:flutter/material.dart';

class CommentActionsMenu extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReply;
  final VoidCallback onReport;
  final VoidCallback onHide;

  final String commentText;
  final BuildContext parentContext;

  final bool isOwner;

  const CommentActionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
    required this.onReply,
    required this.onReport,
    required this.onHide,
    required this.commentText,
    required this.parentContext,
    required this.isOwner,
  });

  @override
  State<CommentActionsMenu> createState() => _CommentActionsMenuState();
}

class _CommentActionsMenuState extends State<CommentActionsMenu> {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.grey[700]),
      onPressed: () {
        BottomSheetManager.showActions(
          context,
          onEdit:  widget.onEdit,
          onDelete: widget.onDelete,
          onReply: widget.onReply,
          onReport: widget.onReport,
          onHide: widget.onHide,
          commentText: widget.commentText,
          isOwner: widget.isOwner,
        );
      },
    );
  }
}
