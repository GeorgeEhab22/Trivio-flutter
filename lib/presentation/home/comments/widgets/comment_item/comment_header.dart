import 'package:auth/common/functions/bottom_sheet_manager.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/widgets/author_info.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_state.dart';
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

    // 1. Check if name is generic/missing
    final bool isMissingInfo = 
        comment.authorName == 'Unknown User' || 
        comment.authorName.trim().isEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isReply ? 10 : 14,
        vertical: isReply ? 8 : 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: isMissingInfo
                ? BlocBuilder<GetUserProfileByIdCubit, GetUserProfileByIdState>(
                    builder: (context, state) {
                      String displayName = comment.authorName;
                      String? displayImage = comment.authorImage;

                      // 2. If info is missing and we aren't already loading/loaded this specific user
                      // We trigger the load. The Cubit's internal cache will prevent duplicate hits.
                      if (state is! GetUserProfileByIdLoading && state is! GetUserProfileByIdLoaded) {
                        context.read<GetUserProfileByIdCubit>().loadUserProfileById(comment.authorId);
                      }

                      // 3. If the state matches the user we are looking for, update the UI
                      if (state is GetUserProfileByIdLoaded && state.user.id == comment.authorId) {
                        displayName = state.user.name;
                        displayImage = state.user.avatar;
                      }

                      return AuthorInfo(
                        authorName: displayName,
                        createdAt: comment.createdAt,
                        avatarRadius: isReply ? 16 : 18,
                        showTimeInline: true,
                        authorTextStyle: Styles.textStyle15.copyWith(fontWeight: FontWeight.w700),
                        authorImage: displayImage ?? '',
                      );
                    },
                  )
                : AuthorInfo(
                    authorName: comment.authorName,
                    createdAt: comment.createdAt,
                    avatarRadius: isReply ? 16 : 18,
                    showTimeInline: true,
                    authorTextStyle: Styles.textStyle15.copyWith(fontWeight: FontWeight.w700),
                    authorImage: comment.authorImage ?? '',
                  ),
          ),
          
          // --- Rest of your UI (Edited tag & More button) ---
          if (comment.isEdited) _buildEditedTag(context, isDark, l10n),
          _buildMoreButton(context, isDark),
        ],
      ),
    );
  }

  Widget _buildEditedTag(BuildContext context, bool isDark, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isDark ? Colors.white.withValues(alpha: 0.09) : Colors.black.withValues(alpha: 0.06),
      ),
      child: Text(
        l10n.edited,
        style: TextStyle(
          color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
          fontSize: 11.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildMoreButton(BuildContext context, bool isDark) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: isDark ? Colors.white.withValues(alpha: 0.07) : Colors.black.withValues(alpha: 0.035),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.14) : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.more_horiz_rounded, size: 19),
        onPressed: () => BottomSheetManager.showActions(
          context,
          comment: comment,
          isOwner: isOwner,
          cubit: context.read<CommentCubit>(),
        ),
      ),
    );
  }
}