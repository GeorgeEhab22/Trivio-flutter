// ignore_for_file: deprecated_member_use

import 'package:auth/data/models/chatbot_model.dart';
import 'package:auth/presentation/chatbot/widgets/response_footer.dart';
import 'package:auth/presentation/chatbot/widgets/response_header.dart';
import 'package:flutter/material.dart';

class ChatbotBubble extends StatelessWidget {
  final ChatbotModel message;

  const ChatbotBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.senderType == 'human';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF252525) : null,
          gradient: isUser
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF131313), 
                    Color(0xFF003D0A), 
                  ],
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: Border.all(
            color: isUser
                ? Colors.white.withOpacity(0.08)
                : const Color(0xFF00E639).withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) const ResponseHeader(),

            Text(
              message.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14.5,
                height: 1.6,
              ),
            ),

            if (!isUser) ResponseFooter(timestamp: message.createdAt ?? DateTime.now()),
          ],
        ),
      ),
    );
  }
}
