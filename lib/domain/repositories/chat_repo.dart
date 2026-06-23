import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/chat.dart';
import 'package:auth/domain/entities/message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  // 1- Get all chats (Inbox)
  Future<Either<Failure, List<Chat>>> getChats({int page = 1});

  // 2- Get messages for a specific chat
  Future<Either<Failure, List<Message>>> getMessages({
    required String chatId, 
    int page = 1,
  });

  // 3- Send a message
  Future<Either<Failure, Message>> sendMessage({
    required String chatId,
    required String text,
  });

  // 4- Mark message as seen
  Future<Either<Failure, String>> markAsSeen({
    required String messageId,
  });
}