import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/notifcations/widgets/notification_avatar.dart';
import 'package:auth/presentation/notifcations/widgets/notification_title.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/notification.dart';
import 'widgets/base_notification_card.dart';

class PostCommentCard extends StatelessWidget {
  final NotificationEntity notification;
  final String timeText;
  final VoidCallback onTap;

  const PostCommentCard({
    super.key,
    required this.notification,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseNotificationCard(
      onTap: onTap,
      isRead: notification.isRead,
      leadingWidget: NotificationAvatar(imageUrl: notification.senderAvatar),
      titleWidget: NotificationTitle(text: '${notification.senderName} ${l10n.commented} '),
      subtitle: notification.content != null
          ? '"${notification.content}"'
          : null,

      time: timeText,
    );
  }
}
