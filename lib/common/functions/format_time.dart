import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTime(BuildContext context, DateTime? time) {
  if (time == null) return '';

  final l10n = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).languageCode;
  final diff = DateTime.now().difference(time);

  if (diff.inMinutes < 1) return l10n.justNow;
  if (diff.inMinutes < 60) return '${diff.inMinutes}${l10n.minuteLetter}';
  if (diff.inHours < 24) return '${diff.inHours}${l10n.hourLetter}';
  if (diff.inDays < 7) return '${diff.inDays}${l10n.dayLetter}';
  if (diff.inDays < 14) return '${(diff.inDays / 7).floor()}${l10n.weekLetter}';
  
  // Localized date (e.g., "Feb 19" in EN, "١٩ فبراير" in AR)
  return DateFormat.MMMd(locale).format(time);
}