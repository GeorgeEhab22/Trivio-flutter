import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_row.dart';
import 'package:auth/presentation/manager/group_cubit/get_admins/get_admins_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_admins/get_admins_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_members/get_members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_moderators/get_moderators_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/change_member_role/change_member_role_state.dart';
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
              context.read<GetAdminsCubit>().getAdmins(groupId: groupId);
              context.read<GetModeratorsCubit>().getModerators(
                groupId: groupId,
              );
              context.read<GetMembersCubit>().getMembers(groupId: groupId);
            }
            if (state is ChangeMemberRoleFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<GetAdminsCubit, GetAdminsState>(
          builder: (context, state) {
            if (state is GetAdminsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is GetAdminsSuccess) {
              return ListView.builder(
                itemCount: state.admins.length,
                itemBuilder: (context, index) {
                  final admin = state.admins[index];
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
                  );
                },
              );
            } else if (state is GetAdminsFailure) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
