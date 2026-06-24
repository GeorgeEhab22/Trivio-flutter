import 'package:auth/domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.chatId,
    required super.participantId,
    required super.participantName,
    super.participantAvatar,
    super.lastMessage,
    super.lastMessageTime,
    super.lastMessageSenderId,
    super.isLastMessageRead,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final participants = json['participants'] as List<dynamic>? ?? [];

    dynamic other;
    try {
      other = participants.firstWhere((p) {
        if (p is String) return p != currentUserId;
        if (p is Map) return p['_id'] != currentUserId;
        return false;
      });
    } catch (_) {
      other = participants.isNotEmpty ? participants.first : '';
    }

    String pId = '';
    String pName = 'Unknown';
    String? pAvatar;

    if (other is String) {
      pId = other;
    } else if (other is Map) {
      pId = other['_id'] ?? '';
      pName = other['username'] ?? 'Unknown';
      pAvatar = other['avatar'];
    }

    final lastMsg = json['lastMessage'];
    String? lastSenderId;
    bool lastIsRead = false;

    if (lastMsg != null) {
      if (lastMsg['sender'] != null) {
        lastSenderId = lastMsg['sender']['_id'] ?? lastMsg['sender'];
      }
      lastIsRead = lastMsg['isRead'] ?? false;
    }
    return ChatModel(
      chatId: json['_id'] ?? '',
      participantId: pId,
      participantName: pName,
      participantAvatar: pAvatar,
      lastMessage: lastMsg != null ? lastMsg['content'] : null,
      lastMessageTime: lastMsg != null && lastMsg['createdAt'] != null
          ? DateTime.parse(lastMsg['createdAt']).toLocal()
          : null,
      lastMessageSenderId: lastSenderId,
      isLastMessageRead: lastIsRead,
    );
  }
}
