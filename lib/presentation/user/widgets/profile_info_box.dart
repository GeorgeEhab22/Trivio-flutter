import 'dart:io';

import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/user/widgets/follow_toggle_button.dart';

class ProfileInfoBox extends StatelessWidget {
  final UserProfile user;

  const ProfileInfoBox({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.lightGrey,
                    backgroundImage: user.avatar.startsWith('http')
                        ? NetworkImage(user.avatar) as ImageProvider
                        : FileImage(File(user.avatar)),
                    child: user.avatar.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FollowToggleButton(targetUserId: user.id),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ProfileSocialInfo(
                  numberOfFollowers: user.followersCount,
                  numberOfFollowing: user.followingCount,
                  numberOfPosts: user.postsCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
