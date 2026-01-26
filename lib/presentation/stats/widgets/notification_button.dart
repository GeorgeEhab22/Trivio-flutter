import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  bool isNotified = false; // keeps track of icon state

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isNotified = !isNotified; // toggle the state
        });
      },
      icon: Icon(
        isNotified ? Icons.notifications_active : Icons.notifications_none,
        color: AppColors.primary,
      ),
    );
  }
}