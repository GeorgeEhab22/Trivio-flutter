import 'package:auth/presentation/home/posts_in_timeline/widgets/post_content.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_footer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_header.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';

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
    return BlocProvider(
      create: (context) => di.sl<PostInteractionCubit>(),
      child: Builder(
        builder: (innerContext) {
          return BlocConsumer<PostInteractionCubit, PostInteractionState>(
            listener: (context, state) {
              if (state is ReportPostSuccess) {
                showCustomSnackBar(context, 'Post reported successfully', true);
              }
              if (state is ReportPostError) {
                showCustomSnackBar(context, state.message, false);
              }
              if (state is FollowUserError) {
                showCustomSnackBar(context, state.message, false);
              }
            },
            builder: (context, state) {
              if (state is ReportPostSuccess) {
                return const SizedBox.shrink();
              }

              final postCubitState = context.watch<PostCubit>().state;
              final isDeleting = postCubitState is DeletePostLoading && postCubitState.postId == post.postID;

              return Opacity(
                opacity: (isDeleting || state is ReportPostLoading) ? 0.5 : 1,
                child: InkWell(
                  onTap: () {
                    // TODO : fetch single post
                  },
                  borderRadius: BorderRadius.circular(16),
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
          );
        },
      ),
    );
  }
}