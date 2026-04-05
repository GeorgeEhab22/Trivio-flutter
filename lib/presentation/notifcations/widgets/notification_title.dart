import 'package:flutter/material.dart';

class NotificationTitle extends StatelessWidget {
  final String text;
  final Color? boldColor;
  const NotificationTitle({super.key, required this.text, this.boldColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : Colors.black87;
    return RichText(
      text: TextSpan(
        style: TextStyle(color: defaultColor, fontSize: 14, height: 1.3),
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              color: boldColor ?? defaultColor,
              fontWeight: boldColor != null
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
