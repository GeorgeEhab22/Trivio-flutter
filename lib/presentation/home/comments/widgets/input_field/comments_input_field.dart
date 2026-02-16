import 'package:flutter/material.dart';
import 'package:auth/constants/colors.dart';
import 'package:auth/l10n/app_localizations.dart';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? replyingToUser;
  final VoidCallback onCancelReply;
  final ValueChanged<String> onSubmitted;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCancelReply,
    required this.onSubmitted,
    this.replyingToUser,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),

          if (replyingToUser != null)
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      // Localized: "Replying to $replyingToUser"
                      l10n.replyingTo(replyingToUser!), 
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onCancelReply,
                    child: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: l10n.addCommentHint, // Localized hint
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: onSubmitted,
                  ),
                ),

                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    final bool isNotEmpty = value.text.trim().isNotEmpty;

                    return IconButton(
                      icon: Icon(
                        Icons.send,
                        color: isNotEmpty ? AppColors.primary : Colors.grey,
                      ),
                      onPressed: isNotEmpty
                          ? () => onSubmitted(controller.text)
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}