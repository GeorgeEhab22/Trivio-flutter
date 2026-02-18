import 'package:auth/core/app_routes.dart';
import 'package:auth/core/home_appbar_logo_and_searchbox.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:go_router/go_router.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});

  final ValueNotifier<bool> followNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const HomeAppBarLogoAndSearchBox(),
            const Spacer(),
            IconButton(
              onPressed: () {
                // TODO: Implement share profile logic
              },
              icon: const Icon(Icons.share),
              tooltip: l10n.shareProfile, // Localized tooltip
            ),
            IconButton(
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.profileSettings);
              },
              icon: const Icon(Icons.menu),
              tooltip: l10n.profileSettings, // Localized tooltip
            ),
          ],
        ),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: ListView(
        children: [
          // This box handles its own internal localization for stats
          ProfileInfoBox(
            isFollowing: followNotifier,
            username: "User Name", // Placeholder for actual user data
            userAbout: "Football Fan", // Placeholder for actual bio data
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.posts, // Localized "Posts" title
                  style: Styles.textStyle30,
                ),
                const Divider(),
                // TODO: Integrate the GridView or ListView for user posts
              ],
            ),
          ),
        ],
      ),
    );
  }
}