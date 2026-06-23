import 'package:auth/domain/entities/chat.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.chatId,
    required super.receiverId,
    required super.receiverName,
    super.receiverAvatar,
    super.lastMessage,
    super.lastMessageTime,
    super.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['_id'] ?? json['id'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? 'Unknown',
      receiverAvatar: json['receiverAvatar'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null 
          ? DateTime.parse(json['lastMessageTime']) 
          : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }
}