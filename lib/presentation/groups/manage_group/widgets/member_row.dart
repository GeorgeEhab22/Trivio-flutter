import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_rule_row.dart';
import 'package:auth/presentation/groups/widgets/common_group_buttom_sheet.dart';
import 'package:flutter/material.dart';

class MemberRow extends StatelessWidget {
  final bool? bannedList;
  const MemberRow({super.key, this.bannedList = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage('https://picsum.photos/500'),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Text("Member name", style: Styles.textStyle16),
      ),
      trailing: Icon(
        Icons.more_horiz,
        color: Theme.of(context).iconTheme.color,
      ),
      subtitle: const MemberRuleRow(),
      onTap: () {
        if (bannedList!) {
          showCustomDialog(
            context: context,
            confirmText: "Unban",
            confirmTextColor: Colors.red,
            onConfirm: () {
              //TODO: add unban logic
            },
            title: 'Unban user',
            content: "Are you sure you want to unban this user?",
          );
        } else {
          showCommonGroupBottomSheet(
            context: context,
            title: "Change role",
            actions: [
              CustomListTile(icon: Icons.person, text: "Member", onTap: () {}),
              CustomListTile(
                icon: Icons.admin_panel_settings_outlined,
                text: "Moderator",
                onTap: () {},
              ),
              CustomListTile(
                icon: Icons.admin_panel_settings_rounded,
                text: "Admin",
                onTap: () {},
              ),
            ],
          );
        }
      },
    );
  }
}
