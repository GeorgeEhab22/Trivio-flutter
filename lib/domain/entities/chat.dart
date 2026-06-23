import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String chatId;
  final String receiverId;
  final String receiverName;
  final String? receiverAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  const Chat({
    required this.chatId,
    required this.receiverId,
    required this.receiverName,
    this.receiverAvatar,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        chatId,
        receiverId,
        receiverName,
        receiverAvatar,
        lastMessage,
        lastMessageTime,
        unreadCount,
      ];
}