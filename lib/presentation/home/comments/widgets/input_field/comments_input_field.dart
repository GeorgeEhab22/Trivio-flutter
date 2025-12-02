import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

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
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1),

          if (replyingToUser != null)
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Replying to $replyingToUser",
                      style: const TextStyle(color: AppColors.primary),
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
                // user profile photo => TODO: change it later
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),

                const SizedBox(width: 10),

                // text field
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: onSubmitted,
                  ),
                ),

                // submit button
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
