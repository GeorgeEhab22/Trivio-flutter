import 'package:auth/domain/entities/message.dart';
import 'package:equatable/equatable.dart';

abstract class ChatMessagesState extends Equatable {
  const ChatMessagesState();

  @override
  List<Object?> get props => [];
}

class ChatMessagesInitial extends ChatMessagesState {}

class ChatMessagesLoading extends ChatMessagesState {}

class ChatMessagesLoaded extends ChatMessagesState {
  final List<Message> messages;
  final bool hasReachedMax;

  const ChatMessagesLoaded({required this.messages, this.hasReachedMax = false});

  @override
  List<Object?> get props => [messages, hasReachedMax];
}
class ChatPartnerTyping extends ChatMessagesState {}

class ChatMessagesLoadingMore extends ChatMessagesState {
  final List<Message> messages;
  const ChatMessagesLoadingMore({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatMessagesError extends ChatMessagesState {
  final String message;
  final List<Message> messages;

  const ChatMessagesError({required this.message, this.messages = const []});

  @override
  List<Object?> get props => [message, messages];
}

class MessageSending extends ChatMessagesState {
  final List<Message> messages;
  const MessageSending({required this.messages});
  
  @override
  List<Object?> get props => [messages];
}