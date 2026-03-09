import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class RemoveReactionFromCommentUseCase {
  final CommentRepository repository;

  RemoveReactionFromCommentUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String commentId,
    String? reactionId,
  }) async {
    if (commentId.trim().isEmpty) {
      return const Left(ValidationFailure('Comment ID is required'));
    }
    if (!Validator.isValidId(commentId)) {
      return const Left(ValidationFailure('Invalid Comment ID'));
    }

    final trimmedReactionId = reactionId?.trim();
    if (trimmedReactionId != null &&
        trimmedReactionId.isNotEmpty &&
        !Validator.isValidId(trimmedReactionId)) {
      return const Left(ValidationFailure('Invalid Reaction ID'));
    }

    return await repository.removeReactionFromComment(
      commentId: commentId,
      reactionId: trimmedReactionId,
    );
  }
}
