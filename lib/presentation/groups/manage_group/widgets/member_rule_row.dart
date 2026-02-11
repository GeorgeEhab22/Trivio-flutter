import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';

class MemberRuleRow extends StatelessWidget {
  final String? role;
  const MemberRuleRow({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    final String currentRole = role?.toLowerCase() ?? "member";

    IconData roleIcon;
    Color roleColor;

    if (currentRole == 'admin') {
      roleIcon = Icons.admin_panel_settings_rounded;
      roleColor = Colors.amber; 
    } else if (currentRole == 'moderator') {
      roleIcon = Icons.verified_user_rounded;
      roleColor = Colors.blue; 
    } else {
      roleIcon = Icons.person_rounded;
      roleColor = Colors.grey;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                roleIcon,
                size: 14,
                color: roleColor,
              ),
              const SizedBox(width: 4),
              Text(
                currentRole[0].toUpperCase() + currentRole.substring(1),
                style: Styles.textStyle14.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
