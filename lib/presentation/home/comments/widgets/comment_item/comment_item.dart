import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'package:flutter/material.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_header.dart';
import 'comment_actions_row.dart';
import 'comment_body_section.dart';
import 'comment_replies_section.dart';
import 'reply_tree_wrapper.dart';
import 'package:auth/l10n/app_localizations.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String currentUserId;
  final Function(Comment comment)? onReplyTap;
  final List<Comment> replies;
  final ReactionType? initialReaction;
  final bool showReplyTree;
  final bool isLastReplyInThread;

  const CommentItem({
    super.key,
    required this.comment,
    required this.currentUserId,
    this.onReplyTap,
    this.replies = const [],
    this.initialReaction,
    this.showReplyTree = false,
    this.isLastReplyInThread = false,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final TextEditingController _editController = TextEditingController();
  String? _syncedEditingId;

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _syncEditor(bool isEditing) {
    if (!isEditing) {
      _syncedEditingId = null;
      return;
    }

    if (_syncedEditingId == widget.comment.id) {
      return;
    }

    _editController.text = widget.comment.text;
    _editController.selection = TextSelection.fromPosition(
      TextPosition(offset: _editController.text.length),
    );
    _syncedEditingId = widget.comment.id;
  }

  List<Comment> _getLiveReplies(CommentCubit cubit) {
    final state = cubit.state;
    if (state is CommentLoaded) {

      final structured = state.comments.cast<Comment>();
      final match = structured.cast<Comment?>().firstWhere(
            (c) => c?.id == widget.comment.id,
            orElse: () => null,
          );
      if (match != null && match.repliesList != null) {
        return match.repliesList!;
      }
    }
    return widget.replies;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final mutedTextColor = theme.colorScheme.onSurfaceVariant;
    final replyBackgroundColor = theme.brightness == Brightness.dark
        ? Color.alphaBlend(
            Colors.white.withValues(alpha: 0.04),
            theme.colorScheme.surface,
          )
        : Colors.grey[50]!;
    final commentCubit = context.watch<CommentCubit>();
    final bool isReply = widget.comment.isReply;
    final bool isEditing = commentCubit.editingComment?.id == widget.comment.id;
    final bool isOwner = widget.comment.authorId == widget.currentUserId;
    final bool isRepliesExpanded = commentCubit.isRepliesExpanded(
      widget.comment.id,
    );
    final bool isFetchingReplies = commentCubit.isRepliesLoading(
      widget.comment.id,
    );
    _syncEditor(isEditing);

    final liveReplies = _getLiveReplies(commentCubit);

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentHeader(isOwner: isOwner, comment: widget.comment),
        CommentBodySection(
          isEditing: isEditing,
          editController: _editController,
          text: widget.comment.text,
          l10n: l10n,
          onCancel: commentCubit.cancelReplyOrEdit,
          onSave: (updatedText) {
            commentCubit.addOrUpdateComment(widget.comment.postId, updatedText);
          },
        ),
        CommentActionsRow(
          comment: widget.comment,
          currentUserId: widget.currentUserId,
          isReply: isReply,
          mutedTextColor: mutedTextColor,
          initialReaction: widget.initialReaction,
          l10n: l10n,
          onReplyTap: widget.onReplyTap,
        ),
        CommentRepliesSection(
          comment: widget.comment,
          currentUserId: widget.currentUserId,
          isReply: isReply,
          isRepliesExpanded: isRepliesExpanded,
          isFetchingReplies: isFetchingReplies,
          mutedTextColor: mutedTextColor,
          liveReplies: liveReplies,
          onReplyTap: widget.onReplyTap,
          onToggleReplies: () {
            context.read<CommentCubit>().toggleRepliesVisibility(
              parentCommentId: widget.comment.id,
              postId: widget.comment.postId,
            );
          },
        ),
      ],
    );

    if (isReply) {
      return ReplyTreeWrapper(
        showReplyTree: widget.showReplyTree,
        isLastReplyInThread: widget.isLastReplyInThread,
        replyBackgroundColor: replyBackgroundColor,
        child: content,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: content,
    );
  }
}
