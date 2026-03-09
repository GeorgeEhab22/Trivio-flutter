import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class EditCommentUseCase {
  final CommentRepository repository;

  EditCommentUseCase(this.repository);

  Future<Either<Failure, Comment>> call({
    required String commentId,
    required String newContent,
  }) async {
    if (commentId.trim().isEmpty) {
      return const Left(ValidationFailure('Comment ID is required'));
    }
    if (!Validator.isValidId(commentId)) {
      return const Left(ValidationFailure('Invalid Comment ID'));
    }

    if (newContent.trim().isEmpty) {
      return const Left(ValidationFailure('New comment content cannot be empty'));
    }

    return await repository.editComment(
      commentId: commentId,
      newContent: newContent.trim(),
    );
  }
}
