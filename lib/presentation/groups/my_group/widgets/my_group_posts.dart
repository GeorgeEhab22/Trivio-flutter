import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyGroupPosts extends StatelessWidget {
  final String groupName;
  final String? groupCoverImage;

  const MyGroupPosts({super.key, required this.groupName, required this.groupCoverImage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupPostsCubit, GroupPostsState>(
      builder: (context, state) {
        final groupPostsCubit = context.read<GroupPostsCubit>();
        final bool isPostsLoading =
            state is GroupPostsLoading && groupPostsCubit.posts.isEmpty;
        final posts = (groupPostsCubit.posts.isNotEmpty)
            ? groupPostsCubit.posts
            : DummyData.dummyPosts;

        if (state is GroupPostsError && groupPostsCubit.posts.isEmpty) {
          return SliverFillRemaining(child: Center(child: Text(state.message)));
        }

        return Skeletonizer.sliver(
          enabled: isPostsLoading,
          child: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= posts.length) {
                  return const Skeletonizer(
                    enabled: true,
                    child: PostCard(
                      post: DummyData.dummyPost,
                      currentUserId: '1',
                      isFollowing: false,
                    ),
                  );
                }
                final post = posts[index];
                return PostCard(
                  post: post.copyWith(
                    groupName: groupName,
                    groupCoverImage: groupCoverImage,
                  ),
                  currentUserId: '1',
                  isFollowing: false,
                );
              },
              childCount:
                  posts.length + (state is GroupPostsLoadingMore ? 1 : 0),
            ),
          ),
        );
      },
    );
  }
}
