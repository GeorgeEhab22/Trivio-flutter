import 'package:auth/constants/paths.dart';
import 'package:auth/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int notificationCount; // ← just a plain int, no cubit needed here

  const HomeAppBar({super.key, this.notificationCount = 0});

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
                      if (notificationCount > 0)
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              notificationCount > 99
                                  ? '99+'
                                  : '$notificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // ───────────────────────────────────────────────────────────

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