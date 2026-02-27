import 'package:auth/domain/entities/comment.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/comments/widgets/lists/comment_replies_list.dart';
import 'package:flutter/material.dart';

class CommentRepliesSection extends StatelessWidget {
  final Comment comment;
  final String currentUserId;
  final bool isReply;
  final bool isRepliesExpanded;
  final bool isFetchingReplies;
  final Color mutedTextColor;
  final List<Comment> liveReplies;
  final Function(Comment comment)? onReplyTap;
  final VoidCallback onToggleReplies;

  const CommentRepliesSection({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.isReply,
    required this.isRepliesExpanded,
    required this.isFetchingReplies,
    required this.mutedTextColor,
    required this.liveReplies,
    required this.onToggleReplies,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isReply)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 56, end: 16),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: isFetchingReplies ? null : onToggleReplies,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isFetchingReplies
                      ? l10n.loadingReplies
                      : (isRepliesExpanded
                            ? l10n.hideReplies
                            : l10n.showRepliesCount(comment.repliesCount)),
                  style: TextStyle(
                    color: mutedTextColor,
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
                    currentUserId: currentUserId,
                    onReplyTap: onReplyTap,
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(l10n.noRepliesOnCommentYet),
                  ),
          ),
      ],
    );
  }
}
