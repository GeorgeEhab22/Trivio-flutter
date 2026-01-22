import 'package:auth/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = "Accept",
  Color? confirmTextColor,
  VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) onConfirm();
              context.pop();
            },
            child: Text(
              confirmText,
              style: TextStyle(
                color: confirmTextColor ?? AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
