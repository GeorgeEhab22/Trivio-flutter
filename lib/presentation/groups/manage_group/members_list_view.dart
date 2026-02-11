import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:auth/presentation/manager/get_admins/get_admins_cubit.dart';
import 'package:auth/presentation/manager/get_members/get_members_cubit.dart';
import 'package:auth/presentation/manager/get_members/get_members_state.dart';
import 'package:auth/presentation/manager/get_moderators/get_moderators_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersListView extends StatelessWidget {
  final String groupId;
  const MembersListView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChangeMemberRoleCubit, ChangeMemberRoleState>(
          listener: (context, state) {
            if (state is ChangeMemberRoleSuccess) {
              showCustomSnackBar(context, state.message, true);
              context.read<GetMembersCubit>().getMembers(groupId: groupId);
              context.read<GetAdminsCubit>().getAdmins(groupId: groupId);
              context.read<GetModeratorsCubit>().getModerators(
                groupId: groupId,
              );
            }
            if (state is ChangeMemberRoleFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<GetMembersCubit, GetMembersState>(
          builder: (context, state) {
            if (state is GetMembersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetMembersSuccess) {
              return ListView.builder(
                itemCount: state.members.length,
                itemBuilder: (context, index) {
                  final member = state.members[index];
                  return MemberRow(
                    name: member.userName,
                    image: member.profileImageUrl,
                    role: member.role ?? "Member",
                    onRoleChanged: (newRole) {
                      context.read<ChangeMemberRoleCubit>().changeMemberRole(
                        groupId: groupId,
                        userId: member.userId!,
                        newRole: newRole,
                      );
                    },
                  );
                },
              );
            } else if (state is GetMembersFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
