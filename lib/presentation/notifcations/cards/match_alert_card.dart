import 'package:auth/constants/colors.dart';
import 'package:auth/presentation/notifcations/widgets/notification_title.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/notification.dart';
import 'widgets/base_notification_card.dart';

class MatchAlertCard extends StatelessWidget {
  final NotificationEntity notification;
  final String timeText;
  final VoidCallback onTap;

  const MatchAlertCard({
    super.key,
    required this.notification,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF1DB954);
    return BaseNotificationCard(
      onTap: onTap,
      isRead: notification.isRead,
      leadingWidget: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: primaryGreen.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.sports_soccer, color: AppColors.darkGreen, size: 24),
      ),
      titleWidget: NotificationTitle(
        text: notification.senderName,
        boldColor: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      subtitle: notification.content,
      time: timeText,
      isTimeHighlighted: true,
    );
  }
}
