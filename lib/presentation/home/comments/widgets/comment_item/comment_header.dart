import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/widgets/author_info.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentHeader extends StatelessWidget {
  final Comment comment;
  final bool isOwner;
  final bool isReply;

  const CommentHeader({
    super.key,
    required this.comment,
    this.isOwner = false,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBgColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.035);
    final iconBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.08);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isReply ? 10 : 14,
        vertical: isReply ? 8 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AuthorInfo(
              authorName: comment.authorName,
              createdAt: comment.createdAt,
              avatarRadius: isReply ? 16 : 18,
              showTimeInline: true,
              authorTextStyle: Styles.textStyle15.copyWith(
                fontWeight: FontWeight.w700,
              ),
              authorImage: comment.authorImage ?? '',
            ),
          ),
           if (comment.isEdited )
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.09)
                      : Colors.black.withValues(alpha: 0.06),
                ),
                child: Text(
                  l10n.edited,
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: iconBgColor,
              border: Border.all(color: iconBorderColor),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_horiz_rounded,
                size: 19,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                final cubit = context.read<CommentCubit>();
                BottomSheetManager.showActions(
                  context,
                  comment: comment,
                  isOwner: isOwner,
                  cubit: cubit,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
