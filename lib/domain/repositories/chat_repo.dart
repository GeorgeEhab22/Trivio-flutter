import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/chat.dart';
import 'package:auth/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  Future<Either<Failure, List<Chat>>> getChats({required int page, required String currentUserId});

  Future<Either<Failure, List<Message>>> getMessages({
    required String chatId, 
    int page = 1,
  });

  Future<Either<Failure, Chat>> getOrCreateConversation({
    required String targetUserId,
  });

  // 4- Mark conversation as read
  Future<Either<Failure, String>> markConversationAsRead({
    required String conversationId,
  });
}