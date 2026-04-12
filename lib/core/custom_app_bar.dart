import 'package:auth/constants/paths.dart';
import 'package:auth/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasNotifications; // ← just a plain int, no cubit needed here

  const HomeAppBar({super.key, this.hasNotifications = false});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              isDarkMode ? Paths.trivioDarkLogo : Paths.trivioLogo,
              width: isDarkMode ? 55 : 70,
              height: isDarkMode ? 55 : 70,
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => context.push(AppRoutes.messages),
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: SvgPicture.asset(
                      Paths.chatsIcon,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  ),
                ),

                // ── Notification icon ──────────────────────────────────────
                IconButton(
                  onPressed: () => context.push(AppRoutes.notifications),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        Paths.notificationIcon,
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        colorFilter:
                            ColorFilter.mode(iconColor, BlendMode.srcIn),
                      ),
                      if (hasNotifications)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => context.push(AppRoutes.settings),
                  icon: SvgPicture.asset(
                    Paths.listIcon,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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