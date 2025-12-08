import 'package:auth/presentation/user/widgets/custom_column_for_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.customGrey, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CustomColumnForProfileInfo(
                number: numberOfFollowers.toString(),
                thing: "followers",
              ),
              CustomColumnForProfileInfo(
                number: numberOfFollowing.toString(),
                thing: "following",
              ),
              CustomColumnForProfileInfo(
                number: numberOfPosts.toString(),
                thing: "posts",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
