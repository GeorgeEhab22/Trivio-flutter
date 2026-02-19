import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MemberRuleRow extends StatelessWidget {
  final String? role;
  const MemberRuleRow({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String roleKey = role?.toLowerCase() ?? "member";

    IconData roleIcon;
    Color roleColor;
    String localizedRole;

    if (roleKey == 'admin') {
      roleIcon = Icons.admin_panel_settings_rounded;
      roleColor = Colors.amber;
      localizedRole = l10n.admin;
    } else if (roleKey == 'moderator') {
      roleIcon = Icons.verified_user_rounded;
      roleColor = Colors.blue;
      localizedRole = l10n.moderator;
    } else {
      roleIcon = Icons.person_rounded;
      roleColor = Colors.grey;
      localizedRole = l10n.member;
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
                localizedRole,
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