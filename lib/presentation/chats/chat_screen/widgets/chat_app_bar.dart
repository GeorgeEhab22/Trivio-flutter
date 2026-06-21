import 'package:auth/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: iconColor, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        "Alex Johnson",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline, color: iconColor),
          onPressed: () {
            context.push(AppRoutes.chatInfo);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
