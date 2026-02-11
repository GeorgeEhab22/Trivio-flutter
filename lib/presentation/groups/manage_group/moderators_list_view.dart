import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:auth/presentation/manager/group_cubit/get_admins/get_admins_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_members/get_members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_moderators/get_moderators_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_moderators/get_moderators_state.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModeratorsListView extends StatelessWidget {
  final String groupId;

  const ModeratorsListView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChangeMemberRoleCubit, ChangeMemberRoleState>(
          listener: (context, state) {
            if (state is ChangeMemberRoleSuccess) {
              showCustomSnackBar(context, state.message, true);
              context.read<GetModeratorsCubit>().getModerators(
                groupId: groupId,
              );
              context.read<GetMembersCubit>().getMembers(groupId: groupId);
              context.read<GetAdminsCubit>().getAdmins(groupId: groupId);
            }
            if (state is ChangeMemberRoleFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<GetModeratorsCubit, GetModeratorsState>(
          builder: (context, state) {
            if (state is GetModeratorsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetModeratorsSuccess) {
              return ListView.builder(
                itemCount: state.moderators.length,
                itemBuilder: (context, index) {
                  final moderator = state.moderators[index];
                  return MemberRow(
                    name: moderator.userName,
                    image: moderator.profileImageUrl,
                    role: moderator.role ?? "Moderator",
                    onRoleChanged: (newRole) {
                      context.read<ChangeMemberRoleCubit>().changeMemberRole(
                        groupId: groupId,
                        userId: moderator.userId!,
                        newRole: newRole,
                      );
                    },
                  );
                },
              );
            } else if (state is GetModeratorsFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
