import 'package:auth/presentation/chats/chat_screen/widgets/message_action_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  const ChatBubble({super.key, required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ValueNotifier<bool> isHovered = ValueNotifier(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onLongPress: () => showMessageActions(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            // Use end/start so it flips automatically in RTL
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (isMe) _WebMoreButton(isHovered: isHovered),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? const Color(0XFF008B1D)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                  // Use BorderRadiusDirectional to handle RTL corners
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: const Radius.circular(15),
                    topEnd: const Radius.circular(15),
                    bottomStart: Radius.circular(isMe ? 15 : 0),
                    bottomEnd: Radius.circular(isMe ? 0 : 15),
                  ),
                ),
                constraints: const BoxConstraints(maxWidth: 250),
                child: Text(
                  message,
                  style: TextStyle(
                    color: isMe
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 15,
                  ),
                ),
              ),
              if (!isMe) _WebMoreButton(isHovered: isHovered),
            ],
          ),
        ),
      ),
    );
  }
}

class _WebMoreButton extends StatelessWidget {
  final ValueNotifier<bool> isHovered;
  const _WebMoreButton({required this.isHovered});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();
    return ValueListenableBuilder(
      valueListenable: isHovered,
      builder: (context, hovered, child) {
        return Opacity(
          opacity: hovered ? 1 : 0,
          child: IconButton(
            icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
            onPressed: () => showMessageActions(context),
          ),
        );
      },
    );
  }
}