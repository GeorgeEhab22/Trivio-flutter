import 'package:auth/core/errors/failure.dart';
import 'package:auth/data/core/error/exceptions.dart';
import 'package:auth/data/datasource/comments_remote_datasource.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentsRemoteDataSource remoteDataSource;

  CommentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Comment>>> getComments(
    String postId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  }) async {
    try {
      final models = await remoteDataSource.getComments(
        postId,
        page: page,
        limit: limit,
        sort: sort,
        fields: fields,
        keyword: keyword,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to get comments'));
    }
  }

  @override
  Future<Either<Failure, Comment>> getComment(String commentId) async {
    try {
      final model = await remoteDataSource.getComment(commentId);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to get comment'));
    }
  }

  @override
  Future<Either<Failure, Comment>> addComment({
    required String postId,
    required String text,
    String? parentCommentId,
  }) async {
    try {
      final model = await remoteDataSource.addComment(
        postId: postId,
        text: text,
        parentCommentId: parentCommentId,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to add comment'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment(String commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to delete comment'));
    }
  }

  @override
  Future<Either<Failure, Comment>> editComment({
    required String commentId,
    required String newContent,
  }) async {
    try {
      final model = await remoteDataSource.editComment(
        commentId: commentId,
        newContent: newContent,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to edit comment'));
    }
  }

  @override
  Future<Either<Failure, String?>> reactToComment({
    required String commentId,
    required String reactionType,
    bool isUpdate = false,
    String? reactionId,
  }) async {
    try {
      final updatedReactionId = await remoteDataSource.reactToComment(
        commentId: commentId,
        reactionType: reactionType,
        isUpdate: isUpdate,
        reactionId: reactionId,
      );
      return Right(updatedReactionId);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to react to comment'));
    }
  }

  @override
  Future<Either<Failure, List<Comment>>> getReplies(
    String parentCommentId, {
    int? page,
    int? limit,
    String? sort,
    String? fields,
    String? keyword,
  }) async {
    try {
      final models = await remoteDataSource.getReplies(
        parentCommentId,
        page: page,
        limit: limit,
        sort: sort,
        fields: fields,
        keyword: keyword,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to get replies'));
    }
  }

  @override
  Future<Either<Failure, void>> removeReactionFromComment({
    required String commentId,
    String? reactionId,
  }) async {
    try {
      await remoteDataSource.removeReactionFromComment(
        commentId: commentId,
        reactionId: reactionId,
      );
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to remove reaction from comment'));
    }
  }

  @override
  Future<Either<Failure, Comment>> mentionUsersInComment({
    required String commentId,
    required List<String> mentionedUserIds,
  }) async {
    try {
      final model = await remoteDataSource.mentionUsersInComment(
        commentId: commentId,
        mentionedUserIds: mentionedUserIds,
      );
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Failed to mention users in comment'));
    }
  }
}
