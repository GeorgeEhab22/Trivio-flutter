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
    return MessageModel(
      messageId: json['_id'] ?? json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      isSeen: json['isSeen'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}