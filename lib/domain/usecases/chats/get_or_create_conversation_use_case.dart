import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/chat.dart';
import 'package:auth/domain/repositories/chat_repo.dart';
import 'package:dartz/dartz.dart';

class GetOrCreateConversationUseCase {
  final ChatRepo chatRepo;
  
  GetOrCreateConversationUseCase(this.chatRepo);

  Future<Either<Failure, Chat>> call({required String targetUserId}) async {
    return await chatRepo.getOrCreateConversation(targetUserId: targetUserId);
  }
}