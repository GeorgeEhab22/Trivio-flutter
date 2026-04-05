import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final iconColor = Theme.of(context).iconTheme.color;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: iconColor,
      ),
      title: Text(
        l10n.notifications,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
