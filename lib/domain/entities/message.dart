import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String messageId;
  final String chatId;
  final String senderId;
  final String text;
  final bool isSeen;
  final DateTime createdAt;

  const Message({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.text,
    this.isSeen = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        messageId,
        chatId,
        senderId,
        text,
        isSeen,
        createdAt,
      ];
}