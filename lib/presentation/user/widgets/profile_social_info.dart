import 'package:auth/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:go_router/go_router.dart';
import 'stat_item.dart';

class ProfileSocialInfo extends StatelessWidget {
  final int numberOfFollowers;
  final int numberOfFollowing;
  final int numberOfPosts;

  const ProfileSocialInfo({
    super.key,
    this.numberOfFollowers = 0,
    this.numberOfFollowing = 0,
    this.numberOfPosts = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.customGrey, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatItem(
            label: "followers",
            count: numberOfFollowers,
            onTap: () => context.go('${AppRoutes.followerInfo}?tab=0'),
          ),
          StatItem(
            label: "following",
            count: numberOfFollowing,
            onTap: () => context.go('${AppRoutes.followerInfo}?tab=1'),
          ),
          StatItem(
            label: "posts",
            count: numberOfPosts,
            onTap: () {
              // Scroll to posts or show post info
            },
          ),
        ],
      ),
    );
  }
}