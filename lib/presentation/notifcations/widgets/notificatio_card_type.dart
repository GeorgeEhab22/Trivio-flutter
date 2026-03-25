import 'package:auth/common/functions/format_time.dart';
import 'package:auth/common/functions/number_extensions.dart';
import 'package:auth/domain/entities/notification.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/notification_type.dart';
import '../cards/match_alert_card.dart';
import '../cards/post_react_card.dart';
import '../cards/post_comment_card.dart';
import '../cards/follow_user_card.dart';

class NotificationCardType extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCardType({super.key, required this.notification});

  void _onNotificationTapped(BuildContext context) {
    context.read<NotificationCubit>().markAsRead(notification.id);
  }

  @override
  Widget build(BuildContext context) {
    final timeText = formatTime(
      context,
      notification.createdAt,
    ).localizeDigits(context);

    switch (notification.type) {
      case NotificationType.matchAlert:
        return MatchAlertCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            _onNotificationTapped(context);
            // TODO: go to ex. news screen
          },
        );
      case NotificationType.postReact:
        return PostReactCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            _onNotificationTapped(context);
            // TODO: go to post
          },
        );
      case NotificationType.postComment:
        return PostCommentCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            _onNotificationTapped(context);
            // TODO: go to post
          },
        );
      case NotificationType.followUser:
        return FollowUserCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            _onNotificationTapped(context);
            // TODO: go to follower profile
          },
        );
      case NotificationType.none:
        return const SizedBox.shrink();
    }
  }
}
