import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeaveGroupButton extends StatelessWidget {
  const LeaveGroupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      icon: Icons.logout_rounded,
      text: "Leave group",
      onTap: () {
        context.pop();
        showCustomDialog(
          context: context,
          title: "Leave group?",
          confirmText: "Leave",
          confirmTextColor: Colors.red,
          onConfirm: () {
            //TODO: add leave group logic
          },
          content: "Are you sure you want to leave this group?",
        );
      },
    );
  }
}
