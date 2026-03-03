import 'package:auth/presentation/home/posts_in_timeline/widgets/post_content.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_footer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_header.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/l10n/app_localizations.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final ReactionType? currentReaction;
  final bool isFollowing;

  const PostCard({
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
            } else if (state is ReportPostError) {
              showCustomSnackBar(context, state.message, false);
            } else if (state is FollowUserError) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
        BlocListener<PostCubit, PostState>(
          listener: (context, state) {
            if (state is EditPostSuccess &&
                state.updatedPost.postID == post.postID) {
              showCustomSnackBar(context, "Post updated successfully", true);
            } else if (state is DeletePostSuccess &&
                state.post.postID == post.postID) {
              showCustomSnackBar(context, "Post deleted successfully", true);
            } else if (state is PostError) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: BlocBuilder<PostInteractionCubit, PostInteractionState>(
        builder: (context, interactionState) {
          if (interactionState is ReportPostSuccess) {
            return const SizedBox.shrink();
          }
          final isProcessing = context.select<PostCubit, bool>((cubit) {
            final s = cubit.state;
            return (s is DeletePostLoading && s.postId == post.postID) ||
                (s is EditPostLoading && s.postId == post.postID);
          });

          final bool totalProcessing =
              isProcessing || (interactionState is ReportPostLoading);

          return Opacity(
            opacity: totalProcessing ? 0.5 : 1.0,
            child: AbsorbPointer(
              absorbing: totalProcessing,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
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
            ),
          );
        },
      ),
    );
  }
}
