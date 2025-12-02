import 'package:auth/core/errors/failure.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:dartz/dartz.dart';

abstract class CommentRepository {

  // 8 usecase

  Future<Either<Failure, List<Comment>>> getComments(String postId);
  Future<Either<Failure, Comment>> addComment({
    required String postId,
    required String userId,
    required String text,
    String? parentCommentId, // for replies
  });
  Future<Either<Failure, void>> deleteComment(String commentId);
  Future<Either<Failure, Comment>> editComment({
    required String commentId,
    required String userId,
    required String newContent,
  });
  Future<Either<Failure, Comment>> reactToComment({
    required String commentId,
    required String userId,
    required String reactionType,
  });
  Future<Either<Failure, List<Comment>>>getReplies(String parentCommentId);
  Future<Either<Failure, Comment>> removeReactionFromComment({
    required String commentId,
    required String userId,
  });
  
  Future<Either<Failure, Comment>> mentionUsersInComment({
    required String commentId,
    required List<String> mentionedUserIds,
  });
}
