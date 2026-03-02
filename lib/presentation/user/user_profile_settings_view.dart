import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/user/widgets/custom_profile_filled_button.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:auth/presentation/user/widgets/settings_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class UserProfileSettings extends StatelessWidget {
  const UserProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileSettings, style: Styles.textStyle20),
        shape: Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).push(AppRoutes.requests),
            icon: const Icon(Icons.person_add_alt),
            tooltip: l10n.followRequests,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username and About handled by ProfileInfoBox internally
               ProfileInfoBox(
                username: "Username", 
                userAbout: "Football Enthusiast", 
                isFollowing: ValueNotifier(false)
              ),
              
              CustomProfileFilledButton(
                onpressed: () {},
                displayText: l10n.editProfile,
                icon: FontAwesomeIcons.userPen,
                color: AppColors.primary,
              ),
              
              const SizedBox(height: 10),
              
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGrey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SettingsRow(
                      title: l10n.accountSettings,
                      subtitle: l10n.accountSettingsSub,
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey, height: 1),
                    SettingsRow(
                      title: l10n.privacySettings,
                      subtitle: l10n.privacySettingsSub,
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey, height: 1),
                    SettingsRow(
                      title: l10n.notificationPrefs,
                      subtitle: l10n.notificationPrefsSub,
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey, height: 1),
                    SettingsRow(
                      title: l10n.appPrefs,
                      subtitle: l10n.appPrefsSub,
                      onpressed: () {},
                    ),
                    Divider(color: AppColors.lightGrey, height: 1),
                    SettingsRow(
                      title: l10n.settingsFavTeamsTitle,
                      subtitle: l10n.settingsFavTeamsSub,
                      onpressed: () {
                        context.push(AppRoutes.selectTeams, extra: true);
                      },
                    ),
                    Divider(color: AppColors.lightGrey, height: 1),
                    SettingsRow(
                      title: l10n.settingsFavPlayersTitle,
                      subtitle: l10n.settingsFavPlayersSub,
                      onpressed: () {
                        context.push(AppRoutes.selectPlayers, extra: true);
                      },
                    ),
                    Divider(color: AppColors.lightGrey, height: 1),
                    SettingsRow(
                      title: l10n.requireFollow,
                      subtitle: l10n.requireFollowSub,
                      onpressed: () {},
                      isToggle: true,
                    ),
                    Divider(color: AppColors.lightGrey, height: 1),
                    SettingsRow(
                      title: l10n.searchableProfile,
                      subtitle: l10n.searchableProfileSub,
                      onpressed: () {},
                      isToggle: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}