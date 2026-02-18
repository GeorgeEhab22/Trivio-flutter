import 'package:auth/presentation/home/posts_in_timeline/widgets/post_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_feed/get_groups_posts_feed_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_feed/get_groups_posts_feed_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsPostsFeed extends StatelessWidget {
  const GroupsPostsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetGroupsPostsFeedCubit, GetGroupsPostsFeedState>(
      builder: (context, state) {
        if (state is GetGroupsPostsFeedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetGroupsPostsFeedError) {
          return Center(child: Text(state.message));
        } else if (state is GetGroupsPostsFeedLoaded) {
          if (state.posts.isEmpty) {
            return const Center(
              child: Text("No posts in your groups yet. Join some!"),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return PostCard(
                // TODO: replace with real group data it is null now because of back end
                post: state.posts[index],
                currentUserId: "USER_ID_HERE",
                isFollowing: true,
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
