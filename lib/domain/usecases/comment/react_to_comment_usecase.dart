import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class ReactToCommentUseCase {
  final CommentRepository repository;

  ReactToCommentUseCase(this.repository);

  Future<Either<Failure, Comment>> call({
    required String commentId,
    required String userId,
    required String reactionType,
  }) async {
    if (commentId.trim().isEmpty) {
      return const Left(ValidationFailure('Comment ID is required'));
    }
    if (!Validator.isValidId(commentId)) {
      return const Left(ValidationFailure('Invalid Comment ID'));
    }

    if (userId.trim().isEmpty) {
      return const Left(ValidationFailure('User ID is required'));
    }
    if (!Validator.isValidId(userId)) {
      return const Left(ValidationFailure('Invalid User ID'));
    }

    if (reactionType.trim().isEmpty) {
      return const Left(ValidationFailure('Reaction type is required'));
    }

    return await repository.reactToComment(
      commentId: commentId,
      userId: userId,
      reactionType: reactionType,
    );
  }
}
