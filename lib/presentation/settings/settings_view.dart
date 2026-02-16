import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/presentation/authentication/widgets/language_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomSquareButton(
                              label: 'Saved',
                              icon: Icons.bookmark_border,
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              borderColor: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              alignment: CrossAxisAlignment.start,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomSquareButton(
                              label: 'Groups',
                              icon: Icons.groups_2_outlined,
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              borderColor: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              alignment: CrossAxisAlignment.start,
                              onTap: () => context.push(AppRoutes.groups),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomSquareButton(
                              label: 'Posts',
                              icon: Icons.featured_play_list_outlined,
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              borderColor: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              alignment: CrossAxisAlignment.start,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomSquareButton(
                              label: 'Reels',
                              icon: Icons.video_library_outlined,
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              borderColor: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                              alignment: CrossAxisAlignment.start,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Spacer(),
                CustomListTile(
                  icon: Icons.notifications_none,
                  text: 'Notifications',
                  withArrow: true,
                  onTap: () {
                    context.push(AppRoutes.notifications);
                  },
                ),
                const Divider(),
                CustomListTile(
                  icon: Icons.mode_night_outlined,
                  text: 'Theme',
                  withArrow: true,
                  onTap: () {
                    context.push(AppRoutes.theme);
                  },
                ),

                const Divider(),
                CustomListTile(
                  icon: Icons.block_flipped,
                  text: 'Blocked',
                  withArrow: true,
                  redColor: true,
                  onTap: () {
                    context.push(AppRoutes.blocked);
                  },
                ),

                const Divider(),
                CustomListTile(
                  icon: Icons.toggle_on_outlined,
                  text: 'Active status',
                  withArrow: true,
                  onTap: () {
                    context.push(AppRoutes.activeStates);
                  },
                ),
                const Divider(),
                LanguageSwitchButton(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
