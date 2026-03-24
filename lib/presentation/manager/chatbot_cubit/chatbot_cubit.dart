import 'package:auth/data/models/chatbot_model.dart';
import 'package:auth/domain/usecases/chatbot/get_chat_history_usecase.dart';
import 'package:auth/domain/usecases/chatbot/send_message_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chatbot_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUsecase sendMessageUsecase;
  final GetChatHistoryUsecase getChatHistoryUsecase;

  ChatCubit({
    required this.sendMessageUsecase,
    required this.getChatHistoryUsecase,
  }) : super(const ChatInitial());

  Future<void> loadHistory() async {
    emit(const ChatLoading(messages: []));

    try {
      final result = await getChatHistoryUsecase();

      result.fold(
        (failure) {
          emit(ChatError(message: failure.message));
        },
        (messages) {
          emit(ChatLoaded(messages: messages));
        },
      );
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Get current messages
    final currentMessages = switch (state) {
      ChatLoaded(:final messages) => messages,
      ChatLoading(:final messages) => messages,
      _ => <ChatbotModel>[],
    };

    final userMessage = ChatbotModel(
      text: text.trim(),
      senderType: 'human', 
      createdAt: DateTime.now(),
    );

    final updatedMessages = [...currentMessages, userMessage];
    emit(ChatLoading(messages: updatedMessages));

    try {
      final result = await sendMessageUsecase(text.trim());

      result.fold((failure) => emit(ChatError(message: failure.message)), (
        aiReply,
      ) {
        emit(ChatLoaded(messages: [...updatedMessages, aiReply]));
      });
    } catch (e) {
      emit(ChatError(message: e.toString()));
    }
  }
}
