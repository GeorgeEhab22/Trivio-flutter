import 'package:auth/constants/paths.dart';
import 'package:auth/core/app_routes.dart';
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
            Flexible(
              child: Row(
                children: [
                  const Text(
                    'Trivio',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 25,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 110, 
                      minWidth: 80,
                      maxHeight: 36,
                    ),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, color: AppColors.iconsColor, size: 20),
                          const SizedBox(width: 6),
                          // allow text to ellipsize
                          const Flexible(
                            child: Text(
                              'Search',
                              style: TextStyle(color: Color(0xFF565d6d), fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
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
