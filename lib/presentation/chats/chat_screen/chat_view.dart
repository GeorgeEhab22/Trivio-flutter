import 'package:flutter/material.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input_field.dart';
import 'widgets/chat_app_bar.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: 20,
              itemBuilder: (context, index) {
                return ChatBubble(
                  isMe: index % 2 == 0,
                  message: index % 2 == 0
                      ? "from me"
                      : "message from my friend...",
                );
              },
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}