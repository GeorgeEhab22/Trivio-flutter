import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/user/widgets/custom_profile_filled_button.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:auth/presentation/user/widgets/settings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class UserProfileSettings extends StatelessWidget {
  const UserProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileSettings, style: Styles.textStyle30),
        shape: const Border(bottom: BorderSide(color: AppColors.lightGrey, width: 2)),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // 1. Handle Loading/Error states for the settings page
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is ProfileLoaded) {
            final user = state.user;

            return Padding(
              padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.005),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 2. Pass the dynamic user to the info box
                    ProfileInfoBox(user: user),
                    
                    CustomProfileFilledButton(
                      onpressed: () {
                        GoRouter.of(context).push(AppRoutes.editProfile);
                      },
                      displayText: "Edit Profile",
                      icon: FontAwesomeIcons.userPen,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 10),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          SettingsRow(
                            title: "Account Settings",
                            subtitle: "Manage your account details and preferences.",
                            onpressed: () {},
                          ),
                          const Divider(color: AppColors.lightGrey),
                          SettingsRow(
                            title: "Liked Posts",
                            subtitle: "View and manage the posts you've liked.",
                            onpressed: () => context.push(AppRoutes.likedPosts),
                          ),
                          const Divider(color: AppColors.lightGrey),
                          SettingsRow(
                            title: "Privacy Settings",
                            subtitle: "Control who sees your posts and activity.",
                            onpressed: () {},
                          ),
                          const Divider(color: AppColors.lightGrey),
                          SettingsRow(
                            title: "Change Password",
                            subtitle: "Update your security credentials.",
                            onpressed: () => context.push(AppRoutes.changePassword),
                          ),
                          const Divider(color: AppColors.lightGrey),
                          SettingsRow(
                            title: "Notification Preferences",
                            subtitle: "Customize your notification alerts.",
                            onpressed: () {},
                          ),
                          const Divider(color: AppColors.lightGrey),
                          SettingsRow(
                            title: "App Preferences",
                            subtitle: "Adjust language, theme, and data usage",
                            onpressed: () {},
                          ),
                          const Divider(color: AppColors.lightGrey),
                          const SettingsRow(
                            title: "Require Follow Requests",
                            subtitle: "Manually approve followers",
                            onpressed: null,
                            isToggle: true,
                          ),
                          const Divider(color: AppColors.lightGrey),
                          const SettingsRow(
                            title: "Searchable Profile",
                            subtitle: "Allow your profile to appear in search results",
                            onpressed: null,
                            isToggle: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}