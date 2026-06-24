import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String chatId;
  final String participantId;
  final String participantName;
  final String? participantAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
final bool isLastMessageRead;

  const Chat({
    required this.chatId,
    required this.participantId,
    required this.participantName,
    this.participantAvatar,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.isLastMessageRead = true,
  });

  @override
  List<Object?> get props => [
        chatId,
        participantId,
        participantName,
        participantAvatar,
        lastMessage,
        lastMessageTime,
        lastMessageSenderId,
        isLastMessageRead,
      ];
}