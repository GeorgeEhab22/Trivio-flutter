import 'package:flutter/material.dart';

class ResponseFooter extends StatelessWidget {
  final DateTime timestamp;
  const ResponseFooter({super.key, required this.timestamp});

  String _formatTime(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes == 1) return '1 min ago';
    return '${diff.inMinutes} mins ago';
  }

  @override
  Widget build(BuildContext context) {
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
              _formatTime(timestamp),
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
              'Data Analysis Mode',
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