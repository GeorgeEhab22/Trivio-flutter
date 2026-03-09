import 'package:auth/core/errors/failure.dart';
import 'package:auth/core/validator.dart';
import 'package:auth/domain/entities/comment.dart';
import 'package:auth/domain/repositories/comment_repo.dart';
import 'package:dartz/dartz.dart';

class GetCommentUseCase {
  final CommentRepository repository;

  GetCommentUseCase(this.repository);

  Future<Either<Failure, Comment>> call(String commentId) async {
    if (commentId.trim().isEmpty) {
      return const Left(ValidationFailure('Comment ID is required'));
    }

    if (!Validator.isValidId(commentId)) {
      return const Left(ValidationFailure('Invalid Comment ID format'));
    }

    return await repository.getComment(commentId);
  }
}
