import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/notifcations/widgets/notification_avatar.dart';
import 'package:auth/presentation/notifcations/widgets/notification_title.dart';
import 'package:flutter/material.dart';
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

    return BaseNotificationCard(
      onTap: onTap,
      isRead: notification.isRead,
      leadingWidget: NotificationAvatar(imageUrl: notification.senderAvatar),
      titleWidget: NotificationTitle(
        text: '${notification.senderName} ${l10n.startedFollowingYou}',
      ),
      trailingWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          l10n.followBack,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      time: timeText,
    );
  }
}
