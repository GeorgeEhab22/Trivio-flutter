import 'package:auth/domain/entities/post.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimelineListView extends StatelessWidget {
  const TimelineListView({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyPost = Post(
      postID: '10',
      authorId: '0',
      caption:
          'Loading content lines for skeleton effect.\nSecond line for better UI.',
      type: 'text',
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
          }, childCount: posts.length + (state is PostsLoadingMore ? 1 : 0)),
        );
      },
    );
  }
}
