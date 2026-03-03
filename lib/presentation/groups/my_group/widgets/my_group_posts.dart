import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_post_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyGroupPosts extends StatelessWidget {
  final String groupId;
  final String groupName;
  final String? groupCoverImage;

  const MyGroupPosts({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupCoverImage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<GroupPostsCubit, GroupPostsState>(
      builder: (context, state) {
        final cubit = context.read<GroupPostsCubit>();

        final bool isInitialLoading =
            (state is GroupPostsLoading || state is GroupPostsInitial) &&
            cubit.posts.isEmpty;
        final bool isLoadingMore = state is GroupPostsLoadingMore;

        final displayPosts = isInitialLoading
            ? DummyData.dummyPosts
            : cubit.posts;

        if (state is GroupPostsError && cubit.posts.isEmpty) {
          return SliverFillRemaining(child: Center(child: Text(state.message)));
        }

        return Skeletonizer.sliver(
          enabled: isInitialLoading,
          child: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= displayPosts.length) {
                  if (isLoadingMore) {
                    return const Skeletonizer(
                      enabled: true,
                      child: GroupPostCard(
                        post: DummyData.dummyPost,
                        currentUserId: '1',
                        isFollowing: false,
                      ),
                    );
                  }

                  if (cubit.hasReachedMax && cubit.posts.isNotEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          l10n.noMorePosts,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(height: 80);
                }

                final post = displayPosts[index];
                return GroupPostCard(
                  post: post.copyWith(
                    groupID: groupId,
                    groupName: groupName,
                    groupCoverImage: groupCoverImage,
                  ),
                  currentUserId: '1',
                  isFollowing: false,
                );
              },
              childCount:
                  displayPosts.length +
                  (isLoadingMore || cubit.hasReachedMax ? 1 : 0),
            ),
          ),
        );
      },
    );
  }
}
