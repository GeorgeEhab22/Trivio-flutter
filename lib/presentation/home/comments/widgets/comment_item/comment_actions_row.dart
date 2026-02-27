import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentActionsRow extends StatelessWidget {
  final Comment comment;
  final String currentUserId;
  final bool isReply;
  final Color mutedTextColor;
  final ReactionType? initialReaction;
  final AppLocalizations l10n;
  final Function(Comment comment)? onReplyTap;

  const CommentActionsRow({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.isReply,
    required this.mutedTextColor,
    required this.l10n,
    this.initialReaction,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 56, end: 16),
      child: Row(
        children: [
          BlocProvider(
            create: (context) => di.sl<PostInteractionCubit>(),
            child: ReactionAction(
              postId: comment.id,
              userId: currentUserId,
              initialReaction: initialReaction ?? ReactionType.none,
              initialCount: comment.reactions.length,
            ),
          ),
          if (!isReply)
            TextButton(
              onPressed: () {
                if (onReplyTap != null) {
                  onReplyTap!(comment);
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.reply,
                style: TextStyle(
                  color: mutedTextColor,
                  fontSize: 13,
                ),
              ),
            ),
          const Spacer(),
          if (comment.isEdited || comment.editedAt != null)
            Text(
              l10n.edited,
              style: TextStyle(
                color: mutedTextColor,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
