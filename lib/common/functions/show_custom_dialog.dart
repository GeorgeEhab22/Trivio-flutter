import 'package:auth/constants/colors.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText, 
  Color? confirmTextColor,
  VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final l10n = AppLocalizations.of(context)!;

      return AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              l10n.cancelBtn, 
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              if (onConfirm != null) onConfirm();
              context.pop();
            },
            child: Text(
              confirmText ?? l10n.accept, 
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