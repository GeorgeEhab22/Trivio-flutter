import 'package:auth/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyGroupAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyGroupAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
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
            context.push(AppRoutes.manageGroup);
          },
          icon: Icon(
            Icons.security_outlined,
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
