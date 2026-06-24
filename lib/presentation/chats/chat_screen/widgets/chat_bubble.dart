import 'package:auth/presentation/chats/chat_screen/widgets/message_action_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final bool isSeen;
  final String time;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.message,
    this.isSeen = false,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ValueNotifier<bool> isHovered = ValueNotifier(false);

    final myGradientDark = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF006B1F), Color(0xFF003810)],
    );
    final myGradientLight = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF006B1F), Color(0xFF003810)],
    );

    final friendBgDark = const Color(0xFF262626);
    final friendBgLight = const Color(0xFFFFFFFF);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onLongPress: () => showMessageActions(context,message),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe) _WebMoreButton(isHovered: isHovered),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: isMe
                    ? BoxDecoration(
                        gradient: isDark ? myGradientDark : myGradientLight,
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(16),
                          topEnd: Radius.circular(16),
                          bottomStart: Radius.circular(16),
                          bottomEnd: Radius.circular(4),
                        ),
                      )
                    : BoxDecoration(
                        color: isDark ? friendBgDark : friendBgLight,
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(16),
                          topEnd: Radius.circular(16),
                          bottomStart: Radius.circular(4),
                          bottomEnd: Radius.circular(16),
                        ),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.black.withValues(alpha: 0.08),
                          width: 1,
                        ),
                        boxShadow: isDark
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        color: isMe
                            ? Colors.white
                            : (isDark
                                  ? Colors.white.withValues(alpha: 0.95)
                                  : Colors.black87),
                        fontSize: 14.5,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white.withValues(alpha: 0.7)
                                : (isDark
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : Colors.black54),
                            fontSize: 11,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            isSeen ? Icons.done_all : Icons.check,
                            size: 16,
                            color: isSeen
                                ? const Color(0xFF64D2FF)
                                : Colors.white.withValues(alpha: 0.7),
                          ),
                        ],
                      ],
                    ),
                  ],
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
            onPressed: () => showMessageActions(context,""),
          ),
        );
      },
    );
  }
}
