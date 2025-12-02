import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/post_card.dart';

class PostsBlocConsumer extends StatelessWidget {
  const PostsBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyPost = Post(
      id: '10',
      authorId: '0',
      authorName: 'Loading User...........',
      authorImage: '',
      content:
          'Loading content lines for skeleton effect.\nSecond line for better UI.',
      createdAt: DateTime.now(),
      comments: const [],
      reactions: const [],
      isSaved: false,
      isEdited: false,
    );

    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostsLoadingMoreError) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final cubit = context.read<PostCubit>();
        final posts = cubit.posts;

        if (state is PostLoading && posts.isEmpty) {
          return Skeletonizer.sliver(
            enabled: true,
            child: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return PostCard(
                  post: dummyPost,
                  currentUserId: '1',
                  isFollowing: false,
                );
              }, childCount: 1),
            ),
          );
        }

        if (state is PostError && posts.isEmpty) {
          return SliverFillRemaining(child: Center(child: Text(state.message)));
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= posts.length) {
              return Skeletonizer(
                enabled: true,
                child: PostCard(
                  post: dummyPost,
                  currentUserId: '1',
                  isFollowing: false,
                ),
              );
            }
            return PostCard(
              post: posts[index],
              currentUserId: '1',
              isFollowing: false,
            );
            
            // num of posts that will show in timeline
          }, childCount: posts.length + (state is PostsLoadingMore ? 1 : 0)),
        );
      },
    );
  }
}
