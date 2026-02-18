import 'package:auth/common/functions/custom_list_tile.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/core/language_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/l10n/app_localizations.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
        title: Text(
          l10n.menu,
          style: const TextStyle(fontWeight: FontWeight.w600),
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
                              label: l10n.saved,
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
                              label: l10n.groups,
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
                              label: l10n.posts,
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
                              label: l10n.reels,
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

                CustomListTile(
                  icon: Icons.notifications_none,
                  text: l10n.notifications,
                  withArrow: true,
                  onTap: () {
                    context.push(AppRoutes.notifications);
                  },
                ),
                const Divider(),
                CustomListTile(
                  icon: Icons.mode_night_outlined,
                  text: l10n.theme,
                  withArrow: true,
                  onTap: () {
                    context.push(AppRoutes.theme);
                  },
                ),

                const Divider(),
                CustomListTile(
                  icon: Icons.block_flipped,
                  text: l10n.blocked,
                  withArrow: true,
                  redColor: true,
                  onTap: () {
                    context.push(AppRoutes.blocked);
                  },
                ),

                const Divider(),
                CustomListTile(
                  icon: Icons.toggle_on_outlined,
                  text: l10n.activeStatus,
                  withArrow: true,
                  onTap: () {
                    context.push(AppRoutes.activeStates);
                  },
                ),
                const Divider(),
                const Align(
                  alignment: AlignmentDirectional.topStart,
                  child: LanguageSwitchButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
