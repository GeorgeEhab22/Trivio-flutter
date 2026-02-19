import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyGroupAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyGroupAppBar({super.key});

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
      actions: [
        IconButton(
          onPressed: () => context.go(AppRoutes.home),
          icon: Icon(
            Icons.home_outlined,
            color: Theme.of(context).iconTheme.color,
            size: 28,
          ),
          tooltip: l10n.home, // Localized tooltip
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}