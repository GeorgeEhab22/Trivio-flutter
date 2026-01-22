import 'package:auth/common/functions/copy_to_clipboard.dart';
import 'package:auth/common/functions/show_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showMessageActions(BuildContext context) {
  String copiedMessage = "change later to actual message";
  final handleBarColor = Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[700]
      : Colors.grey[300];
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: handleBarColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRowButton(context, Icons.reply, "Reply", () {
                context.pop();
              }),
              _buildRowButton(context, Icons.copy_rounded, "Copy", () {
                context.pop();
                // TODO: assign actual message to copiedMessage
                copyToClipboard(context, copiedMessage);
              }),
              _buildRowButton(context, Icons.delete_outline, "Delete", () {
                context.pop();
                showCustomDialog(
                  context: context,
                  title: "Delete",
                  content: "Are you sure you want to delete this message?",
                  confirmText: "Delete",
                  confirmTextColor: Colors.red,
                  onConfirm: () {
                    // TODO: add delete functionality later
                  },
                );
              }),
              _buildRowButton(
                context,
                Icons.report_gmailerrorred,
                "Report",
                () {
                  // TODO: add report functionality later
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildRowButton(
  BuildContext context,
  IconData icon,
  String label,
  VoidCallback onTap,
) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ),
  );
}
