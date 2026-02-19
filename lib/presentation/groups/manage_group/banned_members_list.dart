import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/get_banned_members/get_banned_members_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/get_banned_members/get_banned_members_state.dart';
import 'package:auth/presentation/manager/group_cubit/unban_member/unban_member_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/unban_member/unban_member_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannedMembersList extends StatelessWidget {
  final String groupId;
  const BannedMembersList({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<UnbanMemberCubit, UnbanMemberState>(
          listener: (context, state) {
            if (state is UnbanMemberSuccess) {
              showCustomSnackBar(context, state.message, true);
              context.read<GetBannedMembersCubit>().getBannedMembers(
                    groupId: groupId,
                  );
            }
            if (state is UnbanMemberFailure) {
              showCustomSnackBar(context, state.message, false);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.bannedMembers)),
        body: BlocBuilder<GetBannedMembersCubit, GetBannedMembersState>(
          builder: (context, state) {
            if (state is GetBannedMembersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetBannedMembersSuccess) {
              if (state.bannedMembers.isEmpty) {
                return Center(child: Text(l10n.noBannedMembersFound));
              }
              return ListView.builder(
                itemCount: state.bannedMembers.length,
                itemBuilder: (context, index) {
                  final bannedMember = state.bannedMembers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                        bannedMember.profileImageUrl ??
                            'https://picsum.photos/500',
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        bannedMember.userName ?? l10n.username,
                        style: Styles.textStyle16,
                      ),
                    ),
                    trailing: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onTap: () {
                      showCustomDialog(
                        context: context,
                        confirmText: l10n.unban,
                        confirmTextColor: Colors.red,
                        onConfirm: () {
                          context.read<UnbanMemberCubit>().unbanMember(
                                groupId: groupId,
                                targetUserId: bannedMember.userId!,
                              );
                        },
                        title: l10n.unbanUserTitle,
                        content: l10n.unbanUserContent,
                      );
                    },
                  );
                },
              );
            }
            if (state is GetBannedMembersFailure) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}