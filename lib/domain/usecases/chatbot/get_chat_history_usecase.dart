import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/models/chatbot_model.dart';
import 'package:auth/domain/repositories/chatbot_repo.dart';
import 'package:dartz/dartz.dart';

class GetChatHistoryUsecase {
  final ChatbotRepository repository;

  GetChatHistoryUsecase(this.repository);

  Future<Either<Failure, List<ChatbotModel>>> call() {
    return repository.fetchChatHistory();
  }
}