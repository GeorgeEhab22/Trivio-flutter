import 'package:flutter/material.dart';
import 'package:auth/constants/colors';

class CommentInputField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String text) onSend;
  final FocusNode? focusNode;
  final String? replyingTo;
  final VoidCallback? onCancelReply;

  const CommentInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.focusNode,
    this.replyingTo,
    this.onCancelReply,
  });

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 1,
            color: Color(0xFFE0E0E0),
          ),
          if (widget.replyingTo != null) ...[
            Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Replying to ${widget.replyingTo}",
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onCancelReply,
                    child: const Icon(Icons.close, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFE0E0E0),
            ),
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
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          widget.onSend(value);
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _hasText
                      ? () => widget.onSend(widget.controller.text)
                      : null,
                  child: Icon(
                    Icons.send,
                    size: 22,
                    color: _hasText
                        ? AppColors.primary
                        : Colors
                              .grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
