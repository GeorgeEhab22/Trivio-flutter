import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/datasource/chatbot_remote_datasource.dart';
import 'package:auth/data/models/chatbot_model.dart';
import 'package:auth/domain/repositories/chatbot_repo.dart';
import 'package:dartz/dartz.dart';

class ChatbotRepoImpl implements ChatbotRepository {
  final ChatbotRemoteDatasource remoteDatasource;

  ChatbotRepoImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ChatbotModel>>> fetchChatHistory() async {
    return remoteDatasource.fetchChatHistory();
  }

  @override
  Future<Either<Failure, ChatbotModel>> sendMessage(String message) async {
    return remoteDatasource.sendMessage(message);
  }
}