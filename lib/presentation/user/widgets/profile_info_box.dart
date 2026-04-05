import 'dart:io';
import 'package:auth/common/functions/custom_square_button.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/user/widgets/follow_toggle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class ProfileInfoBox extends StatelessWidget {
  final UserProfile user;

  const ProfileInfoBox({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    bool isCurrentUser = false;
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileLoaded) {
      isCurrentUser = state.user.id == user.id;
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.lightGrey,
                backgroundImage: user.avatar.startsWith('http')
                    ? NetworkImage(user.avatar)
                    : (user.avatar.isNotEmpty)
                    ? FileImage(File(user.avatar)) as ImageProvider
                    : null,
                child: user.avatar.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              if (!isCurrentUser)
                Positioned(
                  top: 0,
                  right: 0,
                  child: FollowToggleButton(targetUserId: user.id),
                ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            user.name,
            style: Styles.textStyle23.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          if (user.bio?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                user.bio!,
                textAlign: TextAlign.center,
                style: Styles.textStyle16.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCurrentUser)
                SizedBox(
                  width: 180,
                  child: CustomSquareButton(
                    label: l10n.editProfile,
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                    borderRadius: 10,
                    height: 10,
                    row: true,
                    leadingIcon: Icons.edit,
                    iconColor: Colors.white,
                    onTap: () {
                      GoRouter.of(context).push(AppRoutes.editProfile);
                    },
                  ),
                ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {
                    final String profileUrl =
                        "https://trivio.app/profile/${user.name}";
                    SharePlus.instance.share(
                      ShareParams(
                        text: 'Check out this profile on Trivio!\n$profileUrl',
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.share,
                    color: Theme.of(context).iconTheme.color,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ProfileSocialInfo(
            numberOfFollowers: user.followersCount,
            numberOfFollowing: user.followingCount,
            numberOfPosts: user.postsCount,
          ),
        ],
      ),
    );
  }
}
