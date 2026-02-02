import 'package:auth/presentation/home/posts_in_timeline/widgets/post_content.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_footer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_header.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';

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
    final postCubitState = context.watch<PostCubit>().state;
    final isDeleting =
        postCubitState is DeletePostLoading &&
        postCubitState.postId == post.postID;

    return Opacity(
      opacity: isDeleting ? 0.5 : 1,
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
  }
}
