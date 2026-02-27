import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_header.dart';
import '../lists/comment_replies_list.dart';
import 'package:auth/l10n/app_localizations.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String currentUserId;
  final Function(Comment comment)? onReplyTap;
  final List<Comment> replies;
  final ReactionType? initialReaction;

  const CommentItem({
    super.key,
    required this.comment,
    required this.currentUserId,
    this.onReplyTap,
    this.replies = const [],
    this.initialReaction,
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
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 56, end: 16),
          child: isEditing
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _editController,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: commentCubit.cancelReplyOrEdit,
                          child: Text(l10n.cancelBtn),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final updatedText = _editController.text.trim();
                            if (updatedText.isEmpty) return;
                            commentCubit.addOrUpdateComment(
                              widget.comment.postId,
                              updatedText,
                            );
                          },
                          child: Text(l10n.save),
                        ),
                      ],
                    ),
                  ],
                )
              : ExpandableText(
                  text: widget.comment.text,
                  previewLines: 2,
                  canCollapse: false,
                ),
        ),

        Padding(
          padding: const EdgeInsetsDirectional.only(start: 56, end: 16),
          child: Expanded(
            child: Row(
              children: [
                BlocProvider(
                  create: (context) => di.sl<PostInteractionCubit>(),
                  child: ReactionAction(
                    postId: widget.comment.id,
                    userId: widget.currentUserId,
                    initialReaction: widget.initialReaction ?? ReactionType.none,
                    initialCount: widget.comment.reactions.length,
                  ),
                ),
                if (!isReply)
                  TextButton(
                    onPressed: () {
                      if (widget.onReplyTap != null) {
                        widget.onReplyTap!(widget.comment);
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.reply,
                      style: const TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                const Spacer(),
                if(widget.comment.isEdited)
                  Text(
                    l10n.edited,
                    style: const TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (!isReply)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 56, end: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: isFetchingReplies
                    ? null
                    : () {
                       
                        context.read<CommentCubit>().toggleRepliesVisibility(
                          parentCommentId: widget.comment.id,
                          postId: widget.comment.postId,
                        );
                      },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isFetchingReplies
                      ? 'Loading replies...'
                      : (isRepliesExpanded ? 'Hide replies' : 'Show replies (${widget.comment.repliesCount})'),
                  style: const TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),

        if (isRepliesExpanded)
          Padding(
            padding: EdgeInsetsDirectional.only(start: isReply ? 40.0 : 50.0),
            child: isFetchingReplies
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : liveReplies.isNotEmpty
                    ? CommentRepliesList(
                        replies: liveReplies,
                        currentUserId: widget.currentUserId,
                        onReplyTap: widget.onReplyTap,
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text('No replies on this comment yet'),
                      ),
          ),
      ],
    );

    if (isReply) {
      return Container(
        margin: const EdgeInsetsDirectional.only(start: 40, bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: content,
    );
  }
}