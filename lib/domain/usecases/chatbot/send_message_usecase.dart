import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/chatbot_model.dart';
import 'package:auth/domain/repositories/chatbot_repo.dart';
import 'package:dartz/dartz.dart';

class SendMessageUsecase {
  final ChatbotRepository repository;

  SendMessageUsecase(this.repository);

  Future<Either<Failure, ChatbotModel>> call(String message) {
    return repository.sendMessage(message);
  }
}