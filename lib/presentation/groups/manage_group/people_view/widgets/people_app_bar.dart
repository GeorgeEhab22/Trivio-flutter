import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/groups/manage_group/people_view/widgets/people_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PeopleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PeopleAppBar({super.key});

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
          // Switches icon direction based on locale
          isArabic ? Icons.arrow_back_ios_rounded : Icons.arrow_back_ios_new_rounded,
          color: Theme.of(context).iconTheme.color,
          size: 25,
        ),
      ),

      title: Text(l10n.people, style: Styles.textStyle20),

      bottom: const PeopleTabBar(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}