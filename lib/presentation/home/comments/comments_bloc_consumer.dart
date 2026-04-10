import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_cubit.dart';
import 'package:auth/presentation/manager/comment_cubit/comment_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/lists/comments_list.dart';

class CommentsBlocConsumer extends StatelessWidget {
  final String currentUserId;
  final String? targetCommentId;

  const CommentsBlocConsumer({super.key, required this.currentUserId,this.targetCommentId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<CommentCubit, CommentState>(
      listener: (context, state) {
        if (state is CommentActionError) {
          // Map the key from Cubit to localized string
          String errorMessage = _mapErrorToMessage(state.message, l10n);
          showCustomSnackBar(context, errorMessage, false);
        }

        if (state is CommentActionSuccess) {
          String successMessage = _mapSuccessToMessage(state.message, l10n);
          showCustomSnackBar(context, successMessage, true);
        }
      },
      buildWhen: (previous, current) {
        return current is CommentLoaded ||
            current is CommentLoading ||
            current is CommentError;
      },
      builder: (context, commentState) {
        // 1. Listen to ProfileCubit to get the "My Info"
        return BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            // 2. Helper function to patch comments
            List<Comment> patchComments(List<Comment> originalList) {
              if (profileState is! ProfileLoaded) return originalList;

              final myName = profileState.user.name;
              final myAvatar = profileState.user.avatar;

              return originalList.map((comment) {
                // Check if this comment belongs to the current user
                if (comment.authorId == currentUserId) {
                  // Only patch if info is actually missing or generic
                  bool needsPatch =
                      comment.authorName == 'Unknown User' ||
                      comment.authorName.isEmpty ||
                      comment.authorImage == null;

                  if (needsPatch) {
                    return comment.copyWith(
                      authorName:
                          (comment.authorName == 'Unknown User' ||
                              comment.authorName.isEmpty)
                          ? myName
                          : comment.authorName,
                      authorImage: comment.authorImage ?? myAvatar,
                    );
                  }
                }
                return comment;
              }).toList();
            }

            // 3. Handle States with Patched Data
            if (commentState is CommentLoading) {
              final commentsForSkeleton = patchComments(
                commentState.comments.isNotEmpty
                    ? commentState.comments
                    : _dummyComments,
              );
              return Skeletonizer(
                child: CommentsList(
                  comments: commentsForSkeleton,
                  currentUserId: currentUserId,
                  onReplyTap: (_) {},
                ),
              );
            } else if (commentState is CommentError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    _mapErrorToMessage(commentState.message, l10n),
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (commentState is CommentLoaded) {
              if (commentState.comments.isEmpty) {
                return _buildEmptyState(l10n);
              }

              // Patch the loaded comments before passing to the list
              final finalComments = patchComments(commentState.comments);

              return CommentsList(
                comments: finalComments,
                currentUserId: currentUserId,
                onReplyTap: (comment) {
                  context.read<CommentCubit>().triggerReply(comment);
                },
                targetCommentId:targetCommentId,
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  // Extracted empty state for cleaner code
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 34,
            color: Colors.grey[500],
          ),
          const SizedBox(height: 8),
          Text(l10n.noCommentsYet, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  static final List<Comment> _dummyComments = List.generate(
    5,
    (index) => Comment(
      id: 'skeleton-comment-$index',
      postId: 'skeleton-post',
      authorId: 'skeleton-author',
      authorName: 'Loading User',
      text: 'Loading comment content placeholder for skeleton state rendering.',
      createdAt: DateTime(2024, 1, 1),
    ),
  );

  String _mapErrorToMessage(String key, AppLocalizations l10n) {
    switch (key) {
      case "load_failed":
        return l10n.commentLoadError;
      case "add_failed":
        return l10n.commentAddError;
      case "delete_failed":
        return l10n.commentDeleteError;
      case "update_failed":
        return l10n.unexpected_error;
      case "report_failed":
        return l10n.unexpected_error;
      default:
        return key.isEmpty ? l10n.unexpected_error : key;
    }
  }

  String _mapSuccessToMessage(String key, AppLocalizations l10n) {
    switch (key) {
      case "added":
        return l10n.commentAdded;
      case "updated":
        return l10n.commentUpdated;
      case "deleted":
        return l10n.commentDeleted;
      case "reported":
        return l10n.commentReported;
      case "hidden":
        return l10n.commentHidden;
      default:
        return "";
    }
  }
}
