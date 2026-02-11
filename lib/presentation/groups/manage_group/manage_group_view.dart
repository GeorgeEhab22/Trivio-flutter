import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/authentication/widgets/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManageGroupView extends StatelessWidget {
  const ManageGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Manage group", style: Styles.textStyleBold18),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(children: [Text("Review")]),
          ),

          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                CustomListTile(
                  icon: Icons.person_add_outlined,
                  text: 'Members Requests',
                  onTap: () {
                    context.push(AppRoutes.groupMembersRequests);
                  },
                ),

                CustomListTile(
                  icon: Icons.post_add_outlined,
                  text: 'Pending posts',
                  onTap: () {
                    context.push(AppRoutes.groupPendingPosts);
                  },
                ),
                CustomListTile(
                  icon: Icons.report_gmailerrorred_outlined,
                  text: 'Reported posts',
                  onTap: () {
                    context.push(AppRoutes.groupReportedPosts);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(children: [Text("Community & People")]),
          ),

          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                CustomListTile(
                  icon: Icons.group_outlined,
                  text: 'People',
                  onTap: () {
                    context.push(AppRoutes.groupMembers);
                  },
                ),
                CustomListTile(
                  icon: Icons.person_off_outlined,
                  text: 'Banned Members',
                  onTap: () {
                    context.push(AppRoutes.bannedMembers);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(children: [Text("Manage")]),
          ),

          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                CustomListTile(
                  icon: Icons.share,
                  text: 'Share group',
                  onTap: () {
                    //TODO : copy actual Link
                    showCustomSnackBar(
                      context,
                      "Link copied to clipboard",
                      true,
                    );
                  },
                ),
                CustomListTile(
                  icon: Icons.logout_rounded,
                  text: 'Leave group',
                  onTap: () {
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
                ),
                CustomListTile(
                  icon: Icons.delete_outlined,
                  text: 'Delete group',
                  onTap: () {
                    showCustomDialog(
                      context: context,
                      title: "Delete group?",
                      confirmText: "Delete",
                      confirmTextColor: Colors.red,
                      onConfirm: () {
                        //TODO: add delete group logic
                      },
                      content: "Are you sure you want to delete this group?",
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
