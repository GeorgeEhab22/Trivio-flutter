import 'package:auth/data/models/message_model.dart';
import 'package:auth/domain/entities/message.dart';
import 'package:auth/domain/usecases/chats/get_messages_use_case.dart';
import 'package:auth/domain/usecases/chats/mark_conversation_seen_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetMessagesUseCase getMessagesUseCase;
  final MarkConversationSeenUseCase markConversationSeenUseCase;
  final SharedPreferences prefs;

  io.Socket? socket;
  String? currentChatId;
  String? partnerId;
  List<Message> items = [];
  bool isPartnerTyping = false;

  ChatMessagesCubit({
    required this.getMessagesUseCase,
    required this.markConversationSeenUseCase,
    required this.prefs,
  }) : super(ChatMessagesInitial());

  Future<void> loadMessages(String conversationId, String targetUserId) async {
    currentChatId = conversationId;
    partnerId = targetUserId;

    emit(ChatMessagesLoading());

    final result = await getMessagesUseCase(chatId: conversationId, page: 1);
    //  print('loadMessages result: $result');
    result.fold(
      (failure) => emit(ChatMessagesError(message: failure.message)),
      (messages) {
        items = messages.reversed.toList();
        //  print('loadMessages items: $items');
        emit(ChatMessagesLoaded(messages: List.from(items)));

        _initSocket();
      },
    );
  }

  void _initSocket() {
    final token = prefs.getString('auth_token') ?? '';

    if (socket != null && socket!.connected) {
      socket!.disconnect();
      socket!.dispose();
    }

//TODO:handle mobile later
    socket = io.io(
      'http://localhost:3500',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io')
          .setAuth({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .build(),
    );

    socket?.onConnectError((err) => print(' Socket Connect Error: $err'));
    socket?.onError((err) => print(' Socket Error: $err'));
    socket?.onDisconnect((_) => print(' Socket Disconnected'));

    socket?.connect();

    socket?.onConnect((_) {
      // print('Socket Connected Successfully');
      socket?.emit('chat:read', {'conversationId': currentChatId});
    });

    socket?.on('chat:message', (data) {
      //print('New Message Received: $data');
      if (data['conversationId'] == currentChatId) {
        final newMessage = MessageModel.fromJson(data);
        items.insert(0, newMessage);
        emit(ChatMessagesLoaded(messages: List.from(items)));

        if (newMessage.senderId != prefs.getString('user_id')) {
          socket?.emit('chat:read', {'conversationId': currentChatId});
        }
      }
    });

    socket?.on('chat:error', (data) {
      final errorMsg = data['message'] ?? 'An error occurred';
      // print('Chat Error from Server: $errorMsg');
      emit(ChatMessagesError(message: errorMsg, messages: List.from(items)));
      emit(ChatMessagesLoaded(messages: List.from(items)));
    });

    socket?.on('chat:read', (data) {
      if (data['conversationId'] == currentChatId) {
        items = items
            .map(
              (m) => MessageModel(
                messageId: m.messageId,
                chatId: m.chatId,
                senderId: m.senderId,
                text: m.text,
                isSeen: true,
                createdAt: m.createdAt,
              ),
            )
            .toList();
        emit(ChatMessagesLoaded(messages: List.from(items)));
      }
    });

    socket?.on('chat:typing', (data) {
      if (data['conversationId'] == currentChatId) {
        isPartnerTyping = true;
        emit(ChatMessagesLoaded(messages: List.from(items)));
      }
    });

    socket?.on('chat:stop_typing', (data) {
      if (data['conversationId'] == currentChatId) {
        isPartnerTyping = false;
        emit(ChatMessagesLoaded(messages: List.from(items)));
      }
    });
  }

  void sendMessage(String text, String myId) {
    if (currentChatId == null || text.trim().isEmpty) return;

    final messageText = text.trim();

    //print(' Sending Message: $messageText');
    socket?.emit('chat:send', {
      'conversationId': currentChatId,
      'content': messageText,
    });

    sendTypingEvent(isTyping: false);
  }

  void sendTypingEvent({required bool isTyping}) {
    final event = isTyping ? 'chat:typing' : 'chat:stop_typing';
    socket?.emit(event, {
      'conversationId': currentChatId,
      'recipientId': partnerId,
    });
  }

  Future<void> markAsRead(String conversationId) async {
    await markConversationSeenUseCase(conversationId: conversationId);
  }

  @override
  Future<void> close() {
    socket?.disconnect();
    socket?.dispose();
    return super.close();
  }
}
