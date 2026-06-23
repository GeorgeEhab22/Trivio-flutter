import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/chat_remote_datasource.dart';
import 'package:auth/domain/entities/chat.dart';
import 'package:auth/domain/entities/message.dart';
import 'package:auth/domain/repositories/chat_repo.dart';
import 'package:dartz/dartz.dart';

class ChatRepoImpl implements ChatRepo {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Chat>>> getChats({int page = 1}) async {
    try {
      final models = await remoteDataSource.getChats(page: page);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch chats'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages({required String chatId, int page = 1}) async {
    try {
      final models = await remoteDataSource.getMessages(chatId: chatId, page: page);
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch messages'));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({required String chatId, required String text}) async {
    try {
      final model = await remoteDataSource.sendMessage(chatId: chatId, text: text);
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to send message'));
    }
  }

  @override
  Future<Either<Failure, String>> markAsSeen({required String messageId}) async {
    try {
      await remoteDataSource.markAsSeen(messageId: messageId);
      return const Right('Message marked as seen');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to update message status'));
    }
  }
}