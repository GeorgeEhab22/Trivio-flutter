import 'package:auth/domain/entities/chat.dart';
import 'package:auth/domain/usecases/chats/get_chats_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetChatsUseCase getChatsUseCase;

  ChatsCubit({required this.getChatsUseCase}) : super(ChatsInitial());

  List<Chat> items = [];
  int page = 1;
  bool hasReachedMax = false;
  bool _isFetching = false;

  Future<void> loadChats({bool refresh = false}) async {
    if (_isFetching || state is ChatsLoading || state is ChatsLoadingMore) {
      return;
    }
    _isFetching = true;

    if (refresh) {
      items.clear();
      page = 1;
      hasReachedMax = false;
    }

    if (items.isEmpty) {
      emit(ChatsLoading());
    } else {
      if (hasReachedMax) {
        _isFetching = false;
        return;
      }
      emit(ChatsLoadingMore(chats: List.from(items)));
    }

    final result = await getChatsUseCase(page: page);

    result.fold(
      (failure) {
        _isFetching = false;
        emit(ChatsError(message: failure.message, chats: List.from(items)));
      },
      (newItems) {
        if (isClosed) return;

        if (newItems.isEmpty) {
          hasReachedMax = true;
        } else {
          final existingIds = items.map((e) => e.chatId).toSet();
          final uniqueItems = newItems.where((e) => !existingIds.contains(e.chatId)).toList();

          if (uniqueItems.isEmpty) {
            hasReachedMax = true;
          } else {
            items.addAll(uniqueItems);
            page++;
          }
        }

        emit(ChatsLoaded(chats: List.from(items), hasReachedMax: hasReachedMax));
        Future.delayed(const Duration(milliseconds: 500), () {
          _isFetching = false;
        });
      },
    );
  }

  void updateChatLocally(Chat updatedChat) {
    items.removeWhere((chat) => chat.chatId == updatedChat.chatId);
    items.insert(0, updatedChat); 
    emit(ChatsLoaded(chats: List.from(items), hasReachedMax: hasReachedMax));
  }
}