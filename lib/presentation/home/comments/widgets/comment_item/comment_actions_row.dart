import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/reactions/reaction_interaction.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = Colors.transparent;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.07);

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 56, end: 16, top: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: panelColor,
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Builder(
              builder: (context) {
                final currentReaction = _resolveCurrentUserReaction();
                final count = _resolveReactionsCount(currentReaction);
                return ReactionInteraction(
                  reactionType: currentReaction,
                  count: count,
                  onTap: () {
                    context.read<CommentCubit>().toggleReactionOnComment(
                      commentId: comment.id,
                      currentUserId: currentUserId,
                      currentReaction: currentReaction,
                    );
                  },
                  onReactionSelected: (chosenReaction) {
                    context.read<CommentCubit>().chooseReactionOnComment(
                      commentId: comment.id,
                      currentUserId: currentUserId,
                      chosenReaction: chosenReaction,
                      currentReaction: currentReaction,
                    );
                  },
                );
              },
            ),
            if (!isReply) ...[
              const SizedBox(width: 8),
              _ActionDivider(color: borderColor),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  if (onReplyTap != null) {
                    onReplyTap!(comment);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply_rounded,
                        size: 14,
                        color: mutedTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.reply,
                        style: TextStyle(color: mutedTextColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }

  ReactionType _resolveCurrentUserReaction() {
    if (initialReaction != null && initialReaction != ReactionType.none) {
      return initialReaction!;
    }
    if (comment.userReaction != ReactionType.none) {
      return comment.userReaction;
    }
    for (final reaction in comment.reactions.reversed) {
      if (reaction.userId == currentUserId) {
        return reaction.type;
      }
    }
    return ReactionType.none;
  }

  int _resolveReactionsCount(ReactionType currentReaction) {
    final count = comment.reactionsCount > 0
        ? comment.reactionsCount
        : comment.reactions.length;
    if (count == 0 && currentReaction != ReactionType.none) {
      return 1;
    }
    return count;
  }
}

class _ActionDivider extends StatelessWidget {
  final Color color;

  const _ActionDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 20, color: AppColors.primary);
  }
}
