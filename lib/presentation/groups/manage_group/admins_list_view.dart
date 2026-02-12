import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/ban_member/ban_member_state.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_state.dart';
import 'package:auth/presentation/manager/group_cubit/kick_member/kick_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/kick_member/kick_member_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_members_by_roles/members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_members_by_roles/members_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminsListView extends StatelessWidget {
  final String groupId;
  const AdminsListView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
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
            if (state is ChangeMemberRoleFailure) {
              showCustomSnackBar(context, state.message, false);
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
            if (state is BanMemberFailure) {
              showCustomSnackBar(context, state.message, false);
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
            if (state is KickMemberFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<GroupMembersCubit, GroupMembersState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final admins = state.admins;

            if (admins.isEmpty) {
              return const Center(child: Text("No Admins found"));
            }

            return ListView.builder(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                final admin = admins[index];
                return MemberRow(
                  name: admin.userName,
                  image: admin.profileImageUrl,
                  role: admin.role ?? "Admin",
                  onRoleChanged: (newRole) {
                    context.read<ChangeMemberRoleCubit>().changeMemberRole(
                      groupId: groupId,
                      userId: admin.userId!,
                      newRole: newRole,
                    );
                  },
                  onBan: () => context.read<BanMemberCubit>().banMember(
                    groupId: groupId,
                    targetUserId: admin.userId!,
                  ),
                  onKick: () => context.read<KickMemberCubit>().kickMember(
                    groupId: groupId,
                    targetUserId: admin.userId!,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
