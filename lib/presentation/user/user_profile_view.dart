import 'package:auth/core/app_routes.dart';
import 'package:auth/core/home_appbar_logo_and_searchbox.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/user/widgets/profile_info_box.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              tooltip: l10n.shareProfile,
            ),
            IconButton(
              onPressed: () {
                GoRouter.of(context).push(AppRoutes.profileSettings);
              },
              icon: const Icon(Icons.menu),
              tooltip: l10n.profileSettings, 
            ),
          ],
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 2),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          // 🛡️ Handles the "Initial" state (the white screen fix) and Loading
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } 
          
          else if (state is ProfileLoaded) {
            final user = state.user;
            return ListView(
              children: [
                // 🔹 Pass the dynamic user from the Cubit to the widget
                ProfileInfoBox(user: user),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dynamic Name
                      Text(
                        user.name, 
                        style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(height: 4),
                      // Dynamic Bio with Null Safety
                      if (user.bio != null && user.bio!.isNotEmpty)
                        Text(
                          user.bio!, 
                          style: Styles.textStyle16.copyWith(color: Colors.grey[800])
                        ),
                      const SizedBox(height: 10),
                      const Divider(color: AppColors.lightGrey),
                      Text(l10n.posts, style: Styles.textStyle30),
                    ],
                  ),
                ),
                // Your posts grid logic will follow here
              ],
            );
          } 
          
          else if (state is ProfileError) {

          }
          
          return const SizedBox();
        },
      ),
    );
  }
}