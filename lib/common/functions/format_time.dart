import 'package:intl/intl.dart';

String formatTime(DateTime? time) {
    if (time == null) return '';

    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    if (diff.inDays < 14) return '${(diff.inDays / 7).floor()}w';
    return DateFormat('MMM d').format(time);
  }