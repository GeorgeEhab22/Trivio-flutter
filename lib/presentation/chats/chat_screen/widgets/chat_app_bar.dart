import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String targetUserId;
  final String conversationId;
  final String targetUserName;

  const ChatAppBar({
    super.key,
    required this.targetUserId,
    required this.conversationId,
    required this.targetUserName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: iconColor, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        targetUserName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline, color: iconColor),
          onPressed: () {
            context.push(
              '/app/messages/chat/$conversationId/$targetUserId/$targetUserName/chat_info',
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
