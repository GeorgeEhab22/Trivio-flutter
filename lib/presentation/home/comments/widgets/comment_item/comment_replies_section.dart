import 'package:auth/common/functions/number_extensions.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool shouldShowToggle =
        comment.repliesCount > 0 || isRepliesExpanded || isFetchingReplies;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isReply && shouldShowToggle)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 56, end: 16, top: 6),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: isFetchingReplies ? null : onToggleReplies,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.035),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.14)
                          : Colors.black.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isRepliesExpanded
                            ? Icons.unfold_less_rounded
                            : Icons.subdirectory_arrow_right_rounded,
                        size: 14,
                        color: mutedTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isFetchingReplies
                            ? l10n.loadingReplies
                            : (isRepliesExpanded
                                  ? l10n.hideReplies
                                  : l10n.showRepliesCount(comment.repliesCount).localizeDigits(context)),
                        style: TextStyle(
                          color: mutedTextColor,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (isRepliesExpanded)
          Padding(
            padding:
                EdgeInsetsDirectional.only(start: isReply ? 38.0 : 52.0, top: 6),
            child: isFetchingReplies
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : liveReplies.isNotEmpty
                ? CommentRepliesList(
                    replies: liveReplies,
                    currentUserId: currentUserId,
                    onReplyTap: onReplyTap,
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      l10n.noRepliesOnCommentYet,
                      style: TextStyle(
                        color: mutedTextColor,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}
