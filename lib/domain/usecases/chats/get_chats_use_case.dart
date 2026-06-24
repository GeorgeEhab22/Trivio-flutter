import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/chat.dart';
import 'package:auth/domain/repositories/chat_repo.dart';
import 'package:dartz/dartz.dart';

class GetChatsUseCase {
  final ChatRepo chatRepo;
  GetChatsUseCase(this.chatRepo);

  Future<Either<Failure, List<Chat>>> call({required int page,required String currentUserId}) async {
    return await chatRepo.getChats(page: page,currentUserId: currentUserId);
  }
}
