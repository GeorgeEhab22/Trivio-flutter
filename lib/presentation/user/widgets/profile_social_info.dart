import 'package:auth/constants/colors.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'stat_item.dart';

class ScrollToPostsNotification extends Notification {}

class ProfileSocialInfo extends StatelessWidget {
  final int numberOfFollowers;
  final int numberOfFollowing;
  final int numberOfPosts;
  final String? userId;

  const ProfileSocialInfo({
    super.key,
    this.numberOfFollowers = 0,
    this.numberOfFollowing = 0,
    this.numberOfPosts = 0,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String queryParam = userId != null ? '&userId=$userId' : '';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color:  Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatItem(
            label: l10n.posts,
            count: numberOfPosts,
            onTap: () {
              // final state = GoRouterState.of(context);
              // if (state.uri.path == AppRoutes.profile) {
                ScrollToPostsNotification().dispatch(context);
              // } else {
              //   context.go('${AppRoutes.profile}?scrollTo=posts');
              // }
            },
          ),

          Container(
            height: 30,
            width: 1,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),

          StatItem(
            label: l10n.followers,
            count: numberOfFollowers,
            onTap: () => context.push('${AppRoutes.followerInfo}?tab=0$queryParam'),
          ),

          Container(
            height: 30,
            width: 1,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),

          StatItem(
            label: l10n.following,
            count: numberOfFollowing,
            onTap: () => context.push('${AppRoutes.followerInfo}?tab=1$queryParam'),
          ),
        ],
      ),
    );
  }
}
