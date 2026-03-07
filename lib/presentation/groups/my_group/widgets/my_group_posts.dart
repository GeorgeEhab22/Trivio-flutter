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

    final profileState = context.read<ProfileCubit>().state;
    String myUserId = ''; 
    
    if (profileState is ProfileLoaded) {
      myUserId = profileState.user.id; 
    }

    return BlocBuilder<GroupPostsCubit, GroupPostsState>(
      builder: (context, state) {
        final cubit = context.read<GroupPostsCubit>();

        final bool isLoading = (state is GroupPostsLoading);
        final bool isLoadingMore = state is GroupPostsLoadingMore;

        final displayPosts = isLoading ? DummyData.dummyPosts : cubit.posts;

        if (state is GroupPostsError && cubit.posts.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text(state.message)),
          );
        }

        if (!isLoading && cubit.posts.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false, 
            child: Center(
              child: Text(
                l10n.noPostsInGroups, 
                style: const TextStyle(
                  color: Colors.grey, 
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        return Skeletonizer.sliver(
          enabled: isLoading,
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
                        isFollowing: false,
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
                  return const SizedBox(height: 80);
                }

                final post = displayPosts[index];
                return GroupPostCard(
                  post: post.copyWith(
                    groupID: groupId,
                    groupName: groupName,
                    groupCoverImage: groupCoverImage,
                  ),
                  currentUserId: myUserId, 
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