import 'package:auth/presentation/user/widgets/profile_social_info.dart';
import 'package:flutter/material.dart';
import 'package:auth/presentation/user/widgets/follow_toggle_button.dart';

class ProfileInfoBox extends StatelessWidget {
  final String userId = "current_profile_id"; 

  const ProfileInfoBox({super.key,});

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
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqIGCJ9InU9rQK7e09YdcGY9E1TTdGAXIQ0g&s'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FollowToggleButton(targetUserId: userId),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: ProfileSocialInfo(
                  numberOfFollowers: 120,
                  numberOfFollowing: 85,
                  numberOfPosts: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}