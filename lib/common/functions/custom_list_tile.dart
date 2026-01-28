import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final VoidCallback onTap;
  final bool withArrow;
  final bool  redColor;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
    this.withArrow= false,
    this.redColor=false,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        color ??
        (redColor
            ? Colors.redAccent
            : (Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87));

    final Color iconColor =
        color ??
        (redColor
            ? Colors.redAccent
            : (Theme.of(context).iconTheme.color ?? Colors.black87));

    return ListTile(
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: withArrow
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }
}
