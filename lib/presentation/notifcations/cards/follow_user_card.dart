import 'package:auth/injection_container.dart' as di;
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/home/posts_in_timeline/widgets/follow_button.dart';
import 'package:auth/presentation/manager/follow_cubit/follow_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_social_info_state.dart';
import 'package:auth/presentation/manager/profile_cubit/profile_state.dart';
import 'package:auth/presentation/notifcations/widgets/notification_avatar.dart';
import 'package:auth/presentation/notifcations/widgets/notification_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/notification.dart';
import 'widgets/base_notification_card.dart';

class FollowUserCard extends StatelessWidget {
  final NotificationEntity notification;
  final String timeText;
  final VoidCallback onTap;

  const FollowUserCard({
    super.key,
    required this.notification,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
          final l10n = AppLocalizations.of(context)!;
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final profileState = context.read<ProfileCubit>().state;
          String myUserId = '';

          if (profileState is ProfileLoaded) {
            myUserId = profileState.user.id;
          }
          return BaseNotificationCard(
            onTap: onTap,
            isRead: notification.isRead,
            leadingWidget: NotificationAvatar(
              imageUrl: notification.senderAvatar,
            ),
            titleWidget: NotificationTitle(
              text: '${notification.senderName} ${l10n.startedFollowingYou}',
            ),
            trailingWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: BlocProvider(
                create: (context) => di.sl<FollowCubit>(),
                child:
                    BlocBuilder<ProfileSocialInfoCubit, ProfileSocialInfoState>(
                      builder: (context, socialState) {
                        bool amIFollowing = false;

                        if (socialState is SocialInfoLoaded) {
                          amIFollowing = socialState.following.any(
                            (f) =>
                                f.user.id.toString().trim() ==
                                notification.senderId.toString().trim(),
                          );
                        }
                        return FollowButton(
                          authorId: notification.senderId,
                          unfollowedText: l10n.followBack,
                          isFollowing: amIFollowing,
                          currentUserId: myUserId,
                          onFollowChanged: () {
                            context.read<ProfileSocialInfoCubit>().fetchFollowing();
                          },
                        );
                      },
                    ),
              ),
            ),
            time: timeText,
          );
        }
}
