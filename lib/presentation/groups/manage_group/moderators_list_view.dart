import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:auth/presentation/groups/widgets/dummy_for_skeletonizer.dart';
import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_state.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_group/get_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/kick_member/kick_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/kick_member/kick_member_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_members_by_roles/members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_members_by_roles/members_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ModeratorsListView extends StatelessWidget {
  final String groupId;
  const ModeratorsListView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<ChangeMemberRoleCubit, ChangeMemberRoleState>(
          listener: (context, state) {
            if (state is ChangeMemberRoleSuccess) {
              showCustomSnackBar(context, state.message, true);
              context.read<GroupMembersCubit>().updateMemberRoleLocally(
                state.userId,
                state.newRole,
              );
            }
          },
        ),
        BlocListener<BanMemberCubit, BanMemberState>(
          listener: (context, state) {
            if (state is BanMemberSuccess) {
              showCustomSnackBar(context, state.message, true);
              context.read<GroupMembersCubit>().removeMemberLocally(
                state.userId,
              );
            }
          },
        ),
        BlocListener<KickMemberCubit, KickMemberState>(
          listener: (context, state) {
            if (state is KickMemberSuccess) {
              showCustomSnackBar(context, state.message, true);
              context.read<GroupMembersCubit>().removeMemberLocally(
                state.userId,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<GroupMembersCubit, GroupMembersState>(
          builder: (context, state) {
            final cubit = context.read<GroupMembersCubit>();
            final groupState = context.read<GetGroupCubit>().state;
            String myRoleInGroup = 'member';
            if (groupState is GetGroupSuccess) {
              myRoleInGroup = groupState.group.role ?? 'member';
            }
            final bool isInitialLoading =
                state.isLoading && state.moderators.isEmpty;
            final bool isLoadingMore = state.isLoadingMoreModerators;

            final displayModerators = isInitialLoading
                ? DummyData.dummyMembers
                : [
                    ...state.moderators,
                    if (isLoadingMore) DummyData.dummyMember,
                  ];

            if (!isInitialLoading && state.moderators.isEmpty) {
              return Center(child: Text(l10n.noModeratorsFound));
            }

            return Skeletonizer(
              enabled: isInitialLoading,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo is ScrollUpdateNotification &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent * 0.8) {
                    cubit.loadMoreModerators(groupId);
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount:
                      displayModerators.length +
                      (state.hasReachedMaxModerators ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == displayModerators.length) {
                      return const SizedBox(height: 50);
                    }

                    final moderator = displayModerators[index];
                    return Skeletonizer(
                      enabled: isInitialLoading || moderator.userId!.isEmpty,
                      child: MemberRow(
                        name: moderator.userName,
                        image: moderator.profileImageUrl,
                        role: moderator.role ?? l10n.moderator,
                        targetUserId: moderator.userId, 
                        myRole: myRoleInGroup,
                        onRoleChanged: (newRole) {
                          context
                              .read<ChangeMemberRoleCubit>()
                              .changeMemberRole(
                                groupId: groupId,
                                userId: moderator.userId!,
                                newRole: newRole,
                              );
                        },
                        onBan: () => context.read<BanMemberCubit>().banMember(
                          groupId: groupId,
                          targetUserId: moderator.userId!,
                        ),
                        onKick: () =>
                            context.read<KickMemberCubit>().kickMember(
                              groupId: groupId,
                              targetUserId: moderator.userId!,
                            ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
