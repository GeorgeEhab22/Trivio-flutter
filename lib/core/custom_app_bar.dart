import 'package:auth/constants/paths.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/home_appbar_logo_and_searchbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auth/constants/colors.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            HomeAppBarLogoAndSearchBox(),
            // const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      Paths.kSendButton,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.bell,
                    color: AppColors.iconsColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    GoRouter.of(context).push(AppRoutes.userProfile);
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.iconsColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
