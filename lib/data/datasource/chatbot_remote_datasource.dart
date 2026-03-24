import 'package:auth/common/api_endpoints.dart';
import 'package:auth/common/api_service.dart';
import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/chatbot_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChatbotRemoteDatasource {
  Future<Either<Failure, List<ChatbotModel>>> fetchChatHistory();
  Future<Either<Failure, ChatbotModel>> sendMessage(String message);
}

class ChatbotRemoteDatasourceImpl implements ChatbotRemoteDatasource {
  final ApiService api;
  final SharedPreferences prefs;

  ChatbotRemoteDatasourceImpl( {required this.api,required this.prefs});

  @override
  Future<Either<Failure, List<ChatbotModel>>> fetchChatHistory() async {
    final token = prefs.getString('auth_token');
    try {
      final response = await api.get(ApiEndpoints.chatbotHistory,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['status'] != 'success') {
        return Left(ServerFailure('Failed to fetch chat history'));
      }
      final data = response['data'] as Map<String, dynamic>;
      final messages = data['messages'] as List<dynamic>;

      return Right(
        messages
            .map((e) => ChatbotModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure("not able to connect to server"));
      }

      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatbotModel>> sendMessage(String message) async {
    final token = prefs.getString('auth_token');

    try {
      final response = await api.post(
        ApiEndpoints.chatbotSendMessage,
        data: {'message': message},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response['status'] != 'success') {
        return Left(ServerFailure('Failed to send message'));
      }

      final data = response['data'] as Map<String, dynamic>;
      final aiResponse = data['response'] as Map<String, dynamic>;

      return Right(ChatbotModel.fromJson(aiResponse));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
