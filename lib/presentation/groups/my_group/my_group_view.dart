import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/my_group/widgets/create_post_row.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_cover_image.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_info.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_app_bar.dart';
import 'package:auth/presentation/groups/my_group/widgets/my_group_posts.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_group_posts/group_posts_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/update_group/update_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyGroupView extends StatelessWidget {
  final String groupId;
  const MyGroupView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const MyGroupAppBar(),
      body: BlocListener<UpdateGroupCubit, UpdateGroupState>(
        listener: (context, state) {
          if (state is UpdateGroupSuccess) {
            showCustomSnackBar(context, l10n.updateSuccessful, true);
          }
          if (state is UpdateGroupFailure) {
            showCustomSnackBar(context, state.message, false);
          }
        },
        child: BlocBuilder<GetGroupCubit, GetGroupState>(
          builder: (context, state) {
            if (state is GetGroupFailure) {
              return Center(child: Text(state.message));
            }
            final bool isGroupLoading = state is GetGroupLoading;
            final group = (state is GetGroupSuccess)
                ? state.group
                : DummyData.dummyGroup;

            return Skeletonizer(
              enabled: isGroupLoading,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo is ScrollUpdateNotification &&
                      (scrollInfo.scrollDelta ?? 0) > 0 &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent * 0.8) {
                    context.read<GroupPostsCubit>().getPosts(groupId: groupId);
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MyGroupCoverImage(
                            coverImage: group.groupCoverImage,
                            groupId: groupId,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyGroupInfo(
                                  groupName: group.groupName,
                                  groupId: groupId,
                                  description: group.groupDescription,
                                  membersCount:group.totalMembers,
                                ),
                                const SizedBox(height: 20),
                                CustomSquareButton(
                                  label: l10n.manage,
                                  height: 13,
                                  isExpanded: true,
                                  row: true,
                                  leadingIcon: Icons.security_outlined,
                                  backgroundColor: AppColors.primary,
                                  textColor: Colors.white,
                                  iconColor: Colors.white,
                                  onTap: () {
                                    context.push(
                                      AppRoutes.manageGroup(groupId),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                CreatePostRow(groupId: groupId),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.mostRelevant,
                                  style: Styles.textStyle16,
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    MyGroupPosts(
                      groupId: groupId,
                      groupName: group.groupName,
                      groupCoverImage: group.groupCoverImage,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
