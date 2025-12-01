import 'package:auth/domain/entities/post.dart';
import 'package:auth/domain/entities/reaction_type.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/home/comments/comment_button.dart';
import 'package:auth/presentation/home/reactions/reaction_action.dart';
import 'package:auth/presentation/home/share_post/share_button.dart';
import 'package:auth/presentation/home/widgets/author_info.dart';
import 'package:auth/presentation/home/widgets/exbandable_text.dart';
import 'package:auth/presentation/manager/post_cubit/post_interaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_header.dart';
import 'post_image.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final ReactionType? currentReaction;
  const PostCard({super.key, required this.post, this.currentReaction});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double spacing = screenWidth < 350
        ? 12
        : screenWidth < 600
        ? 20
        : 28;

    return BlocProvider(
      create: (context) => di.sl<PostInteractionCubit>(),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: add navigation to single post page
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          color: Colors.white,
          elevation: 0.1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AuthorInfo(
                          authorName: post.authorName,
                          authorImage: post.authorImage,
                          createdAt: post.createdAt,
                          showTimeInline: false,
                        ),
                      ),
                      PostHeader(isFollowing: true),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  child: ExpandableText(
                    text: post.content,
                    previewLines: 2,
                    canCollapse: true,
                  ),
                ),
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 6),
                  PostImage(),
                ],
                const SizedBox(height: 8),
                Divider(
                  height: 1,
                  color: const Color(0xFFF3F4F6),
                  thickness: 0.7,
                  indent: 12,
                  endIndent: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      ReactionAction(
                        postId: post.id,
                        userId: post.authorId, //TODO: user.id not authorId..
                        initialReaction: currentReaction ?? ReactionType.none,
                        initialCount: post.reactions.length,
                      ),
                      SizedBox(width: spacing),
                      CommentButton(
                        commentsCount: post.comments.length,
                        reactionsCount: post.reactions.length,
                        onCommentAdded: () {},
                        onCommentDeleted: () {},
                      ),
                      SizedBox(width: spacing),
                      ShareButton(count: 0),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
