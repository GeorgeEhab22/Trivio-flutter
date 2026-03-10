import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/manage_group/widgets/member_rule_row.dart';
import 'package:auth/presentation/groups/widgets/common_group_buttom_sheet.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MemberRow extends StatelessWidget {
  final String? name;
  final String? image;
  final String? role;
  final String? targetUserId;
  final String? myRole;
  final bool? bannedList;
  final Function(String newRole)? onRoleChanged;
  final VoidCallback? onBan;
  final VoidCallback? onKick;

  const MemberRow({
    super.key,
    this.name,
    this.image,
    this.role,
    this.targetUserId,
    this.myRole,
    this.bannedList = false,
    this.onRoleChanged,
    this.onBan,
    this.onKick,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final profileState = context.read<ProfileCubit>().state;
    String myUserId = '';

    if (profileState is ProfileLoaded) {
      myUserId = profileState.user.id;
    }
    bool isMe = myUserId == targetUserId;
    bool canBan =
        !isMe &&
        (myRole == 'creator' ||
            (myRole == 'admin' && role != 'admin' && role != 'creator'));

    bool canKick =
        !isMe &&
        (myRole == 'creator' ||
            (myRole == 'admin' && (role == 'moderator' || role == 'member')) ||
            (myRole == 'moderator' && role == 'member'));

    bool canChangeRole =
        !isMe &&
        (myRole == 'creator' ||
            (myRole == 'admin' && (role == 'moderator' || role == 'member')));

    bool showMoreOptions = canKick || canBan;

    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: NetworkImage(image ?? 'https://picsum.photos/500'),
      ),
      title: Padding(
        // Use directional padding for RTL support
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Text(name ?? l10n.username, style: Styles.textStyle16),
      ),
      trailing: showMoreOptions
          ? IconButton(
              onPressed: () {
                showCommonGroupBottomSheet(
                  context: context,
                  title: l10n.manageMember,
                  actions: [
                    if (canKick)
                      CustomListTile(
                        icon: Icons.logout_rounded,
                        text: l10n.kick,
                        onTap: () {
                          showCustomDialog(
                            context: context,
                            title: l10n.kickUserTitle(name ?? l10n.username),
                            content: l10n.kickUserContent(
                              name ?? l10n.username,
                            ),
                            confirmText: l10n.kick,
                            confirmTextColor: Colors.red,
                            onConfirm: () {
                              onKick?.call();
                              context.pop();
                            },
                          );
                        },
                      ),
                    if (canBan)
                      CustomListTile(
                        icon: Icons.person_off_outlined,
                        text: l10n.ban,
                        onTap: () {
                          showCustomDialog(
                            context: context,
                            title: l10n.banUserTitle(name ?? l10n.username),
                            content: l10n.banUserContent(name ?? l10n.username),
                            confirmText: l10n.ban,
                            confirmTextColor: Colors.red,
                            onConfirm: () {
                              onBan?.call();
                              context.pop();
                            },
                          );
                        },
                      ),
                  ],
                );
              },
              icon: Icon(
                Icons.more_horiz,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          : null,
      subtitle: MemberRuleRow(role: role ?? "member"),
      onTap: canChangeRole
          ? () {
              showCommonGroupBottomSheet(
                context: context,
                title: l10n.changeRole,
                actions: [
                  buildRoleOption(context, "member", Icons.person, l10n.member),
                  buildRoleOption(
                    context,
                    "moderator",
                    Icons.admin_panel_settings_outlined,
                    l10n.moderator,
                  ),
                  if (myRole == 'creator')
                    buildRoleOption(
                      context,
                      "admin",
                      Icons.admin_panel_settings_rounded,
                      l10n.admin,
                    ),
                ],
              );
            }
          : null,
    );
  }

  CustomListTile buildRoleOption(
    BuildContext context,
    String roleValue,
    IconData icon,
    String localizedLabel,
  ) {
    return CustomListTile(
      icon: icon,
      text: localizedLabel,
      onTap: () {
        onRoleChanged?.call(roleValue);
        context.pop();
      },
    );
  }
}
