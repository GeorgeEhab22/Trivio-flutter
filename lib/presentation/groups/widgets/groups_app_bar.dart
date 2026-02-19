import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/widgets/groups_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GroupsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return AppBar(
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
      title: Text(l10n.groups, style: Styles.textStyle20),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add_box_outlined,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          onPressed: () => context.push(AppRoutes.createGroup),
        ),
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          onPressed: () { /* TODO */ },
        ),
      ],
      bottom: const GroupsTabBar(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}