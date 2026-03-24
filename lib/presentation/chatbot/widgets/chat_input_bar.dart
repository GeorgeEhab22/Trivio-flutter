import 'package:auth/presentation/chatbot/widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: 12 + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF131313).withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                onPressed: () {},
                tooltip: 'Attach',
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Inquire about match dynamics...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SendButton(onSend: onSend, controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}


