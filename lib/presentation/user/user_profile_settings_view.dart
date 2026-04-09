import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/manager/sigin_in_cubit/sign_in_cubit.dart';
import 'package:auth/presentation/user/widgets/confirm_window.dart';
// import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:auth/presentation/user/widgets/settings_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileSettings extends StatelessWidget {
  const UserProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.profileSettings,
          style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        scrolledUnderElevation: 0,
        iconTheme: Theme.of(context).iconTheme,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).iconTheme.color,
            size: 25,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is ProfileLoaded) {
            // final user = state.user;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ProfileInfoBox(user: user),
                    // const SizedBox(height: 25),
                    _buildSectionHeader(l10n.accountPreferences, context),
                    SettingsRow(
                      title: l10n.settingsFavTeamsTitle,
                      subtitle: l10n.settingsFavTeamsSub,
                      leadingIcon: Icons.people_alt_rounded,
                      onpressed: () {
                        context.push(AppRoutes.selectTeams, extra: true);
                      },
                    ),
                    SettingsRow(
                      title: l10n.settingsFavPlayersTitle,
                      subtitle: l10n.settingsFavPlayersSub,
                      leadingIcon: Icons.sports_soccer_rounded,
                      onpressed: () {
                        context.push(AppRoutes.selectPlayers, extra: true);
                      },
                    ),
                    SettingsRow(
                      title: l10n.likedPosts,
                      subtitle: l10n.likedPostsSub,
                      leadingIcon: Icons.favorite_rounded,
                      onpressed: () => context.push(AppRoutes.likedPosts),
                    ),

                    const SizedBox(height: 20),

                    _buildSectionHeader(l10n.securityAndAlerts, context),
                    SettingsRow(
                      title: l10n.notificationPrefs,
                      subtitle: l10n.notificationPrefsSub,
                      leadingIcon: Icons.notifications_active_rounded,
                      onpressed: () {},
                    ),
                    SettingsRow(
                      title: l10n.changePassword,
                      subtitle: l10n.changePasswordSub,
                      leadingIcon: Icons.lock_rounded,
                      onpressed: () => context.push(AppRoutes.changePassword),
                    ),

                    const SizedBox(height: 30),

                    InkWell(
                      onTap: () {
                        ConfirmWindow.show(
                          context,
                          title: l10n.logoutAccount,
                          subtitle: l10n.logoutAccountConfirm,
                          onConfirm: () async {
                            await context.read<SignInCubit>().logout();
                            context.read<ProfileCubit>().clearProfile();
                            if (context.mounted) {
                              context.go(AppRoutes.signIn);
                            }
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.red.withValues(alpha: 0.15)
                              : const Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              l10n.logoutAccount,
                              style: Styles.textStyle16.copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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

  Widget _buildSectionHeader(String title, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
      child: Text(
        title,
        style: Styles.textStyle14.copyWith(
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
