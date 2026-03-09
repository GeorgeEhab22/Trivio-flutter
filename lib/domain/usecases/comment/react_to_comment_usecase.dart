import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class ReactToCommentUseCase {
  final CommentRepository repository;

  ReactToCommentUseCase(this.repository);

  Future<Either<Failure, String?>> call({
    required String commentId,
    required String reactionType,
    bool isUpdate = false,
    String? reactionId,
  }) async {
    if (commentId.trim().isEmpty) {
      return const Left(ValidationFailure('Comment ID is required'));
    }
    if (!Validator.isValidId(commentId)) {
      return const Left(ValidationFailure('Invalid Comment ID'));
    }

    if (reactionType.trim().isEmpty) {
      return const Left(ValidationFailure('Reaction type is required'));
    }

    final trimmedReactionId = reactionId?.trim();
    if (trimmedReactionId != null &&
        trimmedReactionId.isNotEmpty &&
        !Validator.isValidId(trimmedReactionId)) {
      return const Left(ValidationFailure('Invalid Reaction ID'));
    }

    return await repository.reactToComment(
      commentId: commentId,
      reactionType: reactionType,
      isUpdate: isUpdate,
      reactionId: trimmedReactionId,
    );
  }
}
