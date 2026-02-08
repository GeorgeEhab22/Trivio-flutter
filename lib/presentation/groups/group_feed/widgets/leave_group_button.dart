import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LeaveGroupButton extends StatelessWidget {
  final String groupId;
  const LeaveGroupButton({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LeaveGroupCubit>().state;
    final isLoading = state is LeaveGroupLoading;
    return CustomListTile(
      icon: Icons.logout_rounded,
      text: isLoading is LeaveGroupLoading ? "Loading..." : "Leave group",
      onTap: () {
        final leaveCubit = context.read<LeaveGroupCubit>();
        context.pop();
        showCustomDialog(
          context: context,
          title: "Leave group?",
          confirmText: "Leave",
          confirmTextColor: Colors.red,
          onConfirm: () {
            leaveCubit.leaveGroup(groupId: groupId);
          },
          content: "Are you sure you want to leave this group?",
        );
      },
    );
  }
}
