import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/chat_repo.dart';
import 'package:dartz/dartz.dart';

class MarkMessageSeenUseCase {
  final ChatRepo chatRepo;
  MarkMessageSeenUseCase(this.chatRepo);

  Future<Either<Failure, String>> call({required String messageId}) async {
    if (messageId.isEmpty) {
      return const Left(ValidationFailure('Message ID is required'));
    }
    return await chatRepo.markAsSeen(messageId: messageId);
  }
}