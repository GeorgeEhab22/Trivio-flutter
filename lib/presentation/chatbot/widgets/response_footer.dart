import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ResponseFooter extends StatelessWidget {
  final DateTime timestamp;
  const ResponseFooter({super.key, required this.timestamp});

String _toArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }
    return input;
  }
  String _formatTime(DateTime t, bool isArabic) {
    final now = DateTime.now();
    final diff = now.difference(t);
    final int minutes = diff.inMinutes;

    if (isArabic) {
      if (minutes < 1) return 'الآن';
      if (minutes == 1) return 'منذ دقيقة';
      if (minutes == 2) return 'منذ دقيقتين';
      if (minutes >= 3 && minutes <= 10) return 'منذ ${_toArabicNumbers(minutes.toString())} دقائق';
      return 'منذ ${_toArabicNumbers(minutes.toString())} دقيقة';
    } else {
      if (minutes < 1) return 'Just now';
      if (minutes == 1) return '1 min ago';
      return '$minutes mins ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded,
                size: 12, color: Colors.white.withValues(alpha: 0.35)),
            const SizedBox(width: 4),
            Text(
              _formatTime(timestamp, isArabic),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 14),
            Icon(Icons.analytics_outlined,
                size: 12, color: Colors.white.withValues(alpha: 0.35)),
            const SizedBox(width: 4),
            Text(
              l10n.dataAnalysisMode,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}