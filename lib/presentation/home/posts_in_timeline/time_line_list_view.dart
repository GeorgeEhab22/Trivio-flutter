import 'package:auth/domain/entities/post.dart';
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
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        final posts = context.read<PostCubit>().posts;
        //TODO remove to your id to test delete and edit post
        final currentUserId = '1';

        if (state is PostLoading && posts.isEmpty) {
          return Skeletonizer.sliver(
            enabled: true,
            child: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => PostCard(
                  post: dummyPost,
                  currentUserId: currentUserId,
                  isFollowing: false,
                ),
                childCount: 3,
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= posts.length) {
              return Skeletonizer(
                enabled: true,
                child: PostCard(
                  post: dummyPost,
                  currentUserId: currentUserId,
                  isFollowing: false,
                ),
              );
            }

            return PostCard(
              post: posts[index],
              currentUserId: currentUserId,
              isFollowing: false,
            );
          }, childCount: posts.length + (state is PostsLoadingMore ? 1 : 0)),
        );
      },
    );
  }
}
