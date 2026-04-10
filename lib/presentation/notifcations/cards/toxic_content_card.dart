import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/notification.dart';
import 'widgets/base_notification_card.dart';
import 'package:auth/presentation/notifcations/widgets/notification_title.dart';

class ToxicContentCard extends StatelessWidget {
  final NotificationEntity notification;
  final String timeText;
  final VoidCallback? onTap;

  const ToxicContentCard({
    super.key,
    required this.notification,
    required this.timeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    String localizedMessage = notification.message;

    if (isArabic) {
      if (notification.message.contains("violating our community guidelines")) {
        localizedMessage = "تم حذف منشورك لانتهاكه معايير المجتمع الخاصة بنا.";
      } else if (notification.message.contains("flagged for review")) {
        localizedMessage = "تم وضع منشورك قيد المراجعة بسبب محتوى غير لائق.";
      }
    }
    return BaseNotificationCard(
      onTap: () {
        null;
      },
      isRead: true,
      isToxic: true,
      leadingWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.block, color: Colors.redAccent, size: 28),
      ),
      titleWidget: NotificationTitle(text: l10n.toxicContentTitle),
      subtitle: localizedMessage,
      time: timeText,
    );
  }
}
