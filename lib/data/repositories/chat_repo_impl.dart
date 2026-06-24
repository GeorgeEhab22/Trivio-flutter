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
  Future<Either<Failure, List<Chat>>> getChats({required int page, required String currentUserId}) async {
    try {
      final models = await remoteDataSource.getChats(currentUserId);
     // print('getChats models: $models');
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch chats'));
    }
  }

  @override
  Future<Either<Failure, List<Message>>> getMessages({
    required String chatId,
    int page = 1,
  }) async {
    try {
      final models = await remoteDataSource.getMessages(chatId, page);
    //  print('getMessages models: $models');
      return Right(models);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to fetch messages'));
    }
  }

  @override
  Future<Either<Failure, Chat>> getOrCreateConversation({
    required String targetUserId,
  }) async {
    try {
      final model = await remoteDataSource.getOrCreateConversation(
        targetUserId,
      );
      //  print('getOrCreateConversation model: $model');
      return Right(model);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to get or create conversation'));
    }
  }

  @override
  Future<Either<Failure, String>> markConversationAsRead({
    required String conversationId,
  }) async {
    try {
      await remoteDataSource.markConversationAsRead(conversationId);
      //  print('markConversationAsRead response: $conversationId');
      return const Right('Conversation marked as read');
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to update conversation status'));
    }
  }
}
