import 'package:auth/data/models/chat_model.dart';
import 'package:auth/data/models/message_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import '../../common/api_service.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats(String currentUserId);
  Future<List<MessageModel>> getMessages(String conversationId, int page);
  Future<ChatModel> getOrCreateConversation(String targetUserId);
  Future<void> markConversationAsRead(String conversationId);
  Future<int> getUnreadCount();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService api;
  final SharedPreferences prefs;
  final ErrorHandler errorHandler;

  ChatRemoteDataSourceImpl({
    required this.api,
    required this.prefs,
    required this.errorHandler,
  });

  Options _getAuthOptions() {
    final token = prefs.getString('auth_token');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
Future<List<ChatModel>> getChats(String currentUserId) async {
  final response = await api.get(
    "chat/conversations",
    options: _getAuthOptions(),
  );

  final List data = response['data']['conversations'] ?? [];

  return data
      .map((e) => ChatModel.fromJson(e, currentUserId))
      .toList();
}

  @override
  Future<List<MessageModel>> getMessages(String conversationId, int page) async {
    try {
        //  print('getMessages -> conversationId: $conversationId, page: $page');

      final response = await api.get(
        "chat/conversations/$conversationId/messages?page=$page&limit=20",
        options: _getAuthOptions()
      );
    //  print('getMessages response: $response');
      final List data = response['data']['messages'] ?? [];
    //      print('getMessages messages count: ${data.length}');

      return data.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
     // print('getMessages ERROR: $e');
    //print('STACK: $st');
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

@override

  Future<ChatModel> getOrCreateConversation(String targetUserId) async {
    try {
      final response = await api.post(
        "chat/conversations/$targetUserId", 
        options: _getAuthOptions()
      );
      //  print('getOrCreateConversation response: $response');
      return ChatModel.fromJson(response['data']['conversation'], targetUserId);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      await api.patch(
        "chat/conversations/$conversationId/read",
        options: _getAuthOptions()
      );
      //  print('markConversationAsRead response: $conversationId');
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await api.get(
        "chat/unread-count",
        options: _getAuthOptions()
      );
      //  print('getUnreadCount response: $response');
      return response['data']['unreadCount'] ?? 0;
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}