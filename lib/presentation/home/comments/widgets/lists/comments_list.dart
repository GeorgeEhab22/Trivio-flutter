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
        child: Text(
          l10n.noCommentsYet,
          style: TextStyle(color: AppColors.iconsColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: comments.length,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Column(
          children: [
            CommentItem(
              key: ValueKey(comment.id),
              comment: comment,
              currentUserId: currentUserId,
              onReplyTap: onReplyTap,
              replies: comment.repliesList ?? [],
            ),
          ],
        );
      },
    );
  }
}