import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/l10n/app_localizations.dart';
import '../comment_item/comment_item.dart';

class CommentsList extends StatelessWidget {
  final List<Comment> comments;
  final String currentUserId;
  final ValueChanged<Comment> onReplyTap;

  const CommentsList({
    super.key,
    required this.comments,
    required this.currentUserId,
    required this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.noCommentsYet,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.iconsColor.withValues(alpha: 0.7)),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: comments.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return CommentItem(
          key: ValueKey(comment.id),
          comment: comment,
          currentUserId: currentUserId,
          onReplyTap: onReplyTap,
          replies: comment.repliesList ?? [],
        );
      },
    );
  }
}
