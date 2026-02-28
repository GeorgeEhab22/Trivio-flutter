import 'package:auth/constants/colors.dart';
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
            BlocProvider(
              create: (context) => di.sl<PostInteractionCubit>(),
              child: ReactionAction(
                postId: comment.id,
                userId: currentUserId,
                initialReaction: initialReaction ?? ReactionType.none,
                initialCount: comment.reactions.length,
              ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            const Spacer(),
           
          ],
        ),
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  final Color color;

  const _ActionDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      color: AppColors.primary,
    );
  }
}
