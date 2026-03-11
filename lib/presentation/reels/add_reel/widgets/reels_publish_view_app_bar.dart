import 'package:auth/constants/colors.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReelsPublishViewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ReelsPublishViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () {
          context.pop();
        },
      ),

      title: const Text(
        "New Reel",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),

      actions: [
        TextButton(
          onPressed: () {
          },
          child: Text(
            l10n.shareAction,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
