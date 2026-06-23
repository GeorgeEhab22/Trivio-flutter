import 'package:auth/domain/entities/chat.dart';
import 'package:equatable/equatable.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object?> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoading extends ChatsState {}

class ChatsLoaded extends ChatsState {
  final List<Chat> chats;
  final bool hasReachedMax;

  const ChatsLoaded({required this.chats, this.hasReachedMax = false});

  @override
  List<Object?> get props => [chats, hasReachedMax];
}

class ChatsLoadingMore extends ChatsState {
  final List<Chat> chats;
  const ChatsLoadingMore({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class ChatsError extends ChatsState {
  final String message;
  final List<Chat> chats;

  const ChatsError({required this.message, this.chats = const []});

  @override
  List<Object?> get props => [message, chats];
}