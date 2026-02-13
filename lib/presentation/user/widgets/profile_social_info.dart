import 'package:auth/core/app_routes.dart';
import 'package:auth/presentation/user/widgets/custom_column_for_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:go_router/go_router.dart';

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
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.customGrey, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () => GoRouter.of(context).push(AppRoutes.followersList),
                child: CustomColumnForProfileInfo(
                  number: numberOfFollowers.toString(),
                  thing: "followers",
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () => GoRouter.of(context).push(AppRoutes.followingList),
                child: CustomColumnForProfileInfo(
                  number: numberOfFollowing.toString(),
                  thing: "following",
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () => GoRouter.of(context).push(AppRoutes.requests),
                child: CustomColumnForProfileInfo(
                  number: numberOfPosts.toString(),
                  thing: "posts",
                ),
              ),
            ),
          ],
        ),
      );
  }
}
