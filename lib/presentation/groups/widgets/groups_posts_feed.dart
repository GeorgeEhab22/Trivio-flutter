import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/groups/widgets/group_post_card.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GroupsPostsFeed extends StatelessWidget {
  const GroupsPostsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // return BlocBuilder<GroupPostsCubit, GroupPostsState>(
    //   builder: (context, state) {
    //     if (state is GetGroupsPostsFeedLoading) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (state is GetGroupsPostsFeedError) {
    //       return Center(child: Text(state.message));
    //     } else if (state is GetGroupsPostsFeedLoaded) {
    //       if (state.posts.isEmpty) {
    //         return Center(child: Text(l10n.noPostsInGroups));
    //       }

    //       return ListView.builder(
    //         shrinkWrap: true,
    //         physics: const NeverScrollableScrollPhysics(),
    //         itemCount: state.posts.length,
    //         itemBuilder: (context, index) {
    //           return PostCard(
    //             // TODO: replace with real group data it is null now because of back end
    //             post: state.posts[index],
    //             currentUserId: "69a1a4cbab9f71890ad97692",
    //             isFollowing: true,
    //           );
    //         },
    //       );
    //     }
        return const SizedBox();
    //  },
    //);
  }
}
