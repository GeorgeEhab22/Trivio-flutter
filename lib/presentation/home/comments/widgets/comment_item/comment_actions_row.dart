import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/reactions/reaction_interaction.dart';
import 'package:auth/presentation/home/reactions/reactions_screen.dart';
import 'package:auth/presentation/home/widgets/people_reacted.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentActionsRow extends StatelessWidget {
  // TODO: Remove this presentation fallback once auth/session user id is always available.
  static const String _presentationReactionUserId = '69a1a4cbab9f71890ad97692';

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
    const effectiveCurrentUserId = _presentationReactionUserId;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelColor = Colors.transparent;
    final currentReaction = _resolveCurrentUserReaction(effectiveCurrentUserId);
    final reactionsCount = _resolveReactionsCount(currentReaction);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.07);
    final trailingTextColor = isDark
        ? Colors.white.withValues(alpha: 0.88)
        : const Color(0xFF1F2937);
    final hasReactions = reactionsCount > 0;

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
            Expanded(
              child: Row(
                children: [
                  ReactionInteraction(
                    reactionType: currentReaction,
                    count: reactionsCount,
                    onTap: () {
                      context.read<CommentCubit>().toggleReactionOnComment(
                        commentId: comment.id,
                        currentUserId: effectiveCurrentUserId,
                        currentReaction: currentReaction,
                      );
                    },
                    onReactionSelected: (chosenReaction) {
                      context.read<CommentCubit>().chooseReactionOnComment(
                        commentId: comment.id,
                        currentUserId: effectiveCurrentUserId,
                        chosenReaction: chosenReaction,
                        currentReaction: currentReaction,
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
                              style: TextStyle(
                                color: mutedTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasReactions) ...[
              const SizedBox(width: 8),
              PeopleReacted(
                color: trailingTextColor,
                topReactions: _topReactionTypes(),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReactionsScreen.forComment(
                        commentId: comment.id,
                        currentUserId: effectiveCurrentUserId,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  ReactionType _resolveCurrentUserReaction(String effectiveCurrentUserId) {
    if (initialReaction != null && initialReaction != ReactionType.none) {
      return initialReaction!;
    }
    if (comment.userReaction != ReactionType.none) {
      return comment.userReaction;
    }
    for (final reaction in comment.reactions.reversed) {
      if (reaction.userId == effectiveCurrentUserId) {
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

  List<ReactionType> _topReactionTypes() {
    if (comment.reactionCountsByType.isNotEmpty) {
      final sortedByCount = comment.reactionCountsByType.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return sortedByCount.map((entry) => entry.key).take(3).toList();
    }

    if (comment.reactions.isEmpty) {
      return const <ReactionType>[];
    }
    final counts = <ReactionType, int>{};
    for (final reaction in comment.reactions) {
      if (reaction.type == ReactionType.none) {
        continue;
      }
      counts.update(reaction.type, (value) => value + 1, ifAbsent: () => 1);
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.map((entry) => entry.key).take(3).toList();
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
