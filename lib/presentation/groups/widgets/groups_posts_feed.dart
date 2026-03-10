import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_post_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroupsPostsFeed extends StatelessWidget {
  const GroupsPostsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = context.read<ProfileCubit>().state;
    String myUserId = '';

    if (profileState is ProfileLoaded) {
      myUserId = profileState.user.id;
    }
    return BlocBuilder<GroupPostsCubit, GroupPostsState>(
      builder: (context, state) {
        final cubit = context.read<GroupPostsCubit>();

        final bool isInitialLoading =
            state is GroupPostsLoading && cubit.posts.isEmpty;
        final bool isLoadingMore = state is GroupPostsLoadingMore;

        final displayPosts = isInitialLoading
            ? DummyData.dummyPosts
            : cubit.posts;

        if (state is GroupPostsLoaded && cubit.posts.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: Text(l10n.noPostsInGroups)),
          );
        }

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
                    return Skeletonizer(
                      enabled: true,
                      child: GroupPostCard(
                        post: DummyData.dummyPost,
                        currentUserId: myUserId,
                        isFollowing: true,
                      ),
                    );
                  }

                  if (cubit.hasReachedMax && cubit.posts.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(
                        child: Text(
                          l10n.noMorePosts,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  return const SizedBox(height: 50);
                }

                return GroupPostCard(
                  post: displayPosts[index],
                  currentUserId: myUserId,
                  isFollowing: true,
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
