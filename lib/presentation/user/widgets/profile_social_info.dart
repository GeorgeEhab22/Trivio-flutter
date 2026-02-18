import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.customGrey, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IntrinsicHeight( 
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                onTap: () => GoRouter.of(context).push(AppRoutes.followersList),
                child: CustomColumnForProfileInfo(
                  number: numberOfFollowers.toString(),
                  thing: l10n.followers,
                ),
              ),
            ),
            
            _buildDivider(),

            /// Following
            Expanded(
              child: InkWell(
                onTap: () => GoRouter.of(context).push(AppRoutes.followingList),
                child: CustomColumnForProfileInfo(
                  number: numberOfFollowing.toString(),
                  thing: l10n.following, 
                ),
              ),
            ),

            _buildDivider(),

            /// Posts
            Expanded(
              child: CustomColumnForProfileInfo(
                number: numberOfPosts.toString(),
                thing: l10n.posts, 
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return VerticalDivider(
      color: AppColors.customGrey,
      thickness: 1.5,
      width: 0,
      indent: 10,
      endIndent: 10,
    );
  }
}