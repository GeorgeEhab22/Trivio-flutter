import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:auth/presentation/manager/group_cubit/delete_group/delete_group_cubit.dart';
import 'package:auth/presentation/manager/group_cubit/delete_group/delete_group_state.dart';
import 'package:auth/presentation/manager/group_cubit/get_my_groups/get_my_groups_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ManageGroupView extends StatelessWidget {
  final String groupId;
  const ManageGroupView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocListener<DeleteGroupCubit, DeleteGroupState>(
      listener: (context, state) {
        if (state is DeleteGroupSuccess) {
          context.read<GetMyGroupsCubit>().removeGroupLocally(groupId);
          showCustomSnackBar(context, l10n.groupDeletedSuccess, true);
          context.go(AppRoutes.groups);
        }
        if (state is DeleteGroupFailure) {
          showCustomSnackBar(context, state.message, false);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(isArabic ? Icons.arrow_back_ios_rounded : Icons.arrow_back),
          ),
          title: Text(l10n.manageGroup, style: Styles.textStyleBold18),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 8),
            _buildSectionHeader(l10n.review),
            _buildSettingsContainer(
              context,
              [
                CustomListTile(
                  icon: Icons.person_add_outlined,
                  text: l10n.membersRequests,
                  onTap: () => context.push(AppRoutes.groupMembersRequests),
                ),
                CustomListTile(
                  icon: Icons.post_add_outlined,
                  text: l10n.pendingPosts,
                  onTap: () => context.push(AppRoutes.groupPendingPosts),
                ),
                CustomListTile(
                  icon: Icons.report_gmailerrorred_outlined,
                  text: l10n.reportedPosts,
                  onTap: () => context.push(AppRoutes.groupReportedPosts),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(l10n.communityAndPeople),
            _buildSettingsContainer(
              context,
              [
                CustomListTile(
                  icon: Icons.group_outlined,
                  text: l10n.people,
                  onTap: () => context.push(AppRoutes.groupMembers),
                ),
                CustomListTile(
                  icon: Icons.person_off_outlined,
                  text: l10n.bannedMembers,
                  onTap: () => context.push(AppRoutes.bannedMembers),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(l10n.manage),
            _buildSettingsContainer(
              context,
              [
                CustomListTile(
                  icon: Icons.share,
                  text: l10n.shareGroup,
                  onTap: () {
                    //TODO : copy actual Link
                    showCustomSnackBar(context, l10n.linkCopied, true);
                  },
                ),
                CustomListTile(
                  icon: Icons.logout_rounded,
                  text: l10n.leaveGroup,
                  onTap: () {
                    showCustomDialog(
                      context: context,
                      title: l10n.leaveGroupTitle,
                      confirmText: l10n.leave,
                      confirmTextColor: Colors.red,
                      onConfirm: () {
                        //TODO: add leave group logic
                      },
                      content: l10n.leaveGroupContent,
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.delete_outlined,
                  text: l10n.deleteGroup,
                  onTap: () {
                    showCustomDialog(
                      context: context,
                      title: l10n.deleteGroupTitle,
                      confirmText: l10n.delete,
                      confirmTextColor: Colors.red,
                      onConfirm: () {
                        context.read<DeleteGroupCubit>().deleteGroup(groupId);
                      },
                      content: l10n.deleteGroupContent,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [Text(title)]),
    );
  }

  Widget _buildSettingsContainer(BuildContext context, List<Widget> children) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}