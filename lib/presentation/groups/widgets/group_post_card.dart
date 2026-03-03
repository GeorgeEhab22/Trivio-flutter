import 'package:auth/presentation/home/posts_in_timeline/widgets/post_content.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_footer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_header.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/l10n/app_localizations.dart';

class GroupPostCard extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final ReactionType? currentReaction;
  final bool isFollowing;

  const GroupPostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.isFollowing,
    this.currentReaction,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<PostInteractionCubit, PostInteractionState>(
          listener: (context, state) {
            if (state is ReportPostSuccess) {
              showCustomSnackBar(context, l10n.reportPostSuccess, true);
            }
          },
        ),
        BlocListener<GroupPostsCubit, GroupPostsState>(
          listener: (context, state) {
            if (state is GroupPostsEditSuccess &&
                state.updatedPost.postID == post.postID) {
              showCustomSnackBar(context, "Group post updated", true);
            } else if (state is GroupPostsDeleteSuccess &&
                state.post.postID == post.postID) {
              showCustomSnackBar(context, "Group post deleted", true);
            }
          },
        ),
      ],
      child: BlocBuilder<GroupPostsCubit, GroupPostsState>(
        buildWhen: (previous, current) {
          return (current is GroupPostsEditing &&
                  current.postId == post.postID) ||
              (current is GroupPostsDeleting &&
                  current.postId == post.postID) ||
              (current is GroupPostsLoaded);
        },
        builder: (context, groupPostsState) {
          final interactionState = context.watch<PostInteractionCubit>().state;
          if (interactionState is ReportPostSuccess) {
            return const SizedBox.shrink();
          }

          bool isProcessing = false;
          if ((groupPostsState is GroupPostsDeleting &&
                  groupPostsState.postId == post.postID) ||
              (groupPostsState is GroupPostsEditing &&
                  groupPostsState.postId == post.postID)) {
            isProcessing = true;
          }
          if (interactionState is ReportPostLoading) isProcessing = true;

          return Opacity(
            opacity: isProcessing ? 0.5 : 1.0,
            child: AbsorbPointer(
              absorbing: isProcessing,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: Theme.of(context).appBarTheme.backgroundColor,
                elevation: 0.2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostHeader(
                        post: post,
                        currentUserId: currentUserId,
                        isFollowing: isFollowing,
                      ),
                      PostContent(post: post),
                      const SizedBox(height: 8),
                      const Divider(
                        height: 1,
                        color: Color(0xFFF3F4F6),
                        thickness: 0.7,
                        indent: 12,
                        endIndent: 12,
                      ),
                      PostFooter(
                        post: post,
                        currentUserId: currentUserId,
                        currentReaction: currentReaction,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
