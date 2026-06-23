import 'package:auth/domain/entities/message.dart';
import 'package:auth/domain/usecases/chats/get_messages_use_case.dart';
import 'package:auth/domain/usecases/chats/send_message_use_case.dart';
import 'package:auth/domain/usecases/chats/mark_message_seen_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final MarkMessageSeenUseCase markMessageSeenUseCase;

  ChatMessagesCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.markMessageSeenUseCase,
  }) : super(ChatMessagesInitial());

  List<Message> items = [];
  int page = 1;
  bool hasReachedMax = false;
  bool _isFetching = false;
  String? currentChatId;

  Future<void> loadMessages(String chatId, {bool refresh = false}) async {
    currentChatId = chatId;

    if (_isFetching ||
        state is ChatMessagesLoading ||
        state is ChatMessagesLoadingMore) {
      return;
    }
    _isFetching = true;

    if (refresh) {
      items.clear();
      page = 1;
      hasReachedMax = false;
    }

    if (items.isEmpty) {
      emit(ChatMessagesLoading());
    } else {
      if (hasReachedMax) {
        _isFetching = false;
        return;
      }
      emit(ChatMessagesLoadingMore(messages: List.from(items)));
    }

    final result = await getMessagesUseCase(chatId: chatId, page: page);

    result.fold(
      (failure) {
        _isFetching = false;
        emit(
          ChatMessagesError(
            message: failure.message,
            messages: List.from(items),
          ),
        );
      },
      (newItems) {
        if (isClosed) return;

        if (newItems.isEmpty) {
          hasReachedMax = true;
        } else {
          final existingIds = items.map((e) => e.messageId).toSet();
          final uniqueItems = newItems
              .where((e) => !existingIds.contains(e.messageId))
              .toList();

          if (uniqueItems.isEmpty) {
            hasReachedMax = true;
          } else {
            items.addAll(uniqueItems);
            page++;
          }
        }

        emit(
          ChatMessagesLoaded(
            messages: List.from(items),
            hasReachedMax: hasReachedMax,
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          _isFetching = false;
        });
      },
    );
  }

  Future<void> sendMessage(String text) async {
    if (currentChatId == null || text.trim().isEmpty) return;

    emit(MessageSending(messages: List.from(items)));

    final result = await sendMessageUseCase(chatId: currentChatId!, text: text);

    result.fold(
      (failure) {
        emit(
          ChatMessagesError(
            message: failure.message,
            messages: List.from(items),
          ),
        );
      },
      (newMessage) {
        items.insert(0, newMessage);
        emit(
          ChatMessagesLoaded(
            messages: List.from(items),
            hasReachedMax: hasReachedMax,
          ),
        );
      },
    );
  }

  void insertMessageLocally(Message newMessage) {
    final exists = items.any((msg) => msg.messageId == newMessage.messageId);
    if (!exists) {
      items.insert(0, newMessage);
      emit(
        ChatMessagesLoaded(
          messages: List.from(items),
          hasReachedMax: hasReachedMax,
        ),
      );
    }
  }

  Future<void> markMessageAsSeen(String messageId) async {
    final index = items.indexWhere((msg) => msg.messageId == messageId);

    if (index != -1 && !items[index].isSeen) {
      final updatedMessage = Message(
        messageId: items[index].messageId,
        chatId: items[index].chatId,
        senderId: items[index].senderId,
        text: items[index].text,
        createdAt: items[index].createdAt,
        isSeen: true,
      );

      items[index] = updatedMessage;
      emit(
        ChatMessagesLoaded(
          messages: List.from(items),
          hasReachedMax: hasReachedMax,
        ),
      );
    }

    final result = await markMessageSeenUseCase(messageId: messageId);

    result.fold((failure) {}, (_) {});
  }
}
