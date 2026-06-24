import 'package:auth/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.messageId,
    required super.chatId,
    required super.senderId,
    required super.text,
    super.isSeen,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final senderData = json['sender'] ?? {};

    return MessageModel(
      messageId: json['_id'] ?? '',
      chatId: json['conversation'] ?? json['conversationId'] ?? '',
      senderId: senderData['_id'] ?? senderData ?? '',
      text: json['content'] ?? '',
      isSeen: json['isRead'] ?? false, 
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']).toLocal() 
          : DateTime.now(),
    );
  }
}