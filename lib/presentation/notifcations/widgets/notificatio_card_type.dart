import 'package:auth/common/functions/format_time.dart';
import 'package:auth/common/functions/number_extensions.dart';
import 'package:auth/core/app_routes.dart';
import 'package:auth/domain/entities/notification.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:auth/presentation/notifcations/cards/toxic_content_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/notification_type.dart';
import '../cards/match_alert_card.dart';
import '../cards/post_react_card.dart';
import '../cards/post_comment_card.dart';
import '../cards/follow_user_card.dart';

class NotificationCardType extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCardType({super.key, required this.notification});

  void _onNotificationTapped(BuildContext context, String routePath) {
    context.read<NotificationCubit>().markAsRead(notification.id);
    GoRouter.of(context).push(routePath);
  }

  @override
  Widget build(BuildContext context) {
    final timeText = formatTime(
      context,
      notification.createdAt,
    ).localizeDigits(context);

    final bool isToxic =
        notification.message.contains("violating our community guidelines") ||
        notification.message.contains("inappropriate content");

    if ((notification.senderId == notification.receiverId) && !isToxic) {
      return const SizedBox.shrink();
    }

    if (isToxic) {
      return ToxicContentCard(notification: notification, timeText: timeText);
    }
    switch (notification.type) {
      case NotificationType.matchAlert:
        return MatchAlertCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            _onNotificationTapped(context, AppRoutes.stats);
          },
        );
      case NotificationType.react:
        return PostReactCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            final path = AppRoutes.singlePostPath(notification.entityId);
            _onNotificationTapped(context, path);
          },
        );
      case NotificationType.comment:
        return PostCommentCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            final targetPostId = notification.postId ?? notification.entityId;
            print("Target Post ID: $targetPostId");
            print("Comment ID: ${notification.entityId}");
            final commentId = notification.entityId;

            final path = Uri(
              path: AppRoutes.singlePostPath(targetPostId),
              queryParameters: {'commentId': commentId},
            ).toString();

            _onNotificationTapped(context, path);
          },
        );
      case NotificationType.follow:
        return FollowUserCard(
          notification: notification,
          timeText: timeText,
          onTap: () {
            final profilePath = AppRoutes.userProfileByIdPath(
              notification.senderId,
            );
            _onNotificationTapped(context, profilePath);
          },
        );
      case NotificationType.none:
        return const SizedBox.shrink();
    }
  }
}
