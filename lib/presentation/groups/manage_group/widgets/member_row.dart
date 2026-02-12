import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_rule_row.dart';
import 'package:auth/presentation/groups/widgets/common_group_buttom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberRow extends StatelessWidget {
  final String? name;
  final String? image;
  final String? role;
  final bool? bannedList;
  final Function(String newRole)? onRoleChanged;
  final VoidCallback? onBan;
  final VoidCallback? onKick;

  const MemberRow({
    super.key,
    this.name,
    this.image,
    this.role,
    this.bannedList = false,
    this.onRoleChanged,
    this.onBan,
    this.onKick,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage(image ?? 'https://picsum.photos/500'),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Text(name ?? "name", style: Styles.textStyle16),
      ),
      trailing: IconButton(
        onPressed: () {
          showCommonGroupBottomSheet(
            context: context,
            title: "Ban user",
            actions: [
              CustomListTile(
                icon: Icons.logout_rounded,
                text: "Kick",
                onTap: () {
                  showCustomDialog(
                    context: context,
                    title: "Kick $name",
                    content: "Are you sure you want to kick $name?",
                    confirmText: "Kick",
                    confirmTextColor: Colors.red,
                    onConfirm: () {
                      onKick!();
                      context.pop();
                    },
                  );
                },
              ),
              CustomListTile(
                icon: Icons.person_off_outlined,
                text: "Ban",
                onTap: () {
                  showCustomDialog(
                    context: context,
                    title: "Ban $name",
                    content: "Are you sure you want to ban $name?",
                    confirmText: "Ban",
                    confirmTextColor: Colors.red,
                    onConfirm: () {
                      onBan!();
                      context.pop();
                    },
                  );
                },
              ),
            ],
          );
        },
        icon: Icon(Icons.more_horiz, color: Theme.of(context).iconTheme.color),
      ),
      subtitle: MemberRuleRow(role: role ?? "Member"),
      onTap: () {
        showCommonGroupBottomSheet(
          context: context,
          title: "Change role",
          actions: [
            buildRoleOption(context, "member", Icons.person),
            buildRoleOption(
              context,
              "moderator",
              Icons.admin_panel_settings_outlined,
            ),
            buildRoleOption(
              context,
              "admin",
              Icons.admin_panel_settings_rounded,
            ),
          ],
        );
      },
    );
  }

  CustomListTile buildRoleOption(
    BuildContext context,
    String roleValue,
    IconData icon,
  ) {
    return CustomListTile(
      icon: icon,
      text: roleValue[0].toUpperCase() + roleValue.substring(1),
      onTap: () {
        onRoleChanged?.call(roleValue);
        context.pop();
      },
    );
  }
}
