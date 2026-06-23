import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/message.dart';
import 'package:auth/domain/repositories/chat_repo.dart';
import 'package:dartz/dartz.dart';

class GetMessagesUseCase {
  final ChatRepo chatRepo;
  GetMessagesUseCase(this.chatRepo);

  Future<Either<Failure, List<Message>>> call({
    required String chatId,
    int page = 1,
  }) async {
    if (chatId.isEmpty) {
      return const Left(ValidationFailure('Chat ID is required'));
    }
    return await chatRepo.getMessages(chatId: chatId, page: page);
  }
}
