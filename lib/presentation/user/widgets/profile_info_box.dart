import 'dart:io';

import 'package:auth/constants/colors.dart';
import 'package:auth/domain/entities/user_profile.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/user/widgets/follow_toggle_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class ProfileInfoBox extends StatelessWidget {
  final UserProfile user;

  const ProfileInfoBox({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool _isCurrentUser(BuildContext context) {
      final state = context.read<ProfileCubit>().state;
      if (state is ProfileLoaded) {
        // Compare the ID of the profile being displayed (widget.user.id)
        // with the ID of the logged-in user (state.user.id)
        return state.user.id == user.id;
      }
      return false;
    }

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
                        ? NetworkImage(user.avatar)
                        : (user.avatar.isNotEmpty)
                        ? FileImage(File(user.avatar))
                        : null,
                    child: user.avatar.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  if (!_isCurrentUser(context))
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
