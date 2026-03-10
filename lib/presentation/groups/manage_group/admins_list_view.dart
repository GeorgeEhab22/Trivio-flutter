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

class AdminsListView extends StatelessWidget {
  final String groupId;
  const AdminsListView({super.key, required this.groupId});

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
                state.isLoading && state.admins.isEmpty;
            final bool isLoadingMore = state.isLoadingMoreAdmins;

            final displayAdmins = isInitialLoading
                ? DummyData.dummyMembers
                : [...state.admins, if (isLoadingMore) DummyData.dummyMember];

            if (!isInitialLoading && state.admins.isEmpty) {
              return Center(child: Text(l10n.noAdminsFound));
            }

            return Skeletonizer(
              enabled: isInitialLoading,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo is ScrollUpdateNotification &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent * 0.8) {
                    cubit.loadMoreAdmins(groupId);
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount:
                      displayAdmins.length +
                      (state.hasReachedMaxAdmins ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == displayAdmins.length) {
                      return const SizedBox(height: 50);
                    }

                    final admin = displayAdmins[index];
                    return Skeletonizer(
                      enabled: isInitialLoading || admin.userId!.isEmpty,
                      child: MemberRow(
                        name: admin.userName,
                        image: admin.profileImageUrl,
                        role: admin.role ?? l10n.admin,
                        targetUserId: admin.userId,
                        myRole: myRoleInGroup,
                        onRoleChanged: (newRole) {
                          context
                              .read<ChangeMemberRoleCubit>()
                              .changeMemberRole(
                                groupId: groupId,
                                userId: admin.userId!,
                                newRole: newRole,
                              );
                        },
                        onBan: () => context.read<BanMemberCubit>().banMember(
                          groupId: groupId,
                          targetUserId: admin.userId!,
                        ),
                        onKick: () =>
                            context.read<KickMemberCubit>().kickMember(
                              groupId: groupId,
                              targetUserId: admin.userId!,
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
