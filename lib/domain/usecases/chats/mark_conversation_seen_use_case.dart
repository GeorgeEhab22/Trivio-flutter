import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/repositories/chat_repo.dart';
import 'package:dartz/dartz.dart';

class MarkConversationSeenUseCase {
  final ChatRepo chatRepo;
  MarkConversationSeenUseCase(this.chatRepo);

  Future<Either<Failure, String>> call({required String conversationId}) async {
    if (conversationId.isEmpty) {
      return const Left(ValidationFailure('Conversation ID is required'));
    }
    return await chatRepo.markConversationAsRead(conversationId: conversationId);
  }
}