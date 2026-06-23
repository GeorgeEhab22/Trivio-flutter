import 'package:auth/data/models/chat_model.dart';
import 'package:auth/data/models/message_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/functions/handle_dio_error.dart';
import 'package:auth/data/core/error/exceptions.dart';
import '../../common/api_service.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats({int page = 1});
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int page = 1,
  });
  Future<MessageModel> sendMessage({
    required String chatId,
    required String text,
  });
  Future<void> markAsSeen({required String messageId});
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
    if (token == null) throw AuthException('No auth token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<ChatModel>> getChats({int page = 1}) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.chats}?page=$page",
        options: _getAuthOptions(),
      );
      final List data = response['data']['chats'] ?? [];
      return data.map((e) => ChatModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int page = 1,
  }) async {
    try {
      final response = await api.get(
        "${ApiEndpoints.chats}/$chatId/messages?page=$page",
        options: _getAuthOptions(),
      );
      final List data = response['data']['messages'] ?? [];
      return data.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      final response = await api.post(
        "${ApiEndpoints.chats}/$chatId/messages",
        data: {'text': text},
        options: _getAuthOptions(),
      );
      return MessageModel.fromJson(response['data']['message']);
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<void> markAsSeen({required String messageId}) async {
    try {
      await api.patch(
        "${ApiEndpoints.messages}/$messageId/seen",
        options: _getAuthOptions(),
      );
    } catch (e) {
      errorHandler.handleDioError(e);
      rethrow;
    }
  }
}
