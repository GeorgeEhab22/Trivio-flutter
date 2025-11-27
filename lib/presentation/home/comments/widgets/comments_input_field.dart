import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

class CommentInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? replyingTo;

  const CommentInputField({
    super.key,
    required this.controller,
    this.focusNode,
    this.replyingTo,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey[300] ?? const Color(0xFFD6D6D6);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          if (replyingTo != null) ...[
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Replying to $replyingTo",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {}, // handle using cubit
                    child: const Icon(Icons.close, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
          ],

          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_){}, // handle using cubit
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed:null, // handle using cubit
                  icon: Icon(Icons.send),
                  color: Colors.grey,    // color handle using cubit
                  tooltip: 'Send comment', 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
