import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/group_feed/widgets/leave_group_button.dart';
import 'package:auth/presentation/groups/widgets/common_group_buttom_sheet.dart';
import 'package:auth/presentation/manager/group_cubit/leave_group/leave_group_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GroupFeedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GroupFeedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          isArabic ? Icons.arrow_back_ios_rounded : Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 25,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          onPressed: () {
            context.push(AppRoutes.search);
          },
        ),
        IconButton(
          onPressed: () {
            final leaveGroupCubit = context.read<LeaveGroupCubit>();
            showCommonGroupBottomSheet(
              context: context,
              actions: [
                CustomListTile(
                  icon: Icons.link,
                  text: l10n.copyLink,
                  onTap: () {
                    context.pop();
                    //TODO: copy link
                  },
                ),
                BlocProvider.value(
                  value: leaveGroupCubit,
                  child: const LeaveGroupButton(groupId: "69888500a488d0dae5e0accc"),
                ),
                CustomListTile(
                  icon: Icons.report_gmailerrorred,
                  text: l10n.reportGroup,
                  onTap: () {
                    context.pop();
                    //TODO: show report group button sheet
                  },
                ),
              ],
            );
          },
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}