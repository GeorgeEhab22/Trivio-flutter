import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/message.dart';
import 'package:auth/domain/repositories/chat_repo.dart';
import 'package:dartz/dartz.dart';

class SendMessageUseCase {
  final ChatRepo chatRepo;
  SendMessageUseCase(this.chatRepo);

  Future<Either<Failure, Message>> call({
    required String chatId,
    required String text,
  }) async {
    if (text.trim().isEmpty) {
      return const Left(ValidationFailure('Message cannot be empty'));
    }
    return await chatRepo.sendMessage(chatId: chatId, text: text.trim());
  }
}