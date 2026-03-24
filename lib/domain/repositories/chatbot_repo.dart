import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/chatbot_model.dart';
import 'package:dartz/dartz.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, ChatbotModel>> sendMessage(String message);
  Future<Either<Failure, List<ChatbotModel>>> fetchChatHistory();

}