
part of 'chatbot_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {
  const ChatInitial();
}

final class ChatLoading extends ChatState {
  final List<ChatbotModel> messages;

  const ChatLoading({required this.messages});

  @override
  List<Object> get props => [messages];
}

final class ChatLoaded extends ChatState {
  final List<ChatbotModel> messages;

  const ChatLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

final class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object> get props => [message];
}